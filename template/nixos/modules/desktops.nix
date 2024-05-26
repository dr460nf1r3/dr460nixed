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

    # # Kernel parameters & settings
    boot.kernelParams = ["mitigations=off"];

    # Fancy themed, enhanced Spotify
    programs.spicetify = {
      enable = true;
      theme = spicePkgs.themes.Comfy;
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
      injectCss = true;
      replaceColors = true;
      overwriteAssets = true;
      sidebarConfig = true;
      enabledCustomApps = with spicePkgs.apps; [
        lyrics-plus
        new-releases
      ];
    };
  };
}
