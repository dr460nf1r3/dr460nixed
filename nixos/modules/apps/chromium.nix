{
  config,
  lib,
  ...
}:
let
  cfg = config.dr460nixed.chromium;
in
{
  options.dr460nixed.chromium = {
    enable = lib.mkEnableOption "Chromium with a set of default extensions and settings";
  };

  config = lib.mkIf cfg.enable {
    # Basic chromium settings (system-wide)
    programs.chromium = {
      defaultSearchProviderEnabled = true;
      defaultSearchProviderSearchURL = "https://searx.garudalinux.org/search?q=%s";
      defaultSearchProviderSuggestURL = "https://searx.garudalinux.org/autocomplete?q=%s";
      enable = true;
      enablePlasmaBrowserIntegration = true;
      extensions = [
        "bkkmolkhemgaeaeggcmfbghljjjoofoh" # Catppuccin theme
        "clngdbkpkpeebahjckkjfobafhncgmne" # Stylus
        "doojmbjmlfjjnbmnoijecmcbfeoakpjm" # NoScript
        "hlepfoohegkhhmjieoechaddaejaokhf" # Github Refined
        "kbfnbcaeplbcioakkpcpgfkobkghlhen" # Grammarly
        "mdjildafknihdffpkfmmpnpoiajfjnjd" # Consent-O-Matic
        "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock
        "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
      ];
      extraOpts = {
        "QuicAllowed" = true;
        "RestoreOnStartup" = true;
        "ShowHomeButton" = true;
      };
    };

    # SUID Sandbox
    security.chromiumSuidSandbox.enable = true;
  };
}
