{
  config,
  lib,
  ...
}:
let
  cfg = config.dr460nixed.auto-upgrade;
in
{
  options.dr460nixed.auto-upgrade = {
    enable = lib.mkEnableOption "automatic system upgrades";
  };

  config = lib.mkIf cfg.enable {
    system.autoUpgrade = {
      allowReboot = true;
      dates = "04:00";
      enable = true;
      flake = "github:dr460nf1r3/dr460nixed";
      randomizedDelaySec = "1h";
      rebootWindow = {
        lower = "00:00";
        upper = "06:00";
      };
    };
  };
}
