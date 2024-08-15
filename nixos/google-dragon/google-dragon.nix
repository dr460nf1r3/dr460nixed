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

  # Cloudflared tunnel configurations
  services.cloudflared = {
    enable = true;
    tunnels = {
      "12879bb4-1707-445d-a8e4-cb38c222d43d" = {
        credentialsFile = config.sops.secrets."cloudflared/google-dragon/cred".path;
        default = "http_status:404";
      };
    };
  };
  sops.secrets."cloudflared/google-dragon/cred" = {
    mode = "0600";
    owner = config.users.users.cloudflared.name;
    path = "/var/lib/cloudflared/cred";
  };

  # NixOS stuff
  system.stateVersion = "23.11";
}
