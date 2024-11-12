{
  config,
  lib,
  ...
}: {
  imports = [
    ./forgejo.nix
    ./hardware-configuration.nix
    ./matrix.nix
    ./wakapi.nix
  ];

  # Boot options
  boot = {
    # Required for using app connectors in Tailscale
    kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    };
    loader = {
      grub = {
        device = "nodev";
        efiInstallAsRemovable = true;
        efiSupport = true;
        enable = lib.mkForce true;
      };
      efi.efiSysMountPoint = "/boot";
    };
  };

  # This machine is a VM
  services = {
    nginx.enable = true;
    openssh.ports = [666];
    qemuGuest.enable = true;
  };

  networking = {
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens3";
    };
    hostName = "cup-dragon";
    interfaces.ens3.ipv6.addresses = [
      {
        address = "2a03:4000:42:4c::";
        prefixLength = 64;
      }
    ];
  };

  dr460nixed = {
    compose-runner = {
      "cup-dragon" = {
        source = ../../compose/cup-dragon;
      };
    };
    servers = {
      enable = true;
      monitoring = true;
    };
    smtp.enable = true;
    tailscale.enable = true;
  };

  # Some of the services I require
  services.syncthing = {
    enable = true;
    guiAddress = "cup-dragon.emperor-mercat.ts.net:8384";
    openDefaultPorts = true;
    settings.options.urAccepted = -1;
  };

  # Cloudflared tunnel configurations
  services.cloudflared = {
    enable = true;
    tunnels = {
      "76dc88f1-c290-4405-a1be-9d0249e376d3" = {
        credentialsFile = config.sops.secrets."cloudflared/cup-dragon/cred".path;
        default = "http_status:404";
        ingress = {
          "uptime.dr460nf1r3.org" = "http://127.0.0.1:3001";
          "dev.dr460nf1r3.org" = "http://127.0.0.1:3010";
        };
      };
    };
  };
  sops.secrets."cloudflared/cup-dragon/cred" = {
    mode = "0600";
    owner = config.users.users.cloudflared.name;
    path = "/var/lib/cloudflared/cred";
  };

  # For running containers from within code-server
  virtualisation = {
    containers.enable = true;
    podman = {
      autoPrune.enable = true;
      defaultNetwork.settings.dns_enabled = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      enable = true;
    };
  };

  # NixOS stuff
  system.stateVersion = "24.05";
}