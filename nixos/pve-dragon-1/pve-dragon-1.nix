{
  config,
  lib,
  ...
}: {
  imports = [./hardware-configuration.nix];

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

  # Cloudflared tunnel configurations
  services.cloudflared = {
    enable = true;
    tunnels = {
      "ba8379f8-de1c-474f-89ab-8d63e6bd1969" = {
        credentialsFile = config.sops.secrets."cloudflared/pve-dragon-1/cred".path;
        default = "http_status:404";
        ingress = {
        };
      };
    };
  };
  sops.secrets."cloudflared/pve-dragon-1/cred" = {
    mode = "0600";
    owner = config.users.users.cloudflared.name;
    path = "/run/secrets/cloudflared/pve-dragon-1/cred";
  };

  # NixOS stuff
  system.stateVersion = "23.11";
}
