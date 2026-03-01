{
  config,
  dragonLib,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dr460nixed.gaming;
in
{
  options.dr460nixed.gaming = with lib; {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc ''
        Whether this device is used for gaming.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    programs.gamemode.enable = true;

    programs.steam = {
      enable = true;
      extraCompatPackages = with pkgs; [
        proton-cachyos-x86_64_v4
      ];
    };

    environment.systemPackages = with pkgs; [
      lutris
      prismlauncher
      (dragonLib.GPUOffloadApp config pkgs prismlauncher "org.prismlauncher.PrismLauncher")
      (dragonLib.GPUOffloadApp config pkgs steam "steam")
    ];

    drivers.mesa-git = {
      enable = true;
      cacheCleanup = {
        enable = true;
        protonPackage = pkgs.proton-cachyos-x86_64_v4;
      };
      steamOrphanCleanup = {
        enable = true;
      };
    };
  };
}
