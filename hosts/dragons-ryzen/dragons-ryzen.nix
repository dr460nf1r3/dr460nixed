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

  # Use Lanzaboote for secure boot
  boot = {
    supportedFilesystems = [ "btrfs" ];
    # Needed to get the touchpad to work
    blacklistedKernelModules = [ "elan_i2c" ];
    # The new AMD Pstate driver & needed modules
    extraModulePackages = with config.boot.kernelPackages; [ acpi_call zenpower ];
    kernelModules = [ "acpi_call" "amdgpu" "amd-pstate=passive" ];
    kernelPackages = pkgs.linuxPackages_cachyos;
    kernelParams = [ "initcall_blacklist=acpi_cpufreq_init" ];
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  # Hostname & fixing https://github.com/tailscale/tailscale/issues/6850 
  # probably because I'm using wifi tethering via phone mostly
  networking = {
    hostName = "dragons-ryzen";
    nameservers = lib.mkForce [ "100.86.102.115" "1.1.1.1" ];
  };

  # SSD
  services.fstrim.enable = true;

  # AMD device
  services.hardware.bolt.enable = false;
  services.xserver.videoDrivers = [ "amdgpu" ];

  # Bleeding edge Mesa - currently giving a slideshow
  # chaotic.mesa-git.enable = true;

  # Enable a few selected custom settings
  dr460nixed = {
    chromium = true;
    desktops.enable = true;
    development.enable = true;
    gaming.enable = true;
    garuda-chroot = {
      enable = true;
      root = "/var/lib/machines/garuda";
    };
    performance-tweaks.enable = true;
    school = true;
    yubikey = true;
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

  # Workaround for Tailscale DNS causing major issues on this machine
  # see https://github.com/tailscale/tailscale/issues/8223 for details
  networking.hosts = {
    "100.106.219.37" = [ "kde-dragon" ];
    "100.108.204.61" = [ "chaotic-dragon" ];
    "100.109.201.47" = [ "garuda-mail" ];
    "100.110.85.114" = [ "esxi-repo" ];
    "100.115.146.77" = [ "esxi-forum" ];
    "100.116.167.11" = [ "dragon-pixel" ];
    "100.120.171.12" = [ "tv-nixos" ];
    "100.120.178.79" = [ "garuda-build" ];
    "100.64.127.121" = [ "web-dragon" ];
    "100.66.229.30" = [ "esxi-web" ];
    "100.68.56.130" = [ "monitor-dragon" ];
    "100.75.73.33" = [ "google-dragon" ];
    "100.78.91.66" = [ "esxi-web-two" ];
    "100.82.172.37" = [ "esxi-build" ];
    "100.83.10.105" = [ "backup-dragon" ];
    "100.85.210.126" = [ "rpi-dragon" ];
    "100.86.102.115" = [ "oracle-dragon" ];
    "100.93.185.32" = [ "esxi-cloud" ];
    "fd7a:115c:a1e0:ab12:4843:cd96:6242:e51e" = [ "esxi-web" ];
    "fd7a:115c:a1e0:ab12:4843:cd96:6244:3882" = [ "monitor-dragon" ];
    "fd7a:115c:a1e0:ab12:4843:cd96:624b:4921" = [ "google-dragon" ];
    "fd7a:115c:a1e0:ab12:4843:cd96:624e:5b42" = [ "esxi-web-two" ];
    "fd7a:115c:a1e0:ab12:4843:cd96:6252:ac25" = [ "esxi-build" ];
    "fd7a:115c:a1e0:ab12:4843:cd96:6253:a69" = [ "backup-dragon" ];
    "fd7a:115c:a1e0:ab12:4843:cd96:6255:d27e" = [ "oracle-dragon" ];
    "fd7a:115c:a1e0:ab12:4843:cd96:6256:6673" = [ "rpi-dragon" ];
    "fd7a:115c:a1e0:ab12:4843:cd96:625d:b920" = [ "esxi-cloud" ];
    "fd7a:115c:a1e0:ab12:4843:cd96:626a:db25" = [ "kde-dragon" ];
    "fd7a:115c:a1e0:ab12:4843:cd96:6240:7f79" = [ "web-dragon" ];
    "fd7a:115c:a1e0:ab12:4843:cd96:626c:cc3d" = [ "chaotic-dragon" ];
    "fd7a:115c:a1e0:ab12:4843:cd96:626d:c92f" = [ "garuda-mail" ];
    "fd7a:115c:a1e0:ab12:4843:cd96:626e:5572" = [ "esxi-repo" ];
    "fd7a:115c:a1e0:ab12:4843:cd96:6273:924d" = [ "esxi-forum" ];
    "fd7a:115c:a1e0:ab12:4843:cd96:6274:a70b" = [ "dragon-pixel" ];
    "fd7a:115c:a1e0:ab12:4843:cd96:6278:ab0c" = [ "tv-nixos" ];
    "fd7a:115c:a1e0:ab12:4843:cd96:6278:b24f" = [ "garuda-build" ];
  };

  # NixOS stuff
  system.stateVersion = "22.11";
}
