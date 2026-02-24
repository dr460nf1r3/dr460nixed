{
  config,
  lib,
  ...
}:
let
  cfg = config.dr460nixed.grub;
in
{
  config = lib.mkIf cfg.enable {
    boot.loader.grub = {
      device = cfg.device;
      enable = true;
      enableCryptodisk = cfg.enableCryptodisk;
      useOSProber = false;
    };
  };
}
