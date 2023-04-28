{ config
, lib
, pkgs
, ...
}:
{
  # Individual settings
  imports = [
    # ../../configurations/common.nix
    #../../configurations/desktops/impermanence.nix
    #  ../../configurations/services/chaotic.nix
    ./hardware-configuration.nix
  ];

  # Use Lanzaboote for secure boot
  boot = {
    supportedFilesystems = [ "zfs" ];
    zfs = {
      enableUnstable = true;
      requestEncryptionCredentials = false;
    };
    # Needed to get the touchpad to work
    blacklistedKernelModules = [ "elan_i2c" ];
    # The new AMD Pstate driver & needed modules
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    loader.systemd-boot.enable = true;
    loader.efi.canTouchEfiVariables = true;
  };

  # Network configuration & id for ZFS
  networking.hostId = "9c8011ee";
  networking.hostName = "slim-lair";

  # Bleeding edge Mesa
  chaotic.mesa-git.enable = true;

  services.xserver = {
    windowManager.bspwm.enable = true;
    enable = true;
  };


  # Neeeded for lzbt
  #boot.bootspec.enable = true;

  # Home-manager desktop configuration
  #home-manager.users."nico" = import ../../configurations/home/desktops.nix;



  # NixOS stuff
  system.stateVersion = "22.11";
}
