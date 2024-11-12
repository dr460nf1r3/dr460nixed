{
  config,
  pkgs,
  ...
}:
# Adapted from:
# https://gitlab.com/famedly/conduit/-/blob/3bfdae795d4d9ec9aeaac7465e7535ac88e47756/nix/README.md
let
  server_name = "dr460nf1r3.org";
  matrix_hostname = "matrix.${server_name}";

  well_known_server = pkgs.writeText "well-known-matrix-server" ''
    {
      "m.server": "${matrix_hostname}"
    }
  '';

  well_known_client = pkgs.writeText "well-known-matrix-client" ''
    {
      "m.homeserver": {
        "base_url": "https://${matrix_hostname}"
      }
    }
  '';
in {
  services.matrix-conduit = {
    enable = true;
    package = pkgs.conduwuit_git;
    settings.global = {
      server_name = matrix_hostname;
      allow_registration = false;
      database_backend = "rocksdb";
    };
  };
  services.nginx = {
    virtualHosts."${matrix_hostname}" = {
      extraConfig = ''
        merge_slashes off;
      '';
      forceSSL = true;
      http3 = true;
      http3_hq = true;
      kTLS = true;
      listen = [
        {
          addr = "0.0.0.0";
          port = 443;
          ssl = true;
        }
        {
          addr = "[::]";
          port = 443;
          ssl = true;
        }
        {
          addr = "0.0.0.0";
          port = 8448;
          ssl = true;
        }
        {
          addr = "[::]";
          port = 8448;
          ssl = true;
        }
      ];
      locations."/_matrix/" = {
        proxyPass = "http://backend_conduit$request_uri";
        proxyWebsockets = true;
        extraConfig = ''
          proxy_set_header Host $host;
          proxy_buffering off;
        '';
      };
      locations."=/.well-known/matrix/server" = {
        alias = "${well_known_server}";

        extraConfig = ''
          default_type application/json;
        '';
      };
      locations."=/.well-known/matrix/client" = {
        alias = "${well_known_client}";

        extraConfig = ''
          default_type application/json;
          add_header Access-Control-Allow-Origin "*";
        '';
      };
      quic = true;
      useACMEHost = "dr460nf1r3.org";
    };

    upstreams = {
      "backend_conduit" = {
        servers = {
          "[::1]:${toString config.services.matrix-conduit.settings.global.port}" = {};
        };
      };
    };
  };

  networking.firewall.allowedTCPPorts = [80 443 8448];
  networking.firewall.allowedUDPPorts = [80 443 8448];

  # ACME data must be readable by the NGINX user
}
