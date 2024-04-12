{
  pkgs,
  config,
  ...
}: {
  # Individual settings
  imports = [./hardware-configuration.nix];

  # Bootloader
  boot = {
    extraModulePackages = with config.boot.kernelPackages; [acpi_call];
    initrd.availableKernelModules = ["xhci_pci" "nvme" "usb_storage" "usbhid" "sd_mod"];
    # Without this, bluetooth does not work
    kernelModules = ["btintel"];
    loader = {
      efi = {
        canTouchEfiVariables = true;
        efiSysMountPoint = "/boot/efi";
      };
    };
  };

  # Hostname
  networking.hostName = "tv-nixos";

  # SSD
  services.fstrim.enable = true;

  # Enable a few selected custom settings
  dr460nixed = {
    auto-upgrade = true;
    chromium = true;
    desktops.enable = true;
    docker-compose-runner."tv-nixos" = {
      source = ../../docker-compose/tv-nixos;
    };
    performance = true;
    servers = {
      enable = true;
      monitoring = true;
    };
    tailscale = {
      enable = true;
      extraUpArgs = [
        "--accept-dns"
        "--accept-risk=lose-ssh"
        "--accept-routes"
        "--advertise-exit-node"
        "--ssh"
      ];
    };
    tailscale-tls.enable = true;
    systemd-boot.enable = true;
  };

  # Workaround build error for now
  nixpkgs.config.permittedInsecurePackages = ["electron-24.8.6"];

  # Yes, autologin on this one
  services.displayManager.sddm.settings.Autologin = {
    User = "nico";
    Session = "plasma";
  };

  # Provide a reverse proxy for our services
  services.nginx = {
    enable = true;
    virtualHosts."tv-nixos.emperor-mercat.ts.net" = {
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
      sslCertificate = "/var/lib/tailscale-tls/cert.crt";
      sslCertificateKey = "/var/lib/tailscale-tls/key.key";
    };
  };

  # Enable the touchpad
  environment.systemPackages = with pkgs; [libinput];

  # Home-manager desktop configuration
  home-manager.users."nico" = import ../../home-manager/nico/nico.nix;

  # Currently plagued by https://github.com/NixOS/nixpkgs/issues/180175
  systemd.services.NetworkManager-wait-online.enable = false;

  # NixOS stuff
  system.stateVersion = "22.11";
}
