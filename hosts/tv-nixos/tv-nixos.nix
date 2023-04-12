{ pkgs
, config
, lib
, ...
}: {
  # Individual settings
  imports = [
    ../../configurations/common.nix
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        consoleMode = "max";
        editor = false;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
    supportedFilesystems = [ "btrfs" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
  };

  # Hostname
  networking.hostName = "tv-nixos";

  # Correct configurations to use on this device, taken from the hardware repo
  boot = {
    extraModprobeConfig = ''
      options bbswitch use_acpi_to_detect_card_state=1
      options thinkpad_acpi force_load=1 fan_control=1
    '';
    kernelModules = [ "tpm-rng" "i915" ];
  };
  environment.variables = {
    VDPAU_DRIVER =
      lib.mkIf config.hardware.opengl.enable (lib.mkDefault "va_gl");
  };
  hardware.cpu.intel.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
  hardware.opengl.extraPackages = with pkgs; [
    intel-media-driver
    libvdpau-va-gl
    vaapiIntel
  ];

  # SSD
  services.fstrim.enable = true;

  # This is not supported
  services.hardware.bolt.enable = false;

  # Enable the touchpad
  environment.systemPackages = with pkgs; [ libinput ];

  # Home-manager desktop configuration
  home-manager.users."nico" = import ../../configurations/home/desktops.nix;

  # Currently plagued by https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = false;

  # A few secrets
  sops.secrets."gsconnect/tv-nixos/private" = {
    path = "/home/nico/.config/gsconnect/private.pem";
    mode = "0600";
    owner = config.users.users.nico.name;
  };
  sops.secrets."gsconnect/tv-nixos/certificate" = {
    path = "/home/nico/.config/gsconnect/certificate.pem";
    mode = "0600";
    owner = config.users.users.nico.name;
  };

  # NixOS stuff
  system.stateVersion = "22.11";
}
