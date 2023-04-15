{ config
, lib
, pkgs
, ...
}:
{
  # We want to use NetworkManager on desktops
  networking = {
    # Pointing to our Adguard instance via Tailscale
    nameservers = [ "1.1.1.1" ];
    networkmanager = lib.mkIf cfg.desktops.enable or cfg.rpi {
      dns = "none";
      enable = true;
      unmanaged = [ "lo" ];
      wifi.backend = "iwd";
    };
    # Disable non-NetworkManager
    useDHCP = lib.mkDefault false;
  };

  ## Enable BBR & cake
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
};

