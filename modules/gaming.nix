{ config
, lib
, pkgs
, ...
}:
with lib;
let
  cfg = config.dr460nixed.gaming;
in
{
  options.dr460nixed.gaming = {
    enable = mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Enables gaming related apps and services.
        '';
      };
  };

  config = mkIf cfg.enable {
    # Gaming packages
    environment.systemPackages = with pkgs; [
      lutris
      mangohud
      # prismlauncher-mod
      (retroarch.override {
        cores = with libretro; [
          citra
          flycast
          ppsspp
        ];
      })
      wine-staging
      winetricks
    ];

    # Enable gamemode
    programs.gamemode.enable = true;
    programs.steam.gamescopeSession.enable = true;

    # Instant replays
    services.replay-sorcery = {
      enable = true;
      autoStart = false;
      settings = {
        videoQuality = "auto";
      };
    };

    # Enable Steam
    programs.steam.enable = true;

    # ProtonGE for Steam
    chaotic.steam.extraCompatPackages = with pkgs; [ proton-ge-custom ];

    # Use unstable gamescope package
    chaotic.gamescope = {
      args = [ "--rt" "--prefer-vk-device 1002:1636" ];
      enable = true;
      env = { "__GLX_VENDOR_LIBRARY_NAME" = "amd"; };
      package = pkgs.gamescope_git;
    };

    # Fix League of Legends
    boot.kernel.sysctl = {
      "abi.vsyscall32" = 0;
    };
  };
}
