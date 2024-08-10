{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dr460nixed;
in {
  # We want to use NetworkManager on desktops
  networking = {
    # Pointing to NextDNS via Tailscale
    # if not, Cloudflare would still be my choice
    nameservers = [
      "1.1.1.1"
      "2606:4700:4700::1111"
      "1.0.0.1"
      "2606:4700:4700::1001"
    ];
    networkmanager = lib.mkIf cfg.desktops.enable {
      # This is required to workaround Tailscale not recovering from net change
      # https://github.com/tailscale/tailscale/issues/8223
      dispatcherScripts = [
        {
          source = pkgs.writeScript "restartTailscaled" ''
            #!/usr/bin/env ${pkgs.bash}/bin/bash
            if [[ "$1" != "wlan0" ]]; then
              exit 0
            fi
            if [[ "$2" == "up" ]]; then
              if [[ $(${pkgs.iputils}/bin/ping -W 1 -c 1 garudalinux.org) != 0 ]]; then
                logger "Wlan0 up, restarting tailscaled"
                ${pkgs.systemd}/bin/systemctl restart tailscaled
              fi
            fi
          '';
          type = "basic";
        }
      ];
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
