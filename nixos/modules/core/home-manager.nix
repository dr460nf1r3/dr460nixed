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
    dr460nixed.garuda.home-manager.modules =
      let
        moduleNames =
          cfg.home-manager.modules
          ++ lib.optional cfg.desktops.enable "desktops"
          ++ lib.optional cfg.development.enable "development";
      in
      map (name: self.homeModules.${name}) moduleNames;
  };
}
