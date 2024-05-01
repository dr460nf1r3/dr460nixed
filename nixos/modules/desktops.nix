{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.dr460nixed.desktops;
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in {
  options.dr460nixed.desktops = {
    enable =
      mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Whether to enable basic dr460nized desktop theming.
        '';
      };
  };

  config = mkIf cfg.enable {
    # Only install fonts I personally use
    fonts.enableDefaultPackages = false;

    # Enable the dr460nized desktops settings
    garuda.dr460nized.enable = true;

    environment = {
      variables = {
        VISUAL = lib.mkForce "vscode";
      };
    };

    # Allow better Syncthing speeds
    services.syncthing.openDefaultPorts = true;

    # Fancy themed, enhanced Spotify
    programs.spicetify = {
      colorScheme = "mocha";
      enable = true;
      enabledCustomApps = with spicePkgs.apps; [
        lyrics-plus
        new-releases
      ];
      enabledExtensions = with spicePkgs.extensions; [
        autoSkipVideo
        bookmark
        fullAlbumDate
        fullAppDisplayMod
        genre
        groupSession
        hidePodcasts
        history
        playlistIcons
        popupLyrics
        seekSong
        songStats
      ];
      theme = spicePkgs.themes.catppuccin;
      injectCss = true;
      overwriteAssets = true;
      replaceColors = true;
      sidebarConfig = true;
    };

    # Bitwarden client for additional convenience
    programs.goldwarden.enable = true;
  };
}
