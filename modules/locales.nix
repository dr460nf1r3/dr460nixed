{ config
, lib
, pkgs
, ...
}:
with lib;
let
  cfg = config.dr460nixed.locales;
in
{
  options.dr460nixed.locales = {
    enable = mkOption
      {
        default = true;
        type = types.bool;
        description = mdDoc ''
          Whether the operating system be having a default set of locales set.
        '';
      };

    config = mkIf cfg.enable {
      # Timezone
      time = {
        timeZone = "Europe/Berlin";
        hardwareClockInLocalTime = true;
      };

      # Common locale settings
      i18n =
        let
          defaultLocale = "en_US.UTF-8";
          de = "de_DE.UTF-8";
        in
        {
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

          supportedLocales = mkDefault [
            "en_US.UTF-8/UTF-8"
            "de_DE.UTF-8/UTF-8"
          ];
        };

      # Console font
      console =
        let
          variant = "116n";
        in
        {
          font = "${pkgs.terminus_font}/share/consolefonts/ter-${variant}.psf.gz";
          keyMap = "de";
        };

      # X11 keyboard layout
      services.xserver = mkIf config.dr460nixed.desktops.enable {
        layout = "de";
        xkbVariant = "";
      };
    };
  };
}
