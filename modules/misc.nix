{ config
, lib
, pkgs
, ...
}:
with lib;
let
  cfg = config.dr460nixed;
  chromium-gate = pkgs.writeShellScriptBin "chromium-gate" ''
    set -o errexit

    CHROMIUM="${pkgs.chromium-flagged}/bin/chromium"
    KDIALOG="${pkgs.libsForQt5.kdialog}/bin/kdialog"
    ZFS="${pkgs.zfs}/bin/zfs"

    echo 'Handling encrypted Chromium profile'
    if [ "$USER" != 'nico' ] || [ -f "$HOME/.config/chromium" ]; then
      exec "$CHROMIUM" "$@"
    else
      "$KDIALOG" --title "Chromium gatekeeper" --password "Please provide the password for the Chromium vault 🔑" |\
        (sudo "$ZFS" load-key zroot/data/chromium \
        || ("$KDIALOG" --title "Chromium gatekeeper" --error "Unable to load ZFS key, loading fresh profile instead!" \
        && "$CHROMIUM" "$@" && false))
      sudo "$ZFS" mount zroot/data/chromium \
        || ("$KDIALOG" --title "Chromium gatekeeper" --error "Unable to mount ZFS partition, loading fresh profile instead!" \
        && "$CHROMIUM" "$@" && false)

      "$CHROMIUM" "$@"

      sudo "$ZFS" umount -f zroot/data/chromium
      sudo "$ZFS" unload-key zroot/data/chromium
    fi
  '';
in
{
  options.dr460nixed = {
    auto-upgrade = mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Whether this device automatically upgrades.
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
    chromium-gate = mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Whether to protect Chromium with a password with a ZFS encrypted partition.
        '';
      };
    live-cd = mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Whether this is live CD.
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
    yubikey = mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Whether this device uses a Yubikey.
        '';
      };
  };

  config = {
    # Automatic system upgrades via git and flakes
    system.autoUpgrade = mkIf cfg.auto-upgrade {
      allowReboot = true;
      dates = "04:00";
      enable = true;
      flake = "github:dr460nf1r3/dr460nixed";
      randomizedDelaySec = "1h";
      rebootWindow = { lower = "00:00"; upper = "06:00"; };
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
      defaultSearchProviderSearchURL = "https://searx.dr460nf1r3.org/search?q=%s";
      defaultSearchProviderSuggestURL = "https://searx.dr460nf1r3.org/autocomplete?q=%s";
      enable = true;
      extensions = [
        "ajhmfdgkijocedmfjonnpjfojldioehi" # Privacy Pass
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock origin
        "doojmbjmlfjjnbmnoijecmcbfeoakpjm" # NoScript
        "edibdbjcniadpccecjdfdjjppcpchdlm" # I Still Don't Care About Cookies
        "fhnegjjodccfaliddboelcleikbmapik" # Tab Counter
        "hipekcciheckooncpjeljhnekcoolahp" # Tabliss
        "kbfnbcaeplbcioakkpcpgfkobkghlhen" # Grammarly
        "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock
        "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
        "oladmjdebphlnjjcnomfhhbfdldiimaf;https://raw.githubusercontent.com/libredirect/libredirect/master/src/updates/updates.xml" # Libredirect
      ];
      extraOpts = {
        "HomepageLocation" = "https://searx.dr460nf1r3.org";
        "QuicAllowed" = true;
        "RestoreOnStartup" = true;
        "ShowHomeButton" = true;
      };
    };

    # SUID Sandbox
    security.chromiumSuidSandbox.enable = mkIf cfg.chromium true;

    # Chromium gate (thanks Pedro!)
    environment.systemPackages = mkIf cfg.chromium-gate [ chromium-gate ];
  };
}
