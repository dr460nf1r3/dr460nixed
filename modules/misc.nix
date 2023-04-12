{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.dr460nixed;
in
{
  options.dr460nixed = {
    live-cd = lib.mkOption
      {
        default = false;
        type = types.bool;
        internal = true;
        description = lib.mdDoc ''
          Whether this is live CD.
        '';
      };
    yubikey = lib.mkOption
      {
        default = false;
        type = types.bool;
        internal = true;
        description = lib.mdDoc ''
          Whether this device uses a Yubikey.
        '';
      };
    chromium = lib.mkOption
      {
        default = false;
        type = types.bool;
        internal = true;
        description = lib.mdDoc ''
          Whether this device uses should use Chromium.
        '';
      };
    school = lib.mkOption
      {
        default = false;
        type = types.bool;
        internal = true;
        description = lib.mdDoc ''
          Whether this device uses should be used for school.
        '';
      };
  };

  config = {
    # Enable the smartcard daemon
    hardware.gpgSmartcards.enable = lib.mkIf config.dr460nixed.yubikey true;
    services.pcscd.enable = lib.mkIf config.dr460nixed.yubikey true;
    services.udev.packages = lib.mkIf config.dr460nixed.yubikey [ pkgs.yubikey-personalization ];

    # Configure as challenge-response for instant login,
    # can't provide the secrets as the challenge gets updated
    security.pam.yubico = lib.mkIf config.dr460nixed.yubikey {
      debug = false;
      enable = true;
      mode = "challenge-response";
    };

    # Basic chromium settings (system-wide)
    programs.chromium = lib.mkIf config.dr460nixed.chromium {
      defaultSearchProviderEnabled = true;
      defaultSearchProviderSearchURL = "https://search.dr460nf1r3.org/search?q=%s";
      defaultSearchProviderSuggestURL = "https://search.dr460nf1r3.org/autocomplete?q=%s";
      enable = true;
      extensions = [
        "ajhmfdgkijocedmfjonnpjfojldioehi" # Privacy Pass
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock origin
        "hipekcciheckooncpjeljhnekcoolahp" # Tabliss
        "kbfnbcaeplbcioakkpcpgfkobkghlhen" # Grammarly
        "mdjildafknihdffpkfmmpnpoiajfjnjd" # Consent-O-Matic
        "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock
        "njdfdhgcmkocbgbhcioffdbicglldapd" # LocalCDN
        "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
      ];
      extraOpts = {
        "HomepageLocation" = "https://search.dr460nf1r3.org";
        "QuicAllowed" = true;
        "RestoreOnStartup" = true;
        "ShowHomeButton" = true;
      };
    };

    # SUID Sandbox
    security.chromiumSuidSandbox.enable = lib.mkIf config.dr460nixed.chromium true;
  };
}
