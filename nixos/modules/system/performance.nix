{
  config,
  lib,
  ...
}:
let
  cfg = config.dr460nixed.performance;
in
{
  options.dr460nixed.performance = {
    enable = lib.mkEnableOption "performance optimizations";
  };

  config = lib.mkIf cfg.enable {
    garuda.performance-tweaks.enable = true;
  };
}
