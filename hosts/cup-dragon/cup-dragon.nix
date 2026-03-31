{
  config,
  dragonLib,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./forgejo.nix
    ./hardware-configuration.nix
    ./matrix.nix
    ./redlib.nix
    ./wakapi.nix
    ../../users/nico/nixos.nix
  ];

  boot = {
    kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    };
    loader = {
      grub = {
        device = "nodev";
        efiInstallAsRemovable = true;
        efiSupport = true;
        enable = lib.mkForce true;
      };
      efi.efiSysMountPoint = "/boot";
    };
  };

  services = {
    nginx.enable = true;
    openssh.ports = [ 666 ];
    qemuGuest.enable = true;
  };

  networking = {
    defaultGateway6 = {
      address = "fe80::1";
      interface = "ens3";
    };
    hostName = "cup-dragon";
    interfaces.ens3.ipv6.addresses = [
      {
        address = "2a03:4000:42:4c::";
        prefixLength = 64;
      }
    ];
  };

  nix.settings.system-features = [
    "big-parallel"
    "kvm"
  ];

  dr460nixed = {
    compose-runner = {
      "cup-dragon" = {
        source = ../../compose/cup-dragon;
      };
    };
    servers = {
      enable = true;
      monitoring = true;
      claimTokenSecret = "api_keys/netdata";
    };
    smtp = {
      enable = true;
      from = "nico@dr460nf1r3.org";
      passwordeval = "cat /run/secrets/passwords/nico@dr460nf1r3.org";
      user = "nico@dr460nf1r3.org";
    };
    tailscale.enable = true;
    tailscale-tls = {
      enable = true;
      domain-override = "cup-dragon.emperor-mercat.ts.net";
    };
  };

  security.acme.certs = {
    "dr460nf1r3.org" = {
      extraDomainNames = [ "*.dr460nf1r3.org" ];
      dnsProvider = "cloudflare";
      dnsPropagationCheck = true;
      credentialsFile = config.sops.secrets."api_keys/cloudflare".path;
    };
    "garudalinux.org" = {
      extraDomainNames = [ "*.garudalinux.org" ];
      dnsProvider = "cloudflare";
      dnsPropagationCheck = true;
      credentialsFile = config.sops.secrets."api_keys/cloudflare".path;
    };
    "chaotic.cx" = {
      extraDomainNames = [ "*.chaotic.cx" ];
      dnsProvider = "cloudflare";
      dnsPropagationCheck = true;
      credentialsFile = config.sops.secrets."api_keys/cloudflare".path;
    };
  };

  services.syncthing = {
    enable = true;
    cert = config.sops.secrets."syncthing/cup-dragon/cert".path;
    key = config.sops.secrets."syncthing/cup-dragon/key".path;
    package = inputs.syncthing-nixpkgs.legacyPackages.${pkgs.system}.syncthing;
    guiAddress = "127.0.0.1:8384";
    openDefaultPorts = true;
    overrideDevices = false;
    overrideFolders = false;
    settings = {
      options.urAccepted = -1;
      devices = dragonLib.syncthing.getDevicesFor config.networking.hostName;
      folders = {
        "chaotic-aur" = {
          id = "jhcrt-m2dra";
          path = "/srv/http/chaotic-aur";
          type = "receiveonly";
          order = "oldestFirst";
        };
        "Music" = {
          id = "ybqqh-as53c";
          path = "~/Music";
          devices = lib.attrNames (dragonLib.syncthing.getDevicesFor config.networking.hostName);
        };
        "Pictures" = {
          id = "9ymwn-cz5ze";
          path = "~/Pictures";
          devices = lib.attrNames (dragonLib.syncthing.getDevicesFor config.networking.hostName);
        };
        "Sync" = {
          id = "u62ge-wzsau";
          path = "~/Sync";
          devices = lib.attrNames (dragonLib.syncthing.getDevicesFor config.networking.hostName);
        };
        "Videos" = {
          id = "nxhpo-c2j5b";
          path = "~/Videos";
          devices = lib.attrNames (dragonLib.syncthing.getDevicesFor config.networking.hostName);
        };
      };
    };
  };

  # Cloudflared tunnel configurations
  services.cloudflared = {
    enable = true;
    tunnels = {
      "76dc88f1-c290-4405-a1be-9d0249e376d3" = {
        credentialsFile = config.sops.secrets."cloudflared/cup-dragon/cred".path;
        default = "http_status:404";
        ingress = {
          "ci.dr460nf1r3.org" = "http://127.0.0.1:3007";
          "dev.dr460nf1r3.org" = "http://127.0.0.1:3010";
          "searx.dr460nf1r3.org" = "http://127.0.0.1:8080";
        };
      };
    };
  };

  sops.secrets."syncthing/cup-dragon/cert" = {
    mode = "0644";
    owner = config.services.syncthing.user;
  };
  sops.secrets."syncthing/cup-dragon/key" = {
    mode = "0600";
    owner = config.services.syncthing.user;
  };
  sops.secrets."api_keys/netdata" = {
    mode = "0600";
    owner = "netdata";
    path = "/run/secrets/api_keys/netdata";
  };
  sops.secrets."api_keys/cloudflare" = {
    mode = "0400";
    owner = "acme";
    path = "/run/secrets/api_keys/cloudflare";
  };
  sops.secrets."cloudflared/cup-dragon/cred" = {
    mode = "0660";
    path = "/var/lib/cloudflared/cred";
  };

  virtualisation = {
    containers.enable = true;
    docker.enable = true;
  };

  services.nginx.virtualHosts = {
    "uptime.dr460nf1r3.org" = {
      forceSSL = true;
      http3 = true;
      http3_hq = true;
      kTLS = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3001";
      };
      quic = true;
      useACMEHost = "dr460nf1r3.org";
    };
    "status.garudalinux.org" = {
      forceSSL = true;
      http3 = true;
      http3_hq = true;
      kTLS = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3001";
      };
      quic = true;
      useACMEHost = "garudalinux.org";
    };
    "uptimes.chaotic.cx" = {
      forceSSL = true;
      http3 = true;
      http3_hq = true;
      kTLS = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3001";
      };
      quic = true;
      useACMEHost = "chaotic.cx";
    };
    "chaotic.dr460nf1r3.org" = {
      forceSSL = true;
      http3 = true;
      http3_hq = true;
      kTLS = true;
      locations = {
        "~* ^/chaotic-aur/([^/]+)/x86_64/(?!1.(db|files))[^/]+$" = {
          extraConfig = ''
            add_header Cache-Control "max-age=150, stale-while-revalidate=150, stale-if-error=86400";
          '';
        };
        "/" = {
          extraConfig = ''
            autoindex on;
            autoindex_exact_size off;
            autoindex_localtime on;
            add_header Cache-Control 'no-cache';
          '';
        };
      };
      quic = true;
      root = "/srv/http";
      useACMEHost = "dr460nf1r3.org";
    };
  };

  home-manager.users.nico.home.stateVersion = lib.mkForce "24.05";
  system.stateVersion = "24.05";
}
