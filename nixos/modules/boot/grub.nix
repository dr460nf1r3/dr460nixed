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
      inherit (cfg) device enableCryptodisk;
      enable = true;
      useOSProber = false;
    };
  };
}
