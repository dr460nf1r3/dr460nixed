{ config
, lib
, pkgs
, ...
}:
with lib;
let
  cfg = config.dr460nixed;
in
{
  options.dr460nixed = {
    live-cd = mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Whether this is live CD.
        '';
      };
    yubikey = mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Whether this device uses a Yubikey.
        '';
      };
    chromium = mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Whether this device uses should use Chromium.
        '';
      };
    school = mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Whether this device uses should be used for school.
        '';
      };
    tor = mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Whether this device should be using the tor network.
        '';
      };
  };

  config = {
    # run appimages with appimage-run
    boot.binfmt.registrations = genAttrs [ "appimage" "AppImage" ] (ext: {
      interpreter = "/run/current-system/sw/bin/appimage-run";
      magicOrExtension = ext;
      recognitionType = "extension";
    });

    # run unpatched linux binaries with nix-ld
    programs.nix-ld = {
      enable = true;
      libraries = with pkgs; [
        SDL2
        curl
        freetype
        gdk-pixbuf
        glib
        glibc
        icu
        libglvnd
        libnotify
        libsecret
        libunwind
        libuuid
        openssl
        stdenv.cc.cc
        util-linux
        vulkan-loader
        xorg.libX11
        zlib
      ];
    };

    # Enable the tor network
    services.tor = mkIf cfg.tor {
      client.dns.enable = true;
      client.enable = true;
      enable = true;
      torsocks.enable = true;
    };

    # Enable the smartcard daemon
    hardware.gpgSmartcards.enable = mkIf cfg.yubikey true;
    services.pcscd.enable = mkIf cfg.yubikey true;
    services.udev.packages = mkIf cfg.yubikey [ pkgs.yubikey-personalization ];

    # Configure as challenge-response for instant login,
    # can't provide the secrets as the challenge gets updated
    security.pam.yubico = mkIf cfg.yubikey {
      debug = false;
      enable = true;
      mode = "challenge-response";
    };

    # Basic chromium settings (system-wide)
    programs.chromium = mkIf cfg.chromium {
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
    security.chromiumSuidSandbox.enable = mkIf cfg.chromium true;
  };
}
