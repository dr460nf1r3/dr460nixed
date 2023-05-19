{ pkgs
, ...
}:
let
  # This was for some reason needed to get it working and I don't know why
  # Newest version can't find default.nix, therefore it is pinned for now
  flake-compat = builtins.fetchTarball {
    url = "https://github.com/edolstra/flake-compat/archive/master.tar.gz";
    sha256 = "1prd9b1xx8c0sfwnyzkspplh30m613j42l1k789s521f4kv4c2z2";
  };
  spicetify-nix =
    (import flake-compat {
      src = builtins.fetchTarball {
        url = "https://github.com/the-argus/spicetify-nix/archive/master.zip";
        sha256 = "0l3k771g0bgyfp9h81mdxya8n43ks3j3bmnpcs8ng2660qk6gzs8";
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
}
