{
  config,
  lib,
  ...
}:
let
  cfg = config.dr460nixed.development;
in
{
  config = lib.mkIf cfg.docker {
    boot.enableContainers = false;

    virtualisation = {
      containers.enable = true;
      docker = {
        enable = true;
        autoPrune.enable = true;
      };
    };
  };
}
