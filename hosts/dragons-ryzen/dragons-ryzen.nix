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
    supportedFilesystems = [ "zfs" ];
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

  # Useful ZFS maintenance
  services.zfs = {
    autoScrub.enable = true;
    trim.enable = true;
  };
  programs.msmtp = {
    enable = true;
    setSendmail = true;
    defaults = {
      aliases = "/etc/aliases";
      auth = "login";
      port = 465;
      tls = "on";
      tls_starttls = "off";
      tls_trust_file = "/etc/ssl/certs/ca-certificates.crt";
    };
    accounts = {
      default = {
        from = "nico@dr460nf1r3.org";
        host = "mail.garudalinux.net";
        passwordeval = "cat /run/secrets/passwords/nico@dr460nf1r3.org";
        user = "nico@dr460nf1r3.org";
      };
    };
  };
  environment.etc = {
    "aliases".text = ''
      root: nico@dr460nf1r3.org
    '';
  };
  services.zfs.zed.settings = {
    ZED_DEBUG_LOG = "/tmp/zed.debug.log";
    ZED_EMAIL_ADDR = [ "root" ];
    ZED_EMAIL_PROG = "${pkgs.msmtp}/bin/msmtp";
    ZED_EMAIL_OPTS = "@ADDRESS@";

    ZED_NOTIFY_INTERVAL_SECS = 3600;
    ZED_NOTIFY_VERBOSE = true;

    ZED_USE_ENCLOSURE_LEDS = true;
    ZED_SCRUB_AFTER_RESILVER = true;
  };
  # this option does not work; will return error
  services.zfs.zed.enableMail = false;

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
    yubikey = true;
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

  # Lets use Waydroid here
  virtualisation.waydroid.enable = true;

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
