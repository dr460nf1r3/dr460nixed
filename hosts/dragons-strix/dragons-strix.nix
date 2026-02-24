{
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
    chromium = true;
    desktops.enable = true;
    development.enable = true;
    gaming.enable = true;
    impermanence.enable = true;
    lanzaboote.enable = true;
    nvidia = {
      enable = true;
      prime = {
        enable = true;
        amdgpuBusId = "PCI:105:0:0";
        nvidiaBusId = "PCI:1:0:0";
      };
    };
    performance = true;
    yubikey = true;
    tailscale.enable = true;
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

  # Garuda Nix subsystem modules
  dr460nixed.garuda = {
    btrfs-maintenance = {
      deduplication = true;
      enable = true;
      uuid = "b32bdea7-52c3-4885-a088-c427aa05ae1c";
    };
  };

  # Autologin due to FDE
  services.displayManager.autoLogin = {
    enable = true;
    user = "nico";
  };
  services.displayManager.defaultSession = "plasma";

  # Force KWin to use the AMD GPU as the primary DRM device
  # This fixes GL_FRAMEBUFFER_INCOMPLETE_ATTACHMENT errors on hybrid graphics
  environment.sessionVariables = {
    KWIN_DRM_DEVICES = "/dev/dri/card1:/dev/dri/card0";
    KWIN_DRM_USE_MODIFIERS = "0";
    OBS_USE_EGL = "1";
  };

  services = {
    supergfxd.enable = false;
    asusd = {
      enable = true;
      enableUserService = true;
    };
  };

  programs.rog-control-center.enable = true;
  programs.rog-control-center.autoStart = true;

  # AMD as primary GPU driver
  services.xserver.videoDrivers = [ "amdgpu" ];

  # NixOS stuff
  home-manager.users.nico.home.stateVersion = lib.mkForce "26.05";
  system.stateVersion = "26.05";
}
