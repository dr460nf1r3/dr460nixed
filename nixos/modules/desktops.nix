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

    # Allow better Syncthing speeds
    services.syncthing.openDefaultPorts = true;

    # # Kernel paramters & settings
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

    # Pipewire configuration
    environment.etc = {
      # Allow pipewire to dynamically adjust the rate sent to the devices based on the playback stream
      "pipewire/pipewire.conf.d/99-allowed-rates.conf".text = builtins.toJSON {
        "context.properties"."default.clock.allowed-rates" = [
          44100
          48000
          88200
          96000
          176400
          192000
        ];
      };
      # If resampling is required, use a higher quality. 15 is overkill and too cpu expensive without any obvious audible advantage
      "pipewire/pipewire-pulse.conf.d/99-resample.conf".text = builtins.toJSON {
        "stream.properties"."resample.quality" = 10;
      };
      "pipewire/client.conf.d/99-resample.conf".text = builtins.toJSON {
        "stream.properties"."resample.quality" = 10;
      };
      "pipewire/client-rt.conf.d/99-resample.conf".text = builtins.toJSON {
        "stream.properties"."resample.quality" = 10;
      };
    };
  };
}
