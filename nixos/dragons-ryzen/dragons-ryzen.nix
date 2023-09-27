{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  # Individual settings + low-latency Pipewire
  imports = [
    ../modules/impermanence.nix
    ./hardware-configuration.nix
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];

  # Boot options
  boot = {
    # Needed to get the touchpad working
    blacklistedKernelModules = ["elan_i2c"];
    extraModulePackages = with config.boot.kernelPackages; [zenpower];
    # Without this, bluetooth does not work
    kernelModules = ["btintel"];
  };

  # Hostname & hostId for ZFS
  networking = {
    hostId = "9c8011ee";
    hostName = "dragons-ryzen";
  };

  # The services to use on this machine
  services = {
    hardware.bolt.enable = false;
    pipewire.lowLatency = {
      enable = true;
      quantum = 64;
      rate = 48000;
    };
    xserver = {
      displayManager.sddm.settings = {
        Autologin = {
          Session = "plasma";
          User = "nico";
        };
      };
      videoDrivers = ["amdgpu"];
    };
  };

  # Enable a few selected custom settings
  dr460nixed = {
    chromium = true;
    desktops.enable = true;
    development.enable = true;
    gaming.enable = true;
    lanzaboote.enable = true;
    nix-super.enable = true;
    performance = true;
    remote-build = {
      enable = true;
      host = "remote-build";
      port = 666;
      trustedPublicKey = "immortalis:8vrLBvFoMiKVKRYD//30bhUBTEEiuupfdQzl2UoMms4=";
      user = "nico";
    };
    school = true;
    smtp.enable = lib.mkForce false; # until python2.7-oildev is fixed
    tailscale = {
      enable = true;
      extraUpArgs = [
        "--accept-dns"
        "--accept-risk=lose-ssh"
        "--accept-routes"
        "--ssh"
      ];
    };
    # syncthing = {
    #   cert = config.sops.secrets."syncthing/dragons-ryzen_cert".path;
    #   devices = {
    #     pixel-6 = {
    #       id = "EBJDXV-7KUQ2N3-EMDYCJR-XEFBULZ-WGBNLIA-O27UFJM-PZAULDR-J2L3XQX";
    #     };
    #     tv-nixos = {
    #       id = "7BCXVUAC-LWRHPS5-YHQU3JW-Z5EUI7D-U3TUXMB-F65I2BI-KWDYDAB-BLHNGA5";
    #     };
    #   };
    #   devicesNames = [
    #     "pixel-6"
    #     "tv-nixos"
    #   ];
    #   enable = true;
    #   key = config.sops.secrets."syncthing/dragons-ryzen_cert".path;
    #   user = "nico";
    # };
    yubikey = true;
    zfs = {
      enable = true;
      sendMails = true;
    };
  };

  # Lets try mesa_git again!
  chaotic.mesa-git.enable = true;

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
  environment.systemPackages = with pkgs; [libinput radeontop zenmonitor];

  # Home-manager individual settings
  home-manager.users."nico" = import ../../home-manager/nico/nico.nix;

  # A few secrets
  sops.secrets = {
    "machine-id/slim-lair" = {
      path = "/etc/machine-id";
      mode = "0600";
    };
    "passwords/nico@dr460nf1r3.org" = {
      mode = "0600";
      path = "/run/secrets/passwords/nico@dr460nf1r3.org";
    };
    # "ssh_keys/id_rsa" = {
    #   mode = "0600";
    #   owner = config.users.users.nico.name;
    #   path = "/home/nico/.ssh/id_rsa";
    # };
    # "syncthing/dragons-ryzen_key" = {
    #   mode = "0600";
    #   owner = config.users.users.nico.name;
    #   path = "/home/nico/.config/syncthing/key.pem";
    # };
    # "syncthing/dragons-ryzen_cert" = {
    #   mode = "0640";
    #   owner = config.users.users.nico.name;
    #   path = "/home/nico/.config/syncthing/cert.pem";
    # };
  };

  # NixOS stuff
  system.stateVersion = "23.11";
}
