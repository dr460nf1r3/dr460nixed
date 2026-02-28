{
  config,
  lib,
  ...
}:
let
  cfg = config.dr460nixed.smtp;
in
{
  options.dr460nixed.smtp = with lib; {
    enable = mkEnableOption "Enable sending mails via CMD using msmtp.";
    user = mkOption {
      type = types.str;
      description = mdDoc "The SMTP user.";
    };
    host = mkOption {
      type = types.str;
      default = "mail.garudalinux.net";
      description = mdDoc "The SMTP host.";
    };
    from = mkOption {
      type = types.str;
      description = mdDoc "The default from address.";
    };
    passwordeval = mkOption {
      type = types.str;
      description = mdDoc "The command to evaluate to get the password.";
    };
  };

  config = lib.mkIf cfg.enable {
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
          inherit (cfg)
            from
            host
            user
            passwordeval
            ;
        };
      };
    };
    environment.etc = {
      "aliases".text = ''
        root: ${cfg.from}
      '';
    };
  };
}
