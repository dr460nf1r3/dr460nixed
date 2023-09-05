{ config
, inputs
, lib
, pkgs
, ...
}:
with lib;
let
  cfg = config.dr460nixed.desktops;
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
in
{
  options.dr460nixed.desktops = {
    enable = mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Whether to enable basic dr460nized desktop theming.
        '';
      };
  };

  config = mkIf cfg.enable {
    # Currently needed to obtain nightly Rustdesk
    services.flatpak.enable = true;

    environment = {
      # Set this to have GTK themes apply on Wayland
      sessionVariables.GTK_THEME = "Sweet-Dark";

      # Additional KDE packages not included by default
      systemPackages = with pkgs; [ jamesdsp ];
    };

    # Only install fonts I personally use
    fonts.enableDefaultPackages = false;

    # Fix "the name ca.desrt.dconf was not provided by any .service files"
    # https://nix-community.github.io/home-manager/index.html
    programs.dconf.enable = true;

    # Allow better Syncthing speeds
    services.syncthing.openDefaultPorts = true;

    # # Kernel paramters & settings
    boot.kernelParams = [ "mitigations=off" ];

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
