{
  config,
  lib,
  pkgs,
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
    # Enhance performance tweaks
    dr460nixed.garuda.performance-tweaks.enable = true;
    boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
  };
}
