{ pkgs, ... }:
let
  # This was for some reason needed to get it working and I don't know why
  flake-compat = builtins.fetchTarball {
    url = "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
    sha256 = "1prd9b1xx8c0sfwnyzkspplh30m613j42l1k789s521f4kv4c2z2";
  };
  spicetify-nix =
    (import flake-compat {
      src = builtins.fetchTarball {
        url = "https://github.com/the-argus/spicetify-nix/archive/master.tar.gz";
        sha256 = "1ri60f2v1sz6wwqcp97hqhb0bbynfkg5155kxp7kmchhp4g8ayz8";
      };
    }).defaultNix;
  spicePkgs = spicetify-nix.packages.${pkgs.system}.default;
in
{
  # Import the spicetify-cli home-manager module
  imports = [
    spicetify-nix.homeManagerModule
  ];

  # Fancy Gruvbox themed, enhanced Spotify
  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.Comfy;
    enabledExtensions = with spicePkgs.extensions; [
      autoSkipVideo
      fixEnhance
      fullAlbumDate
      fullAppDisplayMod
      genre
      groupSession
      hidePodcasts
      history
      playlistIcons
      popupLyrics
      seekSong
    ];
    injectCss = true;
    replaceColors = true;
    overwriteAssets = true;
    sidebarConfig = true;
    enabledCustomApps = with spicePkgs.apps; [
      lyrics-plus
      marketplace
      new-releases
    ];
  };
}
