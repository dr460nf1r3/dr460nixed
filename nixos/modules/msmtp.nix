{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.dr460nixed.smtp;
in {
  options.dr460nixed.smtp = {
    enable =
      mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Enable sending mails via CMD using msmtp.
        '';
      };
  };

  config = mkIf cfg.enable {
    programs.msmtp = {
      enable = true;
      setSendmail = true;
      defaults = {
        aliases = "/etc/aliases";
        auth = "login";
        port = 465;
        tls = "on";
        tls_starttls = "off";
        tls_trust_file = "/etc/ssl/certs/ca-certificates.crt";
      };
      accounts = {
        default = {
          from = "nico@dr460nf1r3.org";
          host = "mail.garudalinux.net";
          passwordeval = "cat /run/secrets/passwords/nico@dr460nf1r3.org";
          user = "nico@dr460nf1r3.org";
        };
      };
    };
    environment.etc = {
      "aliases".text = ''
        root: nico@dr460nf1r3.org
      '';
    };
  };
}
