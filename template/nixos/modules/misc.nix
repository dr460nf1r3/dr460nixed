{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dr460nixed;
in {
  options.dr460nixed = with lib; {
    adblock =
      mkOption
      {
        default = true;
        type = types.bool;
        description = mdDoc ''
          Whether hosts-based ad blocking should be set up.
        '';
      };
    auto-upgrade =
      mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Whether this device automatically upgrades.
        '';
      };
    chromium =
      mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Whether this device uses should use Chromium.
        '';
      };
    chromium-gate =
      mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Whether to protect Chromium with a password with a ZFS encrypted partition.
        '';
      };
    live-cd =
      mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Whether this is live CD.
        '';
      };
    performance =
      mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Whether this device should be optimized for performance.
        '';
      };
    school =
      mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Whether this device uses should be used for school.
        '';
      };
    tor =
      mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Whether this device should be using the tor network.
        '';
      };
    yubikey =
      mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Whether this device uses a Yubikey.
        '';
      };
  };

  config = {
    # Automatic system upgrades via git and flakes - CHANGE THE "flake"!
    system.autoUpgrade = lib.mkIf cfg.auto-upgrade {
      allowReboot = true;
      dates = "04:00";
      enable = true;
      flake = null;
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
      plugins = [pkgs.ccid];
    };
    services.udev.packages = lib.mkIf cfg.yubikey [pkgs.yubikey-personalization];

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
      extensions = [
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock origin
        "hipekcciheckooncpjeljhnekcoolahp" # Tabliss
        "mdjildafknihdffpkfmmpnpoiajfjnjd" # Consent-O-Matic
      ];
      extraOpts = {
        "QuicAllowed" = true;
        "RestoreOnStartup" = true;
        "ShowHomeButton" = true;
      };
      homepageLocation = "https://searx.garudalinux.org";
    };

    # SUID Sandbox
    security.chromiumSuidSandbox.enable = lib.mkIf cfg.chromium true;

    # Enhance performance tweaks
    garuda.performance-tweaks.enable = lib.mkIf cfg.performance true;
    boot.kernelPackages = lib.mkIf cfg.performance pkgs.linuxPackages_cachyos-lto;

    # /etc/hosts based adblocker
    networking.stevenBlackHosts = lib.mkIf cfg.adblock {
      blockFakenews = true;
      blockGambling = true;
      enable = true;
    };
  };
}
