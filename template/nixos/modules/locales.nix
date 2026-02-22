{
  config,
  lib,
  ...
}:
let
  cfg = config.dr460nixed.locales;
  de = "de_DE.UTF-8";
  defaultLocale = "en_GB.UTF-8";
in
{
  options.dr460nixed.locales = with lib; {
    enable = mkOption {
      default = true;
      type = types.bool;
      description = mdDoc ''
        Whether the operating system be having a default set of locales set.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # Timezone
    time = {
      hardwareClockInLocalTime = true;
      timeZone = "Europe/Berlin";
    };

    # Common locale settings
    i18n = {
      inherit defaultLocale;

      extraLocaleSettings = {
        LANG = defaultLocale;
        LC_COLLATE = defaultLocale;
        LC_CTYPE = defaultLocale;
        LC_MESSAGES = defaultLocale;

        LC_ADDRESS = de;
        LC_IDENTIFICATION = de;
        LC_MEASUREMENT = de;
        LC_MONETARY = de;
        LC_NAME = de;
        LC_NUMERIC = de;
        LC_PAPER = de;
        LC_TELEPHONE = de;
        LC_TIME = de;
      };

      supportedLocales = [
        "C.UTF-8/UTF-8"
        "de_DE.UTF-8/UTF-8"
        "en_GB.UTF-8/UTF-8"
        "en_US.UTF-8/UTF-8"
      ];
    };

    # Console font
    console.keyMap = "de";
  };
}
