{ config
, lib
, ...
}: {
  # These are the services I use on this machine
  imports = [
    ../../configurations/common.nix
    ../../configurations/servers.nix
    ../../configurations/servers/adguard.nix
    ../../configurations/servers/code-server.nix
    ../../configurations/servers/github-runner.nix
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
    virtualHosts."code.dragons.lair" = {
      forceSSL = true;
      http3 = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:4444";
        proxyWebsockets = true;
      };
      sslCertificate = config.sops.secrets."ssl/home-dragon-cert".path;
      sslCertificateKey = config.sops.secrets."ssl/home-dragon-key".path;
    };
    virtualHosts."dns.dragons.lair" = {
      forceSSL = true;
      http3 = true;
      locations."/".proxyPass = "http://127.0.0.1:3000";
      sslCertificate = config.sops.secrets."ssl/home-dragon-cert".path;
      sslCertificateKey = config.sops.secrets."ssl/home-dragon-key".path;
    };
    virtualHosts."netdata.dragons.lair" = {
      forceSSL = true;
      http3 = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:19999";
        proxyWebsockets = true;
      };
      sslCertificate = config.sops.secrets."ssl/home-dragon-cert".path;
      sslCertificateKey = config.sops.secrets."ssl/home-dragon-key".path;
    };
  };

  # Make the SSL secret key & cert available, CA already globally trusted
  sops.secrets."ssl/home-dragon-key" = {
    mode = "0600";
    owner = "nginx";
    path = "/run/secrets/ssl/home-dragon-key";
  };
  sops.secrets."ssl/home-dragon-cert" = {
    mode = "0600";
    owner = "nginx";
    path = "/run/secrets/ssl/home-dragon-cert";
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

  # In case I need containers
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
    };
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
        };
      };
    };
  };
  sops.secrets."cloudflared/oracle-dragon/cred" = {
    mode = "0600";
    owner = config.users.users.cloudflared.name;
    path = "/run/secrets/cloudflared/oracle-dragon/cred";
  };
}
