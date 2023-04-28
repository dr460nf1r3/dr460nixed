{ config
, lib
, pkgs
, ...
}:
with lib;
let
  cfg = config.dr460nixed.desktops;
in
{
  options.dr460nixed.desktops = {
    enable = mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Whether to enable basic dr460nized desktop theming.
        '';
      };
  };

  config = mkIf cfg.enable {
    services.xserver = {
      desktopManager.plasma5.enable = true;
      displayManager = {
        sddm = {
          autoNumlock = true;
          enable = true;
          settings = {
            General = { Font = "Fira Sans"; };
            # Autologin = { User = "nico"; Session = "plasma"; };
          };
          theme = "Sweet";
        };
      };
      enable = true;
      excludePackages = [ pkgs.xterm ];
    };
  };
}
