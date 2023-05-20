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
    virtualHosts."oracle-dragon.emperor-mercat.ts.net" = {
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
