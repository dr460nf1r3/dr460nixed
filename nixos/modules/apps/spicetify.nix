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
in
{
  config = lib.mkIf cfg.spicetify {
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
  };
}
