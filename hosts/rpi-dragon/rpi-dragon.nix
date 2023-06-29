{ config
, pkgs
, lib
, ...
}: {
  # Individual settings
  imports = [
    ../../configurations/common.nix
    "${builtins.fetchGit {
      url = "https://github.com/NixOS/nixos-hardware.git";
      rev = "f38f9a4c9b2b6f89a5778465e0afd166a8300680";
    }}/raspberry-pi/4"
    ./hardware-configuration.nix
  ];

  # Our hostname
  networking.hostName = "rpi-dragon";

  # Kernel defaults
  boot = {
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
    # Fix https://github.com/NixOS/nixpkgs/pull/207969
    initrd.systemd.enable = lib.mkForce false;
    kernelPackages = pkgs.linuxPackages_rpi4;
    # ttyAMA0 is the serial console broken out to the GPIO
    kernelParams = [
      "8250.nr_uarts=1"
      "cma=128M"
      "console=tty1"
      "console=ttyAMA0,115200"
    ];
    tmp.useTmpfs = true;
  };

  # Enable hardware acceleration
  hardware.raspberry-pi."4".fkms-3d.enable = true;

  # This is needed as the packages are marked unsupported
  hardware.cpu = {
    amd.updateMicrocode = lib.mkForce false;
    intel.updateMicrocode = lib.mkForce false;
  };

  # Slows down write operations considerably
  nix.settings.auto-optimise-store = lib.mkForce false;

  # Custom garbage collection defaults
  nix = {
    # Free up to 1GiB whenever there is less than 100MiB left & allow remote-building
    extraOptions = lib.mkForce ''
      builders-use-substitutes = true
      max-free = ${toString (1024 * 1024 * 1024)}
      min-free = ${toString (100 * 1024 * 1024)}
    '';
  };

  # Cloudflared tunnel configurations
  services.cloudflared = {
    enable = true;
    tunnels = {
      "a2da25c2-eaec-43a4-8a7e-d5c49f9ac6ae" = {
        credentialsFile = config.sops.secrets."cloudflared/rpi/cred".path;
        default = "http_status:404";
      };
    };
  };
  sops.secrets."cloudflared/rpi/cred" = {
    mode = "0600";
    owner = config.users.users.cloudflared.name;
    path = "/run/secrets/cloudflared/rpi/cred";
  };

  # Make the SSL secret key & cert available (aquired via Tailscale)
  sops.secrets."ssl/rpi-dragon-key" = {
    mode = "0600";
    owner = "nginx";
    path = "/run/secrets/ssl/rpi-dragon-key";
  };
  sops.secrets."ssl/rpi-dragon-cert" = {
    mode = "0600";
    owner = "nginx";
    path = "/run/secrets/ssl/rpi-dragon-cert";
  };

  # Provide a reverse proxy for our services
  services.nginx = {
    enable = true;
    virtualHosts."rpi-dragon.emperor-mercat.ts.net" = {
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
      sslCertificate = config.sops.secrets."ssl/rpi-dragon-cert".path;
      sslCertificateKey = config.sops.secrets."ssl/rpi-dragon-key".path;
    };
  };

  # Enable a few selected custom settings
  dr460nixed = {
    rpi = true;
    servers.enable = true;
    servers.monitoring = true;
  };

  # Garuda Nix subsystem option
  garuda = {
    hardware.enable = false;
    performance-tweaks.enable = true;
  };

  # Add remote build machine
  nix.buildMachines = [
    {
      hostName = "oracle-dragon";
      mandatoryFeatures = [ ];
      maxJobs = 4;
      speedFactor = 2;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      system = "aarch64-linux";
    }
  ];
  nix.distributedBuilds = true;

  # Supply needed SSH key for accessing oracle-dragon
  sops.secrets."ssh_keys/deploy_ed25519" = {
    mode = "0600";
    owner = config.users.users.root.name;
    path = "/root/.ssh/id_ed25519";
  };

  # NixOS stuff
  system.stateVersion = "22.11";
}
