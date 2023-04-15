{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.dr460nixed.gaming;
in
{
  options.dr460nixed.gaming = {
    enable = lib.mkOption
      {
        default = false;
        type = types.bool;
        description = lib.mdDoc ''
          Enables gaming related apps and services.
        '';
      };
  };

  config = mkIf cfg.enable {
    # Gaming packages
    environment.systemPackages = with pkgs; [
      bottles
      lutris
      mangohud
      prismlauncher-mod
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

    # Fix League of Legends
    boot.kernel.sysctl = {
      "abi.vsyscall32" = 0;
    };
  };
}
