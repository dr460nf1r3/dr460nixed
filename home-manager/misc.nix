{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.dr460nixed.hm.misc;
in
{
  options.dr460nixed.hm.misc = {
    enable = lib.mkEnableOption "miscellaneous Home Manager configuration";
  };

  config = lib.mkIf cfg.enable {
    programs.thunderbird = {
      enable = true;
      profiles."default" = {
        isDefault = true;
        settings = {
          "calendar.timezone.local" = "Europe/Berlin";
          "calendar.timezone.useSystemTimezone" = true;
          "datareporting.healthreport.uploadEnabled" = false;
          "font.name.sans-serif.x-western" = "Fira Sans";
          "mail.incorporate.return_receipt" = 1;
          "mail.markAsReadOnSpam" = true;
          "mail.spam.logging.enabled" = true;
          "mail.spam.manualMark" = true;
          "offline.download.download_messages" = 1;
          "offline.send.unsent_messages" = 1;
        };
      };
    };

    services.gpg-agent = {
      enable = true;
      enableExtraSocket = true;
      enableScDaemon = true;
      pinentry.package = pkgs.pinentry-qt;
    };

    services.syncthing = {
      enable = true;
    };

    services.nextcloud-client = {
      enable = true;
      startInBackground = true;
    };
  };
}
