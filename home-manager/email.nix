{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.dr460nixed.hm.email;
in
{
  options.dr460nixed.hm.email = {
    enable = lib.mkEnableOption "Email client configuration";
  };

  config = lib.mkIf cfg.enable {
    services.gpg-agent = {
      enable = true;
      enableExtraSocket = true;
      enableScDaemon = true;
      pinentry.package = pkgs.pinentry-qt;
    };

    programs.thunderbird = {
      enable = true;
      profiles."default" = {
        isDefault = true;
        settings = {
          "calendar.timezone.local" = "Europe/Berlin";
          "calendar.timezone.useSystemTimezone" = true;
          "datareporting.healthreport.uploadEnabled" = false;
          "font.name.sans-serif.x-western" = "Inter";
          "mail.incorporate.return_receipt" = 1;
          "mail.markAsReadOnSpam" = true;
          "mail.spam.logging.enabled" = true;
          "mail.spam.manualMark" = true;
          "offline.download.download_messages" = 1;
          "offline.send.unsent_messages" = 1;
        };
      };
    };
  };
}
