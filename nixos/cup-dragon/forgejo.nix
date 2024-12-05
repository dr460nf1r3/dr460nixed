{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.forgejo;
  srv = cfg.settings.server;
  theme = pkgs.fetchzip {
    url = "https://github.com/catppuccin/gitea/releases/download/v1.0.1/catppuccin-gitea.tar.gz";
    sha256 = "sha256-et5luA3SI7iOcEIQ3CVIu0+eiLs8C/8mOitYlWQa/uI=";
    stripRoot = false;
  };
  woodpecker-server = "ci.dr460nf1r3.org";
in {
  services.nginx = {
    virtualHosts = {
      ${cfg.settings.server.DOMAIN} = {
        extraConfig = ''
          client_max_body_size 512M;
        '';
        forceSSL = true;
        http3 = true;
        http3_hq = true;
        kTLS = true;
        locations."/".proxyPass = "http://localhost:${toString srv.HTTP_PORT}";
        quic = true;
        useACMEHost = "dr460nf1r3.org";
      };
    };
  };

  services.forgejo = {
    enable = true;
    database.type = "postgres";
    lfs.enable = true;
    settings = {
      actions.ENABLED = true;
      DEFAULT = {
        APP_NAME = "Dragon's Git forge";
        APP_SLOGAN = "The place where dragons forge their code";
      };
      mailer = {
        ENABLED = true;
        FROM = "noreply@dr460nf1r3.org";
        PASSWD = config.sops.secrets."mail/forgejo".path;
        SMTP_ADDR = "mail.garudalinux.net";
        USER = "noreply@dr460nf1r3.org";
      };
      other = {
        SHOW_FOOTER_VERSION = true;
      };
      server = {
        DOMAIN = "git.dr460nf1r3.org";
        HTTP_PORT = 3050;
        ROOT_URL = "https://${srv.DOMAIN}/";
      };
      service.DISABLE_REGISTRATION = true;
      session.COOKIE_SECURE = true;
      ui = {
        DEFAULT_THEME = "catppuccin-maroon-auto";
        THEMES = "catppuccin-rosewater-auto,catppuccin-flamingo-auto,catppuccin-pink-auto,catppuccin-mauve-auto,catppuccin-red-auto,catppuccin-maroon-auto,catppuccin-peach-auto,catppuccin-yellow-auto,catppuccin-green-auto,catppuccin-teal-auto,catppuccin-sky-auto,catppuccin-sapphire-auto,catppuccin-blue-auto,catppuccin-lavender-auto";
      };
    };
  };

  sops.secrets."mail/forgejo" = {
    mode = "0400";
    owner = config.users.users.forgejo.name;
    path = "/var/lib/forgejo/.mail";
  };
  sops.secrets."passwords/forgejo" = {
    mode = "0400";
    owner = config.users.users.forgejo.name;
    path = "/var/lib/forgejo/.password";
  };

  # Link Catppuccin themes and ensure admin user
  systemd.services.forgejo.preStart = let
    adminCmd = "${lib.getExe cfg.package} admin user";
    pwd = config.sops.secrets."passwords/forgejo";
    user = "root";
  in ''
    ${adminCmd} create --admin --email "root@localhost" --username ${user} --password "$(tr -d '\n' < ${pwd.path})" || true
    # ${adminCmd} change-password --username ${user} --password "$(tr -d '\n' < ${pwd.path})" || true

    rm -rf ${config.services.forgejo.stateDir}/custom/public/assets
    mkdir -p ${config.services.forgejo.stateDir}/custom/public/assets
    ln -sf ${theme} ${config.services.forgejo.stateDir}/custom/public/assets/css
  '';

  # Runner for Forgejo Actions
  services.gitea-actions-runner = {
    package = pkgs.forgejo-actions-runner;
    instances.default = {
      enable = true;
      name = "cup-dragon-1";
      url = "https://git.dr460nf1r3.org";
      tokenFile = config.sops.secrets."api_keys/forgejo_runner".path;
      labels = [
        "ubuntu-latest:docker://node:16-bullseye"
        "ubuntu-22.04:docker://node:16-bullseye"
        "native:host"
      ];
    };
  };
  sops.secrets."api_keys/forgejo_runner" = {
    mode = "0400";
    path = "/var/lib/gitea-runner/.token";
  };

  # Woodpecker CI/CD, just because why not?
  services.woodpecker-server = {
    enable = true;
    environment = {
      WOODPECKER_FORGEJO = "true";
      WOODPECKER_FORGEJO_URL = "https://git.dr460nf1r3.org";
      WOODPECKER_HOST = "https://${woodpecker-server}";
      WOODPECKER_OPEN = "true";
      WOODPECKER_SERVER_ADDR = ":3007";
    };
    environmentFile = config.sops.secrets."env/woodpecker".path;
  };
  sops.secrets."env/woodpecker" = {
    mode = "0400";
    owner = config.users.users.root.name;
    path = "/var/lib/woodpecker/.env";
  };

  services.woodpecker-agents.agents."docker" = {
    enable = true;
    extraGroups = ["podman"];
    environment = {
      DOCKER_HOST = "unix:///run/podman/podman.sock";
      WOODPECKER_BACKEND = "docker";
      WOODPECKER_MAX_WORKFLOWS = "4";
      WOODPECKER_SERVER = "localhost:9000";
    };
    environmentFile = [config.sops.secrets."env/woodpecker".path];
  };
}
