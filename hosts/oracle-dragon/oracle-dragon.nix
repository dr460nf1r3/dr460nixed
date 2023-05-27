{ config
, lib
, ...
}: {
  # These are the services I use on this machine
  imports = [
    ../../configurations/common.nix
    ../../configurations/services/adguard.nix
    # ../../configurations/services/code-server.nix - nodejs marked insecure
    # ../../configurations/services/github-runner.nix - nodejs marked insecure
    ../../configurations/services/searxng.nix
    ./hardware-configuration.nix
  ];

  # Oracle provides DHCP
  networking.useDHCP = false;
  networking.interfaces.enp0s3.useDHCP = true;
  networking.hostName = "oracle-dragon";

  system.stateVersion = "22.11";

  # Provide a reverse proxy for our services
  services.nginx = {
    enable = true;
    proxyCachePath."mattermost" = {
      enable = true;
      maxSize = "3g";
      inactive = "120m";
      keysZoneName = "mattermost_cache";
    };
    virtualHosts = {
      "mm.dr460nf1r3.org" = {
        enableACME = true;
        extraConfig = ''
          http2_push_preload on; # Enable HTTP/2 Server Push
          ssl_session_timeout 1d;

          location ~ /api/v[0-9]+/(users/)?websocket$ {
              proxy_set_header Upgrade $http_upgrade;
              proxy_set_header Connection "upgrade";
              client_max_body_size 50M;
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Frame-Options SAMEORIGIN;
              proxy_buffers 256 16k;
              proxy_buffer_size 16k;
              client_body_timeout 60;
              send_timeout 300;
              lingering_timeout 5;
              proxy_connect_timeout 90;
              proxy_send_timeout 300;
              proxy_read_timeout 90s;
              proxy_http_version 1.1;
              proxy_pass http://mm_backend;
          }
          location / {
              client_max_body_size 50M;
              proxy_set_header Connection "";
              proxy_set_header Host $host;
              proxy_set_header X-Real-IP $remote_addr;
              proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
              proxy_set_header X-Forwarded-Proto $scheme;
              proxy_set_header X-Frame-Options SAMEORIGIN;
              proxy_buffers 256 16k;
              proxy_buffer_size 16k;
              proxy_read_timeout 600s;
              proxy_cache mattermost_cache;
              proxy_cache_revalidate on;
              proxy_cache_min_uses 2;
              proxy_cache_use_stale timeout;
              proxy_cache_lock on;
              proxy_http_version 1.1;
              proxy_pass http://mm_backend;
          }
        '';
        forceSSL = true;
        http3 = true;
      };
      "oracle-dragon.emperor-mercat.ts.net" = {
        extraConfig = ''
          location = /netdata {
                return 301 /netdata/;
          }
          location ~ /netdata/(?<ndpath>.*) {
            proxy_redirect off;
            proxy_set_header Host $host;
            proxy_set_header X-Forwarded-Host $host;
            proxy_set_header X-Forwarded-Server $host;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_http_version 1.1;
            proxy_pass_request_headers on;
            proxy_set_header Connection "keep-alive";
            proxy_store off;
            proxy_pass http://127.0.0.1:19999/$ndpath$is_args$args;

            gzip on;
            gzip_proxied any;
            gzip_types *;
          }
        '';
        forceSSL = true;
        http3 = true;
        locations."/" = {
          proxyPass = "http://127.0.0.1:3000";
          proxyWebsockets = true;
        };
        sslCertificate = config.sops.secrets."ssl/oracle-dragon-cert".path;
        sslCertificateKey = config.sops.secrets."ssl/oracle-dragon-key".path;
      };
    };
    # The upstream as requested by Mattermost reverse proxy config
    upstreams = {
      mm_backend = {
        extraConfig = ''
          keepalive 32;
        '';
        servers = {
          "localhost:8065" = {
            weight = 5;
          };
        };
      };
    };
  };

  # Enable a few selected custom settings
  dr460nixed = {
    common.enable = true;
    docker-compose-runner."oracle-dragon" = {
      source = ../../configurations/docker-compose/oracle-dragon;
    };
    performance-tweaks.enable = true;
    servers.enable = true;
    servers.monitoring = true;
    shells.enable = true;
  };

  # Mattermost instance
  services.mattermost = {
    enable = true;
    mutableConfig = true;
    siteUrl = "https://mm.dr460nf1r3.org";
    environmentFile = config.sops.secrets."mattermost/environment".path;
  };
  # Mattermost configuration
  sops.secrets."mattermost/environment" = {
    mode = "0600";
    owner = "mattermost";
    path = "/run/secrets/mattermost/environment";
  };

  # ClamAV daemon for Mattermost ClamAV plugin
  services.clamav = {
    daemon = {
      enable = true;
      settings = {
        "MaxFileSize" = "50M";
        "TCPAddr" = "127.0.0.1";
        "TCPSocket" = 3310;
      };
    };
    updater.enable = true;
  };
  # Prerequisites for Tailscale exit node
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # Make the SSL secret key & cert available (aquired via Tailscale)
  sops.secrets."ssl/oracle-dragon-key" = {
    mode = "0600";
    owner = "nginx";
    path = "/run/secrets/ssl/oracle-dragon-key";
  };
  sops.secrets."ssl/oracle-dragon-cert" = {
    mode = "0600";
    owner = "nginx";
    path = "/run/secrets/ssl/oracle-dragon-cert";
  };

  # This is my remote development machine
  # Import secrets needed for development
  sops.secrets."api_keys/sops" = {
    mode = "0600";
    owner = config.users.users.nico.name;
    path = "/home/nico/.config/sops/age/keys.txt";
  };
  sops.secrets."api_keys/heroku" = {
    mode = "0600";
    owner = config.users.users.nico.name;
    path = "/home/nico/.netrc";
  };
  sops.secrets."api_keys/cloudflared" = {
    mode = "0600";
    owner = config.users.users.nico.name;
    path = "/home/nico/.cloudflared/cert.pem";
  };

  # For pushing to GitHub etc.
  sops.secrets."ssh_keys/id_rsa" = {
    mode = "0600";
    owner = config.users.users.nico.name;
    path = "/home/nico/.ssh/id_rsa";
  };

  # Needed for KASM workspaces
  virtualisation = {
    docker = {
      autoPrune = {
        dates = "2d";
        enable = true;
      };
      enable = true;
    };
    oci-containers.backend = "docker";
  };

  # Slows down write operations considerably
  nix.settings.auto-optimise-store = lib.mkForce false;

  # Cloudflared tunnel configurations
  services.cloudflared = {
    enable = true;
    tunnels = {
      "4683a63c-967a-4704-b48a-13b240b72d79" = {
        credentialsFile = config.sops.secrets."cloudflared/oracle-dragon/cred".path;
        default = "http_status:404";
        ingress = {
          "code.dr460nf1r3.org" = {
            service = "http://localhost:4444";
          };
          "kasm.dr460nf1r3.org" = {
            service = "https://localhost:8443";
          };
        };
      };
    };
  };
  sops.secrets."cloudflared/oracle-dragon/cred" = {
    mode = "0600";
    owner = config.users.users.cloudflared.name;
    path = "/run/secrets/cloudflared/oracle-dragon/cred";
  };

  # This is needed as the packages are marked unsupported
  hardware.cpu = {
    amd.updateMicrocode = lib.mkForce false;
    intel.updateMicrocode = lib.mkForce false;
  };
}
