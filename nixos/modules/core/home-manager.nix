{
  config,
  lib,
  inputs,
  self,
  ...
}:
let
  cfg = config.dr460nixed;
in
{
  options.dr460nixed.home-manager = with lib; {
    modules = mkOption {
      type = types.listOf types.str;
      default = [ "common" ];
      description = mdDoc ''
        A list of home-manager module names from the flake to enable for the users.
      '';
    };
  };

  config = {
    home-manager.extraSpecialArgs = {
      inherit inputs self;
      inherit (inputs.self) dragonLib;
    };
    garuda.home-manager.modules = [
      self.homeModules.default
      (_: {
        dr460nixed.hm = {
          common.enable = true;
          development.enable = cfg.development.enable;
          kde.enable = cfg.desktops.enable;
          misc.enable = true;
          theme-launchers.enable = cfg.desktops.enable;
        };
      })
    ];
  };
}
