{
  config,
  lib,
  ...
}:
let
  cfg = config.dr460nixed.development;
in
{
  config = lib.mkIf cfg.vms {
    virtualisation = {
      virtualbox.host = {
        addNetworkInterface = false;
        enable = true;
        enableExtensionPack = true;
        enableHardening = true;
      };
    };

    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  };
}
