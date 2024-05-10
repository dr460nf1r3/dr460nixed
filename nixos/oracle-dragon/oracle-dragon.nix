{
  config,
  inputs,
  lib,
  ...
}: {
  # These are the services I use on this machine
  imports = [
    ./hardware-configuration.nix
    ./minecraft.nix
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  # Minecraft packages
  nixpkgs.overlays = [inputs.nix-minecraft.overlay];

  # Oracle provides DHCP
  networking = {
    useDHCP = false;
    interfaces.enp0s3.useDHCP = true;
    hostName = "oracle-dragon";
  };

  # Enable a few selected custom settings
  dr460nixed = {
    docker-compose-runner."oracle-dragon" = {
      source = ../../docker-compose/oracle-dragon;
    };
    oci.enable = true;
    servers = {
      enable = true;
      monitoring = true;
    };
    tailscale = {
      enable = true;
      extraUpArgs = [
        "--accept-dns"
        "--accept-risk=lose-ssh"
        "--accept-routes"
        "--advertise-exit-node"
        "--ssh"
      ];
    };
  };

  # Garuda Nix subsystem options
  garuda = {
    hardware.enable = false;
    performance-tweaks.enable = true;
  };

  # Currently plagued by https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  # Cloudflared tunnel configurations
  services.cloudflared = {
    enable = true;
    tunnels = {
      "ba8379f8-de1c-474f-89ab-8d63e6bd1969" = {
        credentialsFile = config.sops.secrets."cloudflared/oracle-dragon/cred".path;
        default = "http_status:404";
        ingress = {
          "map.dr460nf1r3.org" = {
            service = "http://localhost:8100";
          };
        };
      };
    };
  };
  sops.secrets."cloudflared/oracle-dragon/cred" = {
    mode = "0600";
    owner = config.users.users.cloudflared.name;
    path = "/run/secrets/cloudflared/oracle-dragon/cred";
  };

  # No per-default Tmux on this machine
  home-manager.users.nico.programs = {
    bash = {
      enable = true;
      initExtra = lib.mkForce "exec fish";
    };
  };

  # Required for using app connectors in Tailscale
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  system.stateVersion = "22.11";
}
