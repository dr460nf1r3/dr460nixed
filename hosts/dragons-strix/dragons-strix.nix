{
  config,
  inputs,
  lib,
  ...
}:
{
  # Individual settings + low-latency Pipewire
  imports = [
    ./hardware-configuration.nix
    ../../nixos/modules/impermanence
    ../../users/nico/nixos.nix
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];

  # Boot options
  boot = {
    initrd.kernelModules = [ "amdgpu" ];
    kernelModules = [
      "btusb"
      "bluetooth"
    ];
    supportedFilesystems = [ "btrfs" ];
  };

  # Hostname of this machine
  networking.hostName = "dragons-strix";

  nix.settings.system-features = [
    "big-parallel"
    "kvm"
  ];

  # Ucode updates for the CPU
  services.ucodenix = {
    enable = true;
    cpuModelId = "00B40F40";
  };

  # The services to use on this machine
  services = {
    pipewire.lowLatency = {
      enable = true;
      quantum = 64;
      rate = 48000;
    };
  };

  hardware.bluetooth.enable = true;

  # Enable a few selected custom settings
  dr460nixed = {
    chromium.enable = true;
    desktops.enable = true;
    development.enable = true;
    gaming.enable = true;
    impermanence = {
      enable = true;
      persistentUsers = [ "nico" ];
    };
    lanzaboote.enable = true;
    nvidia = {
      enable = true;
      prime = {
        enable = true;
        amdgpuBusId = "PCI:105:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    performance.enable = true;
    yubikey.enable = true;
    tailscale.enable = true;
    syncthing = {
      enable = true;
      user = "nico";
      folders = {
        "Music" = {
          id = "ybqqh-as53c";
          path = "/home/nico/Music";
          devices = config.dr460nixed.syncthing.devicesNames;
        };
        "Pictures" = {
          id = "9gj2u-j3m9s";
          path = "/home/nico/Pictures";
          devices = config.dr460nixed.syncthing.devicesNames;
        };
        "Sync" = {
          id = "u62ge-wzsau";
          path = "/home/nico/Sync";
          devices = config.dr460nixed.syncthing.devicesNames;
        };
        "Videos" = {
          id = "nxhpo-c2j5b";
          path = "/home/nico/Videos";
          devices = config.dr460nixed.syncthing.devicesNames;
        };
      };
    };
    smtp = {
      enable = true;
      from = "nico@dr460nf1r3.org";
      passwordeval = "cat /run/secrets/passwords/nico@dr460nf1r3.org";
      user = "nico@dr460nf1r3.org";
    };
    wireguard = {
      enable = true;
      interfaces.nws = {
        address = [ "10.100.1.3/16" ];
        privateKeySecretName = "wireguard/nws";
        peers = [
          {
            publicKey = "4f8Qr2M09vJn8ag6EM9MTK6bYS8jRfz1bqQLeCJ5izo=";
            allowedIPs = [
              "10.100.0.1/32"
              "172.16.0.0/16"
            ];
            endpoint = "138.201.36.152:51820";
          }
        ];
      };
    };
  };

  sops.secrets."wireguard/nws" = {
    neededForUsers = false;
    owner = "systemd-network";
    group = "systemd-network";
    mode = "0640";
  };
  sops.secrets."api_keys/sops" = lib.mkIf config.dr460nixed.development.enable {
    mode = "0600";
    owner = "nico";
    path = "/home/nico/.config/sops/age/keys.txt";
  };
  sops.secrets."api_keys/heroku" = lib.mkIf config.dr460nixed.development.enable {
    mode = "0600";
    owner = "nico";
    path = "/home/nico/.netrc";
  };
  sops.secrets."api_keys/cloudflared" = lib.mkIf config.dr460nixed.development.enable {
    mode = "0600";
    owner = "nico";
    path = "/home/nico/.cloudflared/cert.pem";
  };

  # Autologin due to FDE
  services.displayManager.autoLogin = {
    enable = true;
    user = "nico";
  };
  services.displayManager.defaultSession = "plasma";

  # Force KWin to use the AMD GPU as the primary DRM device
  environment.sessionVariables = {
    KWIN_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";
    KWIN_DRM_USE_MODIFIERS = "0";
    OBS_USE_EGL = "1";
  };

  services = {
    supergfxd.enable = false;
    asusd.enable = true;
  };

  programs.rog-control-center = {
    autoStart = true;
    enable = true;
  };

  # AMD as primary GPU driver
  services.xserver.videoDrivers = [ "amdgpu" ];

  # NixOS stuff
  home-manager.users.nico.home.stateVersion = lib.mkForce "26.05";
  system.stateVersion = "26.05";
}
