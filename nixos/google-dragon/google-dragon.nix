{
  config,
  inputs,
  lib,
  ...
}: {
  imports = ["${toString inputs.nixpkgs}/nixos/modules/virtualisation/google-compute-image.nix"];

  dr460nixed = {
    auto-upgrade = false;
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

  # Swap and lower priority to not die on simple Nix expressions
  swapDevices = [{device = "/swapfile";}];
  nix = {
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
    daemonIOSchedPriority = 7;
  };

  # Since this machine is super slow, its only going to be
  # an uptime monitor
  services.uptime-kuma = {
    appriseSupport = true;
    enable = true;
    settings = {
      UPTIME_KUMA_HOST = "0.0.0.0";
    };
  };

  # Lets try to workaround failing DNS lookups in Uptime Kuma
  # by caching DNS requests locally
  # https://github.com/louislam/uptime-kuma/issues/4731#issuecomment-2089461474
  services.resolved = {
    enable = true;
    extraConfig = ''
      [Resolve]
      DNS=100.100.100.100 1.1.1.1
      Domains=~.
    '';
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
            service = "http://localhost:3001";
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
