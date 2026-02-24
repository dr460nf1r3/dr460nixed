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
      extraCompatPackages = with pkgs; [ ];
    };

    environment.systemPackages = with pkgs; [
      protonplus
      lutris
      prismlauncher
      (dragonLib.GPUOffloadApp config pkgs prismlauncher "org.prismlauncher.PrismLauncher")
      (dragonLib.GPUOffloadApp config pkgs steam "steam")
    ];
  };
}
