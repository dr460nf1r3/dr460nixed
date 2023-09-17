{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.dr460nixed;
in {
  # We want to use NetworkManager on desktops
  networking = {
    # Pointing to our Adguard instance via Tailscale
    nameservers = ["1.1.1.1" "1.0.0.1"];
    networkmanager = mkIf cfg.desktops.enable or cfg.rpi {
      dns = "none";
      enable = true;
    };
    # Enable nftables instead of iptables
    nftables.enable = true;
  };

  # Enable SSHD & bandwidth usage tracking
  services = {
    openssh.enable = true;
    vnstat.enable = true;
  };

  # Enable Mosh, a replacement for OpenSSH
  programs.mosh.enable = true;
}
