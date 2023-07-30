{ config
, lib
, pkgs
, ...
}:
{
  # Individual settings
  imports = [
    ../../configurations/common.nix
    ../../configurations/services/chaotic.nix
    ./hardware-configuration.nix
  ];

  # Boot options
  boot = {
    supportedFilesystems = [ "btrfs" ];
    # Needed to get the touchpad to work
    blacklistedKernelModules = [ "elan_i2c" ];
    # Used to prevent a lot of wifi disconnects
    extraModprobeConfig = ''
      options iwlwifi power_save=0
      options iwlmvm power_scheme=1
    '';
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call zenpower ];
    # The new AMD Pstate driver & needed modules
    kernelModules = [ "acpi_call" "amdgpu" "amd_pstate=passive" ];
    kernelPackages = lib.mkForce pkgs.linuxPackages_xanmod;
    # Prevent the device waking up after going to sleep
    kernelParams = [
      "mem_sleep_default=deep"
    ];
  };

  # Hostname
  networking.hostName = "dragons-ryzen";

  # SSD
  services.fstrim.enable = true;

  # AMD device
  services.hardware.bolt.enable = false;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Bleeding edge Mesa - currently giving a slideshow
  # chaotic.mesa-git.enable = true;

  # Fix an issue
  programs.command-not-found.enable = false;

  # Enable a few selected custom settings
  dr460nixed = {
    boot.enable = false;
    chromium = true;
    desktops.enable = true;
    development.enable = true;
    school = true;
    yubikey = true;
  };

  # Garuda Nix subsystem option
  garuda = {
    btrfs-maintenance = {
      deduplication = true;
      enable = true;
    };
    dr460nized.enable = true;
    gaming.enable = true;
    garuda-chroot = {
      boot-uuid = "B101-5FCE";
      enable = true;
      user = "nico";
      root-uuid = "bec8156c-10e5-4f23-9e51-21b453d9fddd";
    };
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
  sops.secrets."ssh_keys/id_rsa" = {
    mode = "0600";
    owner = config.users.users.nico.name;
    path = "/home/nico/.ssh/id_rsa";
  };

  # NixOS stuff
  system.stateVersion = "22.11";
}
