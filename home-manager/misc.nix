{pkgs, ...}: {
  # Thunderbird configuration
  programs.thunderbird = {
    enable = true;
    package = pkgs.thunderbird-128;
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

  # Enable the smartcard daemon for commit signing
  services.gpg-agent = {
    enable = true;
    enableExtraSocket = true;
    enableScDaemon = true;
    pinentryPackage = pkgs.pinentry-qt;
  };

  # Syncthing to sync files between devices
  services.syncthing = {
    enable = true;
  };

  # Nextcloud sync client
  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };
}
