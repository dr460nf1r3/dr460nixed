{
  config,
  lib,
  pkgs,
  ...
}:
# Adapted from:
# https://gitlab.com/famedly/conduit/-/blob/3bfdae795d4d9ec9aeaac7465e7535ac88e47756/nix/README.md
let
  server_name = "dr460nf1r3.org";
  matrix_hostname = "matrix.${server_name}";
in {
  services.matrix-conduit = {
    enable = true;
    package = pkgs.matrix-continuwuity;
    settings.global = {
      allow_registration = false;
      database_backend = "rocksdb";
      inherit server_name;
      new_user_displayname_suffix = "";
    };
  };

  # Fix for new binary name in 0.5.0
  systemd.services.conduit.serviceConfig.ExecStart = lib.mkForce "${pkgs.matrix-continuwuity}/bin/conduwuit";

  services.nginx = {
    virtualHosts = {
      "${matrix_hostname}" = {
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
        quic = true;
        useACMEHost = "dr460nf1r3.org";
      };
    };

    upstreams = {
      "backend_conduit" = {
        servers = {
          "[::1]:${toString config.services.matrix-conduit.settings.global.port}" = {};
        };
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [80 443 8448];
    allowedUDPPorts = [80 443 8448];
  };
}
