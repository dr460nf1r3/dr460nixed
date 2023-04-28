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
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call zenpower ];
    kernelModules = [ "acpi_call" "amdgpu" "amd-pstate=passive" ];
    kernelPackages = pkgs.linuxPackages_xanmod_latest;
    kernelParams = [ "initcall_blacklist=acpi_cpufreq_init" ];
    lanzaboote = {
      configurationLimit = 20;
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    loader.efi.canTouchEfiVariables = true;
  };

  # Network configuration & id for ZFS
  networking.hostId = "9c8011ee";
  networking.hostName = "slim-lair";

  # SSD
  services.fstrim.enable = true;

  # ZFS scrubbing
  services.zfs.autoScrub.enable = true;

  # AMD device
  services.hardware.bolt.enable = false;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # enables AMDVLK & OpenCL support
  hardware.opengl.extraPackages = with pkgs; [
    amdvlk
    rocm-opencl-icd
    rocm-opencl-runtime
  ];
  hardware.opengl.extraPackages32 = with pkgs; [
    driversi686Linux.amdvlk
  ];

  # Bleeding edge Mesa - current broken on my flake, 
  # investiations are going on
  # chaotic.mesa-git.enable = true;

  # Enable a few selected custom settings
  dr460nixed = {
    boot.enable = true;
    chromium = true;
    common.enable = true;
    desktops.enable = true;
    development.enable = true;
    gaming.enable = true;
    locales.enable = true;
    performance-tweaks.enable = true;
    school = true;
    shells.enable = true;
    yubikey = true;
  };

  # Workaround to enable HIP
  systemd.tmpfiles.rules = [
    "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.hip}"
  ];

  # Currently plagued by https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  # RADV video decode & general usage
  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
    RADV_VIDEO_DECODE = "1";
  };

  # Virtualisation / Containerization
  virtualisation.containers.storage.settings = {
    storage = {
      driver = "zfs";
      graphroot = "/var/lib/containers/storage";
      runroot = "/run/containers/storage";
      options.zfs = {
        fsname = "zroot/containers";
        mountopt = "nodev";
      };
    };
  };

  # Enable the touchpad & secure boot, as well as add the ipman script
  environment.systemPackages = with pkgs; [ libinput sbctl zenmonitor ];

  # Neeeded for lzbt
  boot.bootspec.enable = true;

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
