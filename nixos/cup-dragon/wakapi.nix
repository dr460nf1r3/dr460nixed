{config, ...}: {
  # Wakapi for tracking coding activity better than Wakatime
  services.wakapi = {
    enable = true;
    database = {
      createLocally = true;
      dialect = "postgres";
    };
    passwordSaltFile = config.sops.secrets."passwords/wakapi".path;
    settings = {
      db = {
        dialect = "postgres";
        host = "127.0.0.1";
        name = "wakapi";
        user = "wakapi";
        port = 5432;
      };
      mail = {
        enabled = true;
        provider = "smtp";
        sender = "Wakapi <noreply@dr460nf1r3.org>";
        smtp = {
          host = "mail.garudalinux.net";
          port = 465;
          username = "noreply@dr460nf1r3.org";
          tls = true;
        };
      };
      security = {
        allow_signup = false;
        insecure_cookies = false;
        invite_codes = true;
      };
    };
  };
  sops.secrets."passwords/wakapi" = {
    mode = "0400";
    owner = config.users.users."wakapi".name;
    path = "/var/lib/wakapi/.salt";
  };
  sops.secrets."passwords/wakapi_db" = {
    mode = "0400";
    owner = config.users.users."wakapi".name;
    path = "/var/lib/wakapi/.db";
  };
  sops.secrets."mail/wakapi" = {
    mode = "0400";
    owner = config.users.users."wakapi".name;
    path = "/var/lib/wakapi/.mail";
  };

  services.nginx.virtualHosts = {
    "waka.dr460nf1r3.org" = {
      forceSSL = true;
      http3 = true;
      http3_hq = true;
      kTLS = true;
      locations."/" = {
        proxyPass = "http://127.0.0.1:3000";
      };
      quic = true;
      useACMEHost = "dr460nf1r3.org";
    };
  };
}
