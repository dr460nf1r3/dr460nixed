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
    # Enable the Catppuccinified desktops settings
    garuda.catppuccin.enable = true;

    environment = {
      variables = {
        VISUAL = lib.mkForce "vscode";
      };
    };

    # Allow better Syncthing speeds
    services.syncthing.openDefaultPorts = true;

    # Fancy themed, enhanced Spotify
    programs.spicetify = {
      colorScheme = "catppuccin-mocha";
      # spicetify-Comfy> rm: cannot remove '/nix/store/9n60w3h9rlgkb1mk6smhhb4vxq9bjga2-spicetify-Comfy/snap.yaml': No such file or directory
      # as of 20240714
      enable = false;
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
      theme = spicePkgs.themes.Comfy;
      injectCss = true;
      overwriteAssets = true;
      replaceColors = true;
      sidebarConfig = true;
    };

    # Disable QML cache for better performance / less issues
    environment.variables = {
      QML_DISABLE_DISK_CACHE = "1";
    };
  };
}
