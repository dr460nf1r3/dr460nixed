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
    thunderbird = lib.mkEnableOption "Thunderbird email client";
    gpg-agent = lib.mkEnableOption "GPG agent";
    syncthing = lib.mkEnableOption "Syncthing file sync";
    nextcloud = lib.mkEnableOption "Nextcloud client";
  };

  config = lib.mkIf cfg.enable {
    services = {
      gpg-agent = lib.mkIf cfg.gpg-agent {
        enable = true;
        enableExtraSocket = true;
        enableScDaemon = true;
        pinentry.package = pkgs.pinentry-qt;
      };
      syncthing = lib.mkIf cfg.syncthing {
        enable = true;
      };
      nextcloud-client = lib.mkIf cfg.nextcloud {
        enable = true;
        startInBackground = true;
      };
    };

    programs.thunderbird = lib.mkIf cfg.thunderbird {
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
