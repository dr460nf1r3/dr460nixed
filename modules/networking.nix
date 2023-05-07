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
      unmanaged = [ "lo" "docker0" ];
    };
    # Enable nftables instead of iptables
    nftables.enable = true;
    # Disable non-NetworkManager
    useDHCP = mkDefault false;
  };

  # Enable wireless database
  hardware.wirelessRegulatoryDatabase = true;

  # Enable BBR & cake
  boot.kernelModules = [ "tcp_bbr" ];
  boot.kernel.sysctl = {
    "net.core.default_qdisc" = "cake";
    "net.ipv4.tcp_congestion_control" = "bbr";
    "net.ipv4.tcp_fin_timeout" = 5;
  };

  # Tailscale network to connect the devices
  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  services.tailscale = {
    enable = true;
    permitCertUid = "root";
  };

  # OpenSSH for remote accessing, hardened via ssh-audit suggestions
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
  };

  # Allow passwordless sudo for authenticated SSH users (like me)
  security.pam.enableSSHAgentAuth = true;

  # Use the performant openssh (currently marked insecure)
  # programs.ssh.package = pkgs.openssh_hpn;

  # Lightweight bandwidth usage tracking
  services.vnstat.enable = true;
}

