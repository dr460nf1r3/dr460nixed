{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.services.nginx.enable {
    # The Nginx QUIC package with Brotli modules
    services.nginx.additionalModules = with pkgs; [ nginxModules.brotli ];

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
      addresses = [ "100.100.100.100" ];
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

      # Misc
      aio threads;
    '';

    # Diffie-Hellman parameter for DHE ciphersuites
    security.dhparams = {
      defaultBitSize = 3072;
      enable = true;
      params.nginx = { };
    };
    services.nginx.sslDhparam = config.security.dhparams.params.nginx.path;

    # Default catch-all for unknown domains
    services.nginx.virtualHosts."_" = {
      addSSL = true;
      extraConfig = ''
        log_not_found off;
        return 404;
      '';
      http3 = true;
      quic = true;
      useACMEHost = "dr460nf1r3.org";
    };

    # Need to explicitly open our web server ports
    networking.firewall = {
      allowedTCPPorts = [
        80
        443
      ];
      allowedUDPPorts = [ 443 ];
    };
  };
}
