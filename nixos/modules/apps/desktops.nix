{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dr460nixed.desktops;
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};

  patchDesktop =
    pkg: appName: from: to:
    lib.hiPrio (
      pkgs.runCommand "$patched-desktop-entry-for-${appName}" { } ''
        ${pkgs.coreutils}/bin/mkdir -p $out/share/applications
        ${pkgs.gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop
      ''
    );
  GPUOffloadApp =
    pkg: desktopName:
    lib.mkIf (config.hardware.nvidia.prime.offload.enable or false) (
      patchDesktop pkg desktopName "^Exec=" "Exec=nvidia-offload "
    );
in
{
  options.dr460nixed.desktops = with lib; {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc "Whether to enable basic dr460nized desktop theming.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Enable the Catppuccinified desktops settings
    dr460nixed.garuda.catppuccin.enable = true;

    environment = {
      variables = {
        VISUAL = lib.mkForce "vscode";
      };
    };

    services.desktopManager.plasma6.enable = true;
    services.displayManager.plasma-login-manager.enable = true;
    services.displayManager.sddm.enable = lib.mkForce false;

    # Allow better Syncthing speeds
    services.syncthing.openDefaultPorts = true;

    # Fancy themed, enhanced Spotify
    programs.spicetify = {
      colorScheme = "catppuccin-mocha";
      enable = true;
      enabledCustomApps = with spicePkgs.apps; [
        lyricsPlus
        newReleases
      ];
      enabledExtensions = with spicePkgs.extensions; [
        autoSkipVideo
        beautifulLyrics
        betterGenres
        bookmark
        fullAlbumDate
        fullAppDisplayMod
        groupSession
        hidePodcasts
        history
        playlistIcons
        seekSong
        songStats
      ];
      theme = spicePkgs.themes.comfy;
    };

    # Disable QML cache for better performance / less issues
    environment.variables = {
      QML_DISABLE_DISK_CACHE = "1";
    };

    # Desktop applications
    environment.systemPackages = with pkgs; [
      appimage-run
      aspell
      aspellDicts.de
      aspellDicts.en
      ayugram-desktop
      boxbuddy
      brave
      catppuccinifier-cli
      gimp
      hunspell
      hunspellDicts.de_DE
      hunspellDicts.en_US
      inputs.kwin-effects-forceblur.packages.${pkgs.system}.default
      kdePackages.kdenlive
      kdePackages.kleopatra
      kdePackages.krdc
      kdePackages.krfb
      libreoffice-qt6-fresh
      libsecret
      libva-utils
      lm_sensors
      movit
      obs-studio-wrapped
      (GPUOffloadApp obs-studio-wrapped "com.obsproject.Studio")
      plasmusic-toolbar
      signal-desktop
      usbutils
      vesktop
      vorta
      vulkan-tools
      xdg-utils
    ];
  };
}
