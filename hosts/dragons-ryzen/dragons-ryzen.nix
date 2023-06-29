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
    kernelParams = [ "initcall_blacklist=acpi_cpufreq_init" ];
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
  };

  # Hostname & working around Tailscale DNS causing major issues on this device 
  # see https://github.com/tailscale/tailscale/issues/8223 for details
  networking = {
    hostName = "dragons-ryzen";
    hosts = {
      "100.106.219.37" = [ "kde-dragon" "kde-dragon.kanyu-bushi.ts.net" ];
      "100.108.204.61" = [ "chaotic-dragon" "chaotic-dragon.kanyu-bushi.ts.net" ];
      "100.109.201.47" = [ "garuda-mail" "garuda-mail.kanyu-bushi.ts.net" ];
      "100.110.85.114" = [ "esxi-repo" "esxi-repo.kanyu-bushi.ts.net" ];
      "100.115.146.77" = [ "esxi-forum" "esxi-forum.kanyu-bushi.ts.net" ];
      "100.116.167.11" = [ "dragon-pixel" "dragon-pixel.emperor-mercat.ts.net" ];
      "100.120.171.12" = [ "tv-nixos" "tv-nixos.emperor-mercat.ts.net" ];
      "100.120.178.79" = [ "garuda-build" "garuda-build.kanyu-bushi.ts.net" ];
      "100.64.127.121" = [ "web-dragon" "web-dragon.kanyu-bushi.ts.net" ];
      "100.66.229.30" = [ "esxi-web" "esxi-web.kanyu-bushi.ts.net" ];
      "100.68.56.130" = [ "monitor-dragon" "monitor-dragon.kanyu-bushi.ts.net" ];
      "100.75.73.33" = [ "google-dragon" "google-dragon.emperor-mercat.ts.net" ];
      "100.78.91.66" = [ "esxi-web-two" "esxi-web-two.kanyu-bushi.ts.net" ];
      "100.82.172.37" = [ "esxi-build" "esxi-build.kanyu-bushi.ts.net" ];
      "100.83.10.105" = [ "backup-dragon" "backup-dragon.kanyu-bushi.ts.net" ];
      "100.85.210.126" = [ "rpi-dragon" "rpi-dragon.emperor-mercat.ts.net" ];
      "100.86.102.115" = [ "oracle-dragon" "oracle-dragon.emperor-mercat.ts.net" ];
      "100.93.185.32" = [ "esxi-cloud" "esxi-cloud.kanyu-bushi.ts.net" ];
      "fd7a:115c:a1e0:ab12:4843:cd96:6242:e51e" = [ "esxi-web" "esxi-web.kanyu-bushi.ts.net" ];
      "fd7a:115c:a1e0:ab12:4843:cd96:6244:3882" = [ "monitor-dragon" "monitor-dragon.kanyu-bushi.ts.net" ];
      "fd7a:115c:a1e0:ab12:4843:cd96:624b:4921" = [ "google-dragon" "google-dragon.emperor-mercat.ts.net" ];
      "fd7a:115c:a1e0:ab12:4843:cd96:624e:5b42" = [ "esxi-web-two" "esxi-web-two.kanyu-bushi.ts.net" ];
      "fd7a:115c:a1e0:ab12:4843:cd96:6252:ac25" = [ "esxi-build" "esxi-build.kanyu-bushi.ts.net" ];
      "fd7a:115c:a1e0:ab12:4843:cd96:6253:a69" = [ "backup-dragon" "backup-dragon.kanyu-bushi.ts.net" ];
      "fd7a:115c:a1e0:ab12:4843:cd96:6255:d27e" = [ "oracle-dragon" "oracle-dragon.emperor-mercat.ts.net" ];
      "fd7a:115c:a1e0:ab12:4843:cd96:6256:6673" = [ "rpi-dragon" "rpi-dragon.emperor-mercat.ts.net" ];
      "fd7a:115c:a1e0:ab12:4843:cd96:625d:b920" = [ "esxi-cloud" "esxi-cloud.kanyu-bushi.ts.net" ];
      "fd7a:115c:a1e0:ab12:4843:cd96:626a:db25" = [ "kde-dragon" "kde-dragon.kanyu-bushi.ts.net" ];
      "fd7a:115c:a1e0:ab12:4843:cd96:6240:7f79" = [ "web-dragon" "web-dragon.kanyu-bushi.ts.net" ];
      "fd7a:115c:a1e0:ab12:4843:cd96:626c:cc3d" = [ "chaotic-dragon" "chaotic-dragon.kanyu-bushi.ts.net" ];
      "fd7a:115c:a1e0:ab12:4843:cd96:626d:c92f" = [ "garuda-mail" "garuda-mail.kanyu-bushi.ts.net" ];
      "fd7a:115c:a1e0:ab12:4843:cd96:626e:5572" = [ "esxi-repo" "esxi-repo.kanyu-bushi.ts.net" ];
      "fd7a:115c:a1e0:ab12:4843:cd96:6273:924d" = [ "esxi-forum" "esxi-forum.kanyu-bushi.ts.net" ];
      "fd7a:115c:a1e0:ab12:4843:cd96:6274:a70b" = [ "dragon-pixel" "dragon-pixel.emperor-mercat.ts.net" ];
      "fd7a:115c:a1e0:ab12:4843:cd96:6278:ab0c" = [ "tv-nixos" "tv-nixos.emperor-mercat.ts.net" ];
      "fd7a:115c:a1e0:ab12:4843:cd96:6278:b24f" = [ "garuda-build" "garuda-build.kanyu-bushi.ts.net" ];
    };
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
    school = true;
    yubikey = true;
  };

  # Garuda Nix subsystem option
  garuda = {
    dr460nized.enable = true;
    performance-tweaks.enable = true;
    garuda-chroot.enable = true;
    gaming.enable = true;
    performance-tweaks.cachyos-kernel = true;
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
