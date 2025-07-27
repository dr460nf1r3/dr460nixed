{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.services.forgejo;
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
        locations."/" = {
          recommendedProxySettings = true;
          proxyPass =
            "http://unix:"
            + config.services.anubis.instances.forgejo.settings.BIND;
        };
        quic = true;
        useACMEHost = "dr460nf1r3.org";
      };
    };
  };

  services.forgejo = {
    enable = true;
    database.type = "postgres";
    lfs.enable = true;
    package = pkgs.forgejo;
    settings = {
      actions = {
        ENABLED = false;
        DEFAULT_ACTIONS_URL = "https://code.forgejo.org";
      };
      api.ENABLE_SWAGGER = false;
      attachment.ALLOWED_TYPES = "*/*";
      DEFAULT = {
        APP_NAME = "Dragon's Git forge";
        APP_SLOGAN = "The place where dragons forge their code";
      };
      federation.ENABLED = true;
      mailer = {
        ENABLED = true;
        FROM = "noreply@dr460nf1r3.org";
        PASSWD = config.sops.secrets."mail/forgejo".path;
        PROTOCOL = "smtps";
        SMTP_ADDR = "mail.garudalinux.net";
        SMTP_PORT = 465;
        USER = "noreply@dr460nf1r3.org";
      };
      other = {
        SHOW_FOOTER_VERSION = false;
        SHOW_FOOTER_TEMPLATE_LOAD_TIME = false;
        ENABLE_FEED = false;
      };
      server = {
        PROTOCOL = "http+unix";
        ROOT_URL = "https://${config.services.forgejo.settings.server.DOMAIN}";
        HTTP_PORT = 3050;
        DOMAIN = "git.dr460nf1r3.org";

        BUILTIN_SSH_SERVER_USER = "git";
        DISABLE_ROUTER_LOG = true;

        START_SSH_SERVER = true;
        SSH_CREATE_AUTHORIZED_KEYS_FILE = true;
        SSH_PORT = 2222;
        SSH_LISTEN_PORT = 2222;
        OFFLINE_MODE = false;
      };
      service.DISABLE_REGISTRATION = true;
      session.COOKIE_SECURE = true;

      "ui.meta" = {
        AUTHOR = "dr460nf1r3";
        DESCRIPTION = "Dragon's Git forge, a self-hosted Forgejo instance";
        KEYWORDS = "git,self-hosted,gitea,forgejo,dr460nf1r3,garudalinux,garuda-linux,open-source,nix,nixos,chaotic-aur,chaotic";
      };
    };
  };

  services.anubis = {
    instances.forgejo.settings = {
      TARGET = "unix://${config.services.forgejo.settings.server.HTTP_ADDR}";
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
  '';

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

  users = {
    groups.git = {};
    users.git = {
      isSystemUser = true;
      createHome = false;
      group = "git";
    };
    users.nginx.extraGroups = [config.users.groups.anubis.name];
  };
}
