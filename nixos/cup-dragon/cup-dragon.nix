{
  config,
  lib,
  ...
}: {
  imports = [
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
  networking.hostName = "cup-dragon";

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
        ingress = {};
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
