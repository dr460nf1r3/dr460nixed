{
  config,
  lib,
  ...
}:
let
  cfg = config.dr460nixed.systemd-boot;
in
{
  config = lib.mkIf cfg.enable {
    boot.loader = {
      generationsDir.copyKernels = true;
      systemd-boot = {
        consoleMode = "max";
        editor = false;
        enable = true;
      };
    };
  };
}
