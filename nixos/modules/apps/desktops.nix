{
  config,
  lib,
  ...
}:
let
  cfg = config.dr460nixed.desktops;
in
{
  imports = [
    ./kde.nix
    ./spicetify.nix
    ./desktop-apps.nix
  ];

  options.dr460nixed.desktops = with lib; {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc "Whether to enable basic dr460nized desktop theming.";
    };
    kde = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc "Enable KDE Plasma desktop";
    };
    spicetify = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc "Enable Spicetify (Spotify theming)";
    };
  };

  config = lib.mkIf cfg.enable {
    dr460nixed.desktops = {
      kde = true;
      spicetify = true;
    };
  };
}
