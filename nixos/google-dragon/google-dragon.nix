{
  config,
  inputs,
  lib,
  ...
}: {
  imports = ["${toString inputs.nixpkgs}/nixos/modules/virtualisation/google-compute-image.nix"];

  dr460nixed = {
    grub = {
      device = "/dev/sda";
      enable = true;
    };
    servers = {
      enable = true;
      monitoring = true;
    };
    smtp.enable = true;
    tailscale.enable = true;
    tailscale-tls.enable = true;
  };

  # Hostname of this machine
  networking.hostName = "google-dragon";

  # Clashing gcp.nix / GNS
  boot.loader.timeout = lib.mkForce 0;

  # Swap to not die on simple Nix expressions
  swapDevices = [{device = "/swapfile";}];

  # Since this machine is super slow, its only going to be
  # an uptime monitor
  services.uptime-kuma = {
    appriseSupport = true;
    enable = true;
    settings = {
      UPTIME_KUMA_HOST = "0.0.0.0";
    };
  };

  # Cloudflared tunnel configurations
  services.cloudflared = {
    enable = true;
    tunnels = {
      "e2b1b2eb-aeb5-4886-b031-7b21213ca8b2" = {
        credentialsFile = config.sops.secrets."cloudflared/google-dragon/cred".path;
        default = "http_status:404";
        ingress = {
          "uptime.dr460nf1r3.org" = {
            service = "http://127.0.0.1:3001";
          };
        };
      };
    };
  };
  sops.secrets."cloudflared/google-dragon/cred" = {
    mode = "0600";
    owner = config.users.users.cloudflared.name;
    path = "/run/secrets/cloudflared/google-dragon/cred";
  };

  # NixOS stuff
  system.stateVersion = "23.11";
}
