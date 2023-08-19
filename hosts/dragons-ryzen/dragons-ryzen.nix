{ config
, lib
, pkgs
, ...
}:
{
  # Individual settings
  imports = [
    ../../configurations/common.nix
    ../../configurations/desktops/impermanence.nix
    ../../configurations/services/chaotic.nix
    ./hardware-configuration.nix
  ];

  # Boot options
  boot = {
    # Needed to get the touchpad to work
    blacklistedKernelModules = [ "elan_i2c" ];
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call zenpower ];
    # The new AMD Pstate driver & needed modules
    kernelModules = [ "acpi_call" "amdgpu" "amd_pstate=guided" ];
    # Prevent the device waking up after going to sleep
    kernelParams = [ "mem_sleep_default=deep" ];
  };

  # Hostname & hostId for ZFS
  networking = {
    hostId = "9c8011ee";
    hostName = "dragons-ryzen";
  };

  # AMD device
  services.hardware.bolt.enable = false;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Enable a few selected custom settings
  dr460nixed = {
    chromium = true;
    desktops.enable = true;
    development.enable = true;
    lanzaboote.enable = true;
    school = true;
    smtp.enable = true;
    tailscale = {
      enable = true;
      extraUpArgs = [
        "--accept-dns"
        "--accept-routes"
        "--ssh"
      ];
    };
    yubikey = true;
    zfs = {
      enable = true;
      sendMails = true;
    };
  };

  # Garuda Nix subsystem option
  garuda = {
    dr460nized.enable = true;
    gaming.enable = true;
    performance-tweaks = {
      cachyos-kernel = true;
      enable = true;
    };
  };

  # Virt-manager requires iptables to let guests have internet
  networking.nftables.enable = lib.mkForce false;

  # Currently plagued by https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  # RADV video decode & general usage
  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
    RADV_VIDEO_DECODE = "1";
  };

  # Enable the touchpad & secure boot, as well as add the ipman script
  environment.systemPackages = with pkgs; [ libinput radeontop zenmonitor ];

  # Home-manager desktop configuration
  home-manager.users."nico" = import ../../configurations/home/desktops.nix;

  # A few secrets
  sops.secrets."machine-id/slim-lair" = {
    path = "/etc/machine-id";
    mode = "0600";
  };
  sops.secrets."passwords/nico@dr460nf1r3.org" = {
    mode = "0600";
    path = "/run/secrets/passwords/nico@dr460nf1r3.org";
  };
  sops.secrets."ssh_keys/id_rsa" = {
    mode = "0600";
    owner = config.users.users.nico.name;
    path = "/home/nico/.ssh/id_rsa";
  };

  # NixOS stuff
  system.stateVersion = "22.11";
}
