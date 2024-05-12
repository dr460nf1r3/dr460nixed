{
  config,
  lib,
  ...
}: {
  imports = [
    ./code-server.nix
    ./hardware-configuration.nix
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

  # This machine is a Proxmox VM
  services.qemuGuest.enable = true;

  dr460nixed = {
    servers = {
      enable = true;
      monitoring = true;
    };
    smtp.enable = true;
    tailscale.enable = true;
    tailscale-tls.enable = true;
  };

  # Hostname of this machine
  networking.hostName = "pve-dragon-1";

  # Some of the services I require
  services.syncthing = {
    enable = true;
    guiAddress = "pve-dragon-1.emperor-mercat.ts.net:8384";
    openDefaultPorts = true;
    settings.options.urAccepted = -1;
  };

  # Paperless document management
  services.paperless = {
    enable = true;
    passwordFile = config.sops.secrets."passwords/paperless".path;
  };
  sops.secrets."passwords/paperless" = {
    mode = "0600";
    owner = config.users.users.paperless.name;
    path = "/var/lib/paperless/cred";
  };

  # Cloudflared tunnel configurations
  services.cloudflared = {
    enable = true;
    tunnels = {
      "ab1428df-f957-44d7-a419-c31a57d68543" = {
        credentialsFile = config.sops.secrets."cloudflared/pve-dragon-1/cred".path;
        default = "http_status:404";
        ingress = {
          "code.dr460nf1r3.org" = {
            service = "http://localhost:4444";
          };
          "paperless.dr460nf1r3.org" = {
            service = "http://localhost:28981";
          };
        };
      };
    };
  };
  sops.secrets."cloudflared/pve-dragon-1/cred" = {
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
  system.stateVersion = "23.11";
}
