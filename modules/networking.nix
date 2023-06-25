{ config
, lib
, ...
}:
with lib;
let
  cfg = config.dr460nixed;
in
{
  # We want to use NetworkManager on desktops
  networking = {
    # Pointing to our Adguard instance via Tailscale
    nameservers = [ "1.1.1.1" "1.0.0.1" ];
    networkmanager = mkIf cfg.desktops.enable or cfg.rpi {
      dns = "none";
      enable = true;
    };
    # Enable nftables instead of iptables
    nftables.enable = true;
  };

  # Tailscale network to connect the devices
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  services.tailscale = {
    enable = true;
    permitCertUid = "root";
    useRoutingFeatures = lib.mkDefault "client";
  };
  
  # SSHD shall keep connections alive for longer
  services.openssh = {
    enable = true;
    extraConfig = ''
      ClientAliveCountMax 2
      ClientAliveInterval 600
      Protocol 2
      TCPKeepAlive yes
    '';
  };

  # Client side SSH configuration
  programs.ssh.extraConfig = ''
    TCPKeepAlive yes
    ServerAliveCountMax 2
    ServerAliveInterval 600
  '';

  # Enable Mosh, a replacement for OpenSSH
  programs.mosh.enable = true;

  # Lightweight bandwidth usage tracking
  services.vnstat.enable = true;
}

