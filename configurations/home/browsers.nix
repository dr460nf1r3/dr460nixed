{pkgs, ...}: {
  # Thunderbird configuration
  programs.thunderbird = {
    enable = true;
    profiles."nico" = {
      isDefault = true;
      settings = {
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

  # Basic Chromium settings using Ungoogled Chromium (user)
  programs.chromium = {
    commandLineArgs = [
      "--enable-accelerated-2d-canvas"
      "--enable-features=VaapiVideoDecoder"
      "--enable-features=WebUIDarkMode"
      "--enable-gpu-rasterization"
      "--enable-vulkan"
      "--enable-zero-copy"
      "--ignore-gpu-blocklist"
      "--ozone-platform-hint=auto"
    ];
    enable = true;
    extensions = [
      {
        id = "oladmjdebphlnjjcnomfhhbfdldiimaf";
        updateUrl = "https://raw.githubusercontent.com/libredirect/libredirect/master/src/updates/updates.xml";
      }
    ];
  };
}
