{lib, ...}: {
  # Individual settings + low-latency Pipewire
  imports = [
    ./hardware-configuration.nix
  ];

  # Boot options
  boot = {
    loader = {
      grub = {
        device = "nodev";
        efiInstallAsRemovable = true;
        efiSupport = true;
        enable = lib.mkForce true;
      };
      efi.efiSysMountPoint = "/boot";
    };
  };

  # Hostname of this machine
  networking.hostName = "pve-dragon-1";

  # Home-manager individual settings
  home-manager.users."nico" = import ../../home-manager/nico/nico.nix;

  # NixOS stuff
  system.stateVersion = "23.11";
}
