{ config
, lib
, ...
}: {
  # These are the services I use on this machine
  imports = [
    ../../configurations/common.nix
    ../../configurations/services/adguard.nix
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
    virtualHosts = {
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
        sslCertificate = "/var/lib/tailscale-tls/cert.crt";
        sslCertificateKey = "/var/lib/tailscale-tls/key.key";
      };
    };
  };

  # Enable a few selected custom settings
  dr460nixed = {
    docker-compose-runner."oracle-dragon" = {
      source = ../../configurations/docker-compose/oracle-dragon;
    };
    grafanaStack = {
      address = "100.86.102.115";
      enable = true;
    };
    oci.enable = true;
    prometheus = {
      nginxExporter = true;
    };
    servers = {
      enable = true;
      monitoring = true;
    };
    tailscale = {
      enable = true;
      extraUpArgs = [
        "--accept-dns"
        "--accept-routes"
        "--advertise-exit-node"
        "--ssh"
      ];
    };
    tailscale-tls.enable = true;
  };

  # Secrets for the docker-compose runner & adguardExporter
  sops.secrets."api_keys/oracle-dragon" = {
    mode = "0600";
    owner = config.users.users.nico.name;
    path = "/var/docker-compose-runner/oracle-dragon/.env";
  };
  sops.secrets."api_keys/adguard" = {
    mode = "0600";
    owner = config.users.users.adguard.name;
    path = "/run/secrets/api_keys/adguard";
  };

  # Garuda Nix subsystem options
  garuda = {
    hardware.enable = false;
    performance-tweaks.enable = true;
  };

  # Currently plagued by https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = lib.mkForce false;

  # Prerequisites for Tailscale exit node
  boot.kernel.sysctl = {
    "net.ipv4.ip_forward" = 1;
    "net.ipv6.conf.all.forwarding" = 1;
  };

  # Cloudflared tunnel configurations
  # services.cloudflared = {
  #   enable = true;
  #   tunnels = {
  #     "4683a63c-967a-4704-b48a-13b240b72d79" = {
  #       credentialsFile = config.sops.secrets."cloudflared/oracle-dragon/cred".path;
  #       default = "http_status:404";
  #       ingress = {
  #         "code.dr460nf1r3.org" = {
  #           service = "http://localhost:4444";
  #         };
  #         "kasm.dr460nf1r3.org" = {
  #           service = "https://localhost:8443";
  #         };
  #       };
  #     };
  #   };
  # };
  # sops.secrets."cloudflared/oracle-dragon/cred" = {
  #   mode = "0600";
  #   owner = config.users.users.cloudflared.name;
  #   path = "/run/secrets/cloudflared/oracle-dragon/cred";
  # };
}
