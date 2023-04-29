{ pkgs
, config
, lib
, ...
}: {
  # Individual settings
  imports = [
    ../../configurations/common.nix
    ./hardware-configuration.nix
    "${builtins.fetchGit {
      url = "https://github.com/NixOS/nixos-hardware.git";
      rev = "f38f9a4c9b2b6f89a5778465e0afd166a8300680";
    }}/lenovo/thinkpad/t470s"
    ./hardware-configuration.nix
  ];

  # Bootloader
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call ];
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "usbhid" "sd_mod" ];
    loader = {
      systemd-boot = {
        consoleMode = "max";
        editor = false;
        enable = true;
      };
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
    supportedFilesystems = [ "btrfs" ];
  };

  # Hostname
  networking.hostName = "tv-nixos";

  # SSD
  services.fstrim.enable = true;

  # Enable a few selected custom settings
  dr460nixed = {
    auto-upgrade = true;
    desktops.enable = true;
    performance-tweaks.enable = true;
  };

  # Enable the touchpad
  environment.systemPackages = with pkgs; [ libinput ];

  # Home-manager desktop configuration
  home-manager.users."nico" = import ../../configurations/home/desktops.nix;

  # Currently plagued by https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = false;

  # NixOS stuff
  system.stateVersion = "22.11";
}
