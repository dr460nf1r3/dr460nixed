{
  lib,
  config,
  ...
}:
let
  cfg = config.dr460nixed.hm.sync;
in
{
  options.dr460nixed.hm.sync = {
    enable = lib.mkEnableOption "File sync services configuration";
    syncthing = lib.mkEnableOption "Syncthing";
    nextcloud = lib.mkEnableOption "Nextcloud client";
  };

  config = lib.mkIf cfg.enable {
    services = {
      syncthing = lib.mkIf cfg.syncthing {
        enable = true;
      };
      nextcloud-client = lib.mkIf cfg.nextcloud {
        enable = true;
        startInBackground = true;
      };
    };
  };
}
