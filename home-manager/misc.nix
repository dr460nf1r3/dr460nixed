{pkgs, ...}: {
  # Thunderbird configuration
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

  # MangoHUD to monitor performance while gaming
  programs.mangohud = {
    enable = false;
    settings = {
      arch = true;
      background_alpha = "0.05";
      battery = true;
      cpu_temp = true;
      engine_version = true;
      font_size = 17;
      fps_limit = 60;
      gl_vsync = 0;
      gpu_name = true;
      gpu_temp = true;
      io_read = true;
      io_write = true;
      position = "top-right";
      round_corners = 8;
      vram = true;
      vsync = 1;
      vulkan_driver = true;
      width = 260;
      wine = true;
    };
  };
}
