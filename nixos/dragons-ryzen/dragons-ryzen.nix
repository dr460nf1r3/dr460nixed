{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  # Individual settings + low-latency Pipewire
  imports = [
    ./hardware-configuration.nix
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];

  # Boot options
  boot = {
    # Needed to get the touchpad working
    blacklistedKernelModules = ["elan_i2c"];
    extraModulePackages = with config.boot.kernelPackages; [zenpower];
    # Override the per-default false value since we need this in order for GNS
    # boot menu to be generated
    loader.grub.enable = lib.mkForce true;
  };

  # Hostname of this machine
  networking.hostName = "dragons-ryzen";

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
    desktops.enable = true;
    development.enable = true;
    gaming.enable = true;
    performance = true;
    remote-build = {
      enable = true;
      host = "remote-build";
      port = 666;
      trustedPublicKey = "immortalis:8vrLBvFoMiKVKRYD//30bhUBTEEiuupfdQzl2UoMms4=";
      user = "nico";
    };
    school = true;
    tailscale = {
      enable = true;
      extraUpArgs = [
        "--accept-dns"
        "--accept-risk=lose-ssh"
        "--accept-routes"
        "--ssh"
      ];
    };
    yubikey = true;
  };

  # This device is partly managed by the Garuda installation on top
  garuda = {
    garuda-chroot = {
      boot-uuid = "80CC-7CE9";
      enable = true;
      root-uuid = "1776871a-f356-4293-b025-19186473bff1";
      user = "nico";
    };
    managed.config = ../../garuda-managed.json;
    subsystem.enable = true;
  };

  # Workaround build error for now
  nixpkgs.config.permittedInsecurePackages = ["electron-24.8.6"];

  # Virt-manager requires iptables to let guests have internet
  networking.nftables.enable = lib.mkForce false;

  # Mcpe launcher
  services.flatpak.enable = true;

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

  # For some reason Bluetooth only works after un-/reloading
  # the btusb kernel module
  systemd.services.fix-bluetooth = {
    wantedBy = ["multi-user.target"];
    description = "Fix bluetooth connection";
    path = with pkgs; [kmod];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "execstart" ''
        modprobe -r btusb
        sleep 1
        modprobe btusb
      '';
    };
  };

  # NixOS stuff
  system.stateVersion = "23.11";
}
