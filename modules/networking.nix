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
      wifi = {
        backend = "iwd";
        macAddress = "random";
        powersave = true;
      };

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

  # OpenSSH for remote accessing via Tailscale
  services.openssh = {
    enable = true;
    startWhenNeeded = true;
  };

  # Use the performant openssh (currently marked insecure)
  # programs.ssh.package = pkgs.openssh_hpn;

  # Better for mobile device SSH
  programs.mosh.enable = true;
  environment.variables = { MOSH_SERVER_NETWORK_TMOUT = "604800"; };

  # Lightweight bandwidth usage tracking
  services.vnstat.enable = true;

}

