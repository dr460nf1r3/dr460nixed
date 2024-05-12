{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.dr460nixed.servers;
in {
  options.dr460nixed.servers = {
    enable =
      mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Whether this device is a server.
        '';
      };
    monitoring =
      mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Whether to enable monitoring via Netdata.
        '';
      };
  };

  config = mkIf cfg.enable {
    # The common used config is not available
    programs.fish.shellInit = mkForce ''
      set fish_greeting
      fastfetch -l nixos
    '';

    # The excellent CachyOS kernel
    boot.kernelPackages = pkgs.linuxPackages_cachyos-server;

    # Automatic server upgrades
    dr460nixed.auto-upgrade = lib.mkDefault true;

    # No custom aliases
    dr460nixed.shells.enable = lib.mkDefault false;

    # These aren't needed on servers, but default on GNS
    garuda = {
      audio.pipewire.enable = false;
      hardware.enable = false;
      networking.enable = false;
    };
    boot.plymouth.enable = true;

    # Enable the Netdata daemon
    services.netdata.enable = mkIf cfg.monitoring true;
    services.netdata.config = {
      global = {
        "dbengine disk space" = "512";
        "memory mode" = "dbengine";
        "update every" = "2";
      };
      ml = {"enabled" = "yes";};
    };
    services.netdata.configDir = {
      "go.d.conf" = pkgs.writeText "go.d.conf" ''
        enabled: yes
        modules:
          nginx: yes
          web_log: yes
      '';
      "python.d.conf" = pkgs.writeText "python.d.conf" ''
        postgres: no
        web_log: no
      '';
      "go.d/nginx.conf" =
        mkIf config.services.nginx.enable
        (pkgs.writeText "nginx.conf" ''
          jobs:
            - name: local
              url: http://127.0.0.1/nginx_status
        '');
    };

    # Extra Python & system packages required for Netdata to function
    services.netdata.package = pkgs.netdata.override {withCloud = true;};
    services.netdata.python.extraPackages = ps: [ps.psycopg2];
    systemd.services.netdata = {path = with pkgs; [jq];};

    # Connect to Netdata Cloud easily
    services.netdata.claimTokenFile = config.sops.secrets."api_keys/netdata".path;
    sops.secrets."api_keys/netdata" = {
      mode = "0600";
      owner = "netdata";
      path = "/run/secrets/api_keys/netdata";
    };

    # The Nginx QUIC package with Brotli modules
    services.nginx.package = pkgs.nginxQuic.override {doCheck = false;};
    services.nginx.additionalModules = with pkgs; [nginxModules.brotli];

    # Recommended settings replacing custom configuration
    services.nginx = {
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedTlsSettings = true;
    };

    # Statuspage for Netdata to consume
    services.nginx.statusPage = true;

    # Upstream resolvers
    services.nginx.resolver = {
      addresses = ["100.100.100.100"];
      valid = "60s";
    };

    # Global Nginx configuration
    services.nginx.appendConfig = ''
      worker_processes auto;
    '';

    # Logformat to use for Netdata & extra config that doesn't exist as separate key in NixOS
    services.nginx.commonHttpConfig = ''
      # Custom log format for Netdata to analyze
      log_format              custom '"$http_referer" "$http_user_agent" '
                              '$remote_addr - $remote_user [$time_local] '
                              '"$request" $status $body_bytes_sent';

      # Brotli compression
      brotli                  on;
      brotli_comp_level       6;
      brotli_static           on;
      brotli_types            application/atom+xml application/javascript application/json application/rss+xml
                              application/vnd.ms-fontobject application/x-font-opentype application/x-font-truetype
                              application/x-font-ttf application/x-javascript application/xhtml+xml application/xml
                              font/eot font/opentype font/otf font/truetype image/svg+xml image/vnd.microsoft.icon
                              image/x-icon image/x-win-bitmap text/css text/javascript text/plain text/xml;
    '';

    # Diffie-Hellman parameter for DHE ciphersuites
    security.dhparams = mkIf config.services.nginx.enable {
      defaultBitSize = 3072;
      enable = true;
      params.nginx = {};
    };
    services.nginx.sslDhparam = config.security.dhparams.params.nginx.path;

    # Need to explicitly open our web server ports
    networking.firewall = mkIf config.services.nginx.enable {
      allowedTCPPorts = [80 443];
      allowedUDPPorts = [443];
    };

    # Make cloudflared happy (https://github.com/lucas-clemente/quic-go/wiki/UDP-Receive-Buffer-Size)
    boot.kernel.sysctl = lib.mkIf config.services.cloudflared.enable {
      "net.core.rmem_max" = 7500000;
      "net.core.wmem_max" = 7500000;
    };

    # Enable this so we don't get annoyed by the ACME TOS
    security.acme = {
      acceptTerms = true;
      defaults.email = "root@dr460nf1r3.org";
    };
  };
}
