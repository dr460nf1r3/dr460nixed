{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dr460nixed;
in
{
  options.dr460nixed = with lib; {
    auto-upgrade = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc ''
        Whether this device automatically upgrades.
      '';
    };
    chromium = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc ''
        Whether this device uses should use Chromium.
      '';
    };
    live-cd = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc ''
        Whether this is live CD.
      '';
    };
    performance = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc ''
        Whether this device should be optimized for performance.
      '';
    };
    tor = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc ''
        Whether this device should be using the tor network.
      '';
    };
    yubikey = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc ''
        Whether this device uses a Yubikey.
      '';
    };
  };

  config = {
    # Automatic system upgrades via git and flakes
    system.autoUpgrade = lib.mkIf cfg.auto-upgrade {
      allowReboot = true;
      dates = "04:00";
      enable = true;
      flake = "github:dr460nf1r3/dr460nixed";
      randomizedDelaySec = "1h";
      rebootWindow = {
        lower = "00:00";
        upper = "06:00";
      };
    };

    # Enable the tor network
    services.tor = lib.mkIf cfg.tor {
      client.dns.enable = true;
      client.enable = true;
      enable = true;
      torsocks.enable = true;
    };

    # Enable the smartcard daemon
    hardware.gpgSmartcards.enable = lib.mkIf cfg.yubikey true;
    services.pcscd = {
      enable = lib.mkIf cfg.yubikey true;
      plugins = [ pkgs.ccid ];
    };
    services.udev.packages = lib.mkIf cfg.yubikey [ pkgs.yubikey-personalization ];

    # Configure as challenge-response for instant login,
    # can't provide the secrets as the challenge gets updated
    security.pam.yubico = lib.mkIf cfg.yubikey {
      debug = false;
      enable = true;
      mode = "challenge-response";
    };

    # Basic chromium settings (system-wide)
    programs.chromium = lib.mkIf cfg.chromium {
      defaultSearchProviderEnabled = true;
      defaultSearchProviderSearchURL = "https://searx.garudalinux.org/search?q=%s";
      defaultSearchProviderSuggestURL = "https://searx.garudalinux.org/autocomplete?q=%s";
      enable = true;
      enablePlasmaBrowserIntegration = true;
      extensions = [
        "bkkmolkhemgaeaeggcmfbghljjjoofoh" # Catppuccin theme
        # "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock origin
        "clngdbkpkpeebahjckkjfobafhncgmne" # Stylus
        "doojmbjmlfjjnbmnoijecmcbfeoakpjm" # NoScript
        # "fpnmgdkabkmnadcjpehmlllkndpkmiak" # Wayback Machine
        # "hipekcciheckooncpjeljhnekcoolahp" # Tabliss
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
    security.chromiumSuidSandbox.enable = lib.mkIf cfg.chromium true;

    # Enhance performance tweaks
    dr460nixed.garuda.performance-tweaks.enable = lib.mkIf cfg.performance true;
    boot.kernelPackages = lib.mkIf cfg.performance pkgs.cachyosKernels.linuxPackages-cachyos-latest;
  };
}
