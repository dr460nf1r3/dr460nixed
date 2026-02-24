{
  config,
  lib,
  ...
}:
let
  cfg = config.dr460nixed.live-cd;
in
{
  options.dr460nixed.live-cd = {
    enable = lib.mkEnableOption "live CD applications and configurations";
  };

  config = lib.mkIf cfg.enable {
    # No specific config here from misc.nix other than the option definition
    # but it's used elsewhere.
  };
}
