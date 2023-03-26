{
  lib,
  pkgs,
  ...
}: {
  # English locale with german units
  i18n = {
    extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
    };
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "de_DE.UTF-8/UTF-8"
      "en_GB.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
  };

  # Timezone
  time.timeZone = "Europe/Berlin";

  # X11 keyboard layout
  services.xserver = {
    layout = "de";
    xkbVariant = "";
  };

  # Supply dictionary for typing booster
  environment.systemPackages = with pkgs; [
    hunspell
    hunspellDicts.de_DE
    hunspellDicts.en_US
  ];

  # Console setup
  console = lib.mkForce {
    earlySetup = false;
    font = "Lat2-Terminus16";
    keyMap = "de";
  };
}
