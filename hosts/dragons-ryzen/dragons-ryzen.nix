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
    # The new AMD Pstate driver & needed modules
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call zenpower ];
    kernelModules = [ "acpi_call" "amdgpu" "amd-pstate=passive" ];
    kernelParams = [ "initcall_blacklist=acpi_cpufreq_init" ];
  };

  # Hostname
  networking.hostName = "dragons-ryzen";

  # SSD
  services.fstrim.enable = true;

  # AMD device
  services.hardware.bolt.enable = false;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Fix the fucking Wifi - https://github.com/NixOS/nixpkgs/issues/18410
  boot.extraModprobeConfig = ''
    options iwlwifi power_save=0
  '';

  # Bleeding edge Mesa - currently giving a slideshow
  # chaotic.mesa-git.enable = true;

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
    dr460nized.enable = true;
    gaming.enable = true;
    garuda-chroot = {
      boot-uuid = "B101-5FCE";
      enable = true;
      root-uuid = "bec8156c-10e5-4f23-9e51-21b453d9fddd";
    };
    performance-tweaks = {
      cachyos-kernel = true;
      enable = true;
    };
    subsystem.imported-users.shared-home = true;
  };

  # Virt-manager requires iptables to let guests have internet
  networking.nftables.enable = lib.mkForce false;

  # BTRFS stuff (filesystem deduplication in the background)
  services.beesd.filesystems = {
    root = {
      spec = "LABEL=OS";
      hashTableSizeMB = 2048;
      verbosity = "crit";
      extraOptions = [ "--loadavg-target" "1.0" ];
    };
  };
  services.btrfs.autoScrub.enable = true;

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
