{
  config,
  lib,
  ...
}:
let
  cfg = config.dr460nixed.desktops;
in
{
  config = lib.mkIf cfg.kde {
    services.desktopManager.plasma6.enable = true;
    services.displayManager.plasma-login-manager.enable = true;

    environment.variables = {
      QML_DISABLE_DISK_CACHE = "1";
    };
  };
}
