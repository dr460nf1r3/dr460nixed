{
  config,
  pkgs,
  ...
}:
# Adapted from:
# https://gitlab.com/famedly/conduit/-/blo  b/3bfdae795d4d9ec9aeaac7465e7535ac88e47756/nix/README.md
let
  server_name = "dr460nf1r3.org";
  matrix_hostname = "matrix.${server_name}";
in {
  services.matrix-conduit = {
    enable = true;
    package = pkgs.conduwuit_git;
    settings.global = {
      allow_registration = false;
      database_backend = "rocksdb";
      inherit server_name;
      new_user_displayname_suffix = "";
    };
  };
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

  environment.systemPackages = with pkgs; [signal-cli];

  networking.firewall = {
    allowedTCPPorts = [80 443 8448];
    allowedUDPPorts = [80 443 8448];
  };

  # Keep Signal login up-to-date
  home-manager.users."nico".systemd.user = {
    services.sync-signal = {
      Unit = {
        Description = "Signal ensure-synced";
      };
      Service = {
        ExecStart = ''
          ${pkgs.bash}/bin/bash ${config.sops.secrets."matrix/signal_sync".path}
        '';
        Environment = "EXECUTABLE=${pkgs.signal-cli}/bin/signal-cli";
      };
    };
    timers.sync-signal = {
      Unit = {
        Description = "Signal ensure-synced";
      };
      Timer = {
        OnBootSec = "1min";
        OnUnitActiveSec = "1h";
        Unit = "sync-signal.service";
      };
    };
  };
  sops.secrets."matrix/signal_sync" = {
    mode = "0600";
    owner = config.users.users.nico.name;
    path = "/home/nico/.signal_sync";
  };

  # services.mautrix-signal = {
  #   enable = true;
  #   environmentFile = sops.secrets."matrix/signal".path;
  #   settings = {
  #     appservice = {
  #       as_token = "";
  #       bot = {
  #         displayname = "Signal Bridge Bot";
  #         username = "signalbot";
  #       };
  #       hostname = "[::]";
  #       hs_token = "";
  #       id = "signal";
  #       port = 29328;
  #       username_template = "signal_{{.}}";
  #     };
  #     bridge = {
  #       command_prefix = "!signal";
  #       permissions = {
  #         "${matrix_hostname}" = "full";
  #         "@admin:${matrix_hostname}" = "admin";
  #       };
  #       relay = {
  #         enabled = true;
  #       };
  #     };
  #     database = {
  #       type = "sqlite3";
  #       uri = "file:/var/lib/mautrix-signal/mautrix-signal.db?_txlock=immediate";
  #     };
  #     homeserver = {
  #       address = "http://localhost:8448";
  #     };
  #   };
  # };
  # sops.secrets."matrix/signal" = {
  #   mode = "0600";
  #   owner = config.users.users.mautrix-signal.name;
  #   path = "/var/lib/mautrix-signal/.secret";
  # };
}
