{...}: {
  # System-wide policies
  programs.firefox = {
    enable = true;
    policies = {
      CaptivePortal = false;
      DisableFirefoxAccounts = false;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      FirefoxHome = {
        Highlights = false;
        Pocket = false;
        Search = true;
        Snippets = false;
        TopSites = false;
      };
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      OfferToSaveLoginsDefault = false;
      PasswordManagerEnabled = false;
      UserMessaging = {
        ExtensionRecommendations = false;
        SkipOnboarding = true;
      };
    };
  };

  # Enable Wayland
  # environment.sessionVariables = {
  #  MOZ_ENABLE_WAYLAND = "1";
  #  MOZ_USE_XINPUT2 = "1";
  # };
}
