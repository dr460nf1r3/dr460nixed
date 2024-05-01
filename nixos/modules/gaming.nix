{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.dr460nixed.gaming;
in {
  options.dr460nixed.gaming = {
    enable =
      mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Whether this device is used for gaming.
        '';
      };
  };

  config = mkIf cfg.enable {
    # ProtonGE-Custom
    chaotic.steam.extraCompatPackages = with pkgs; [proton-ge-custom];

    # Gamemode
    programs.gamemode.enable = true;

    # Enable Steam
    programs.steam.enable = true;
  };
}
