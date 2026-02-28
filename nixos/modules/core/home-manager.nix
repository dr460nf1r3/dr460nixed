{
  config,
  lib,
  inputs,
  self,
  ...
}:
let
  cfg = config.dr460nixed;
  hmUsers = lib.filterAttrs (_: u: u.homeManager.enable or false) cfg.users;
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
      dr460nixedUserConfig = lib.mapAttrs (_: u: u.homeManager or { }) cfg.users;
    };

    home-manager.users = lib.mapAttrs (name: _userCfg: {
      imports = [
        self.homeModules.default
        (self.homeModules.${name} or { })
      ];
    }) hmUsers;

    garuda.home-manager.modules = [
      self.homeModules.default
      (_: {
        dr460nixed.hm = {
          common.enable = lib.mkDefault true;
          core.enable = lib.mkDefault true;
          development.enable = lib.mkDefault cfg.development.enable;
          desktop = {
            enable = lib.mkDefault cfg.desktops.enable;
            jamesdsp = lib.mkDefault cfg.desktops.enable;
            launchers = lib.mkDefault cfg.desktops.enable;
          };
          sync = {
            enable = lib.mkDefault cfg.syncthing.enable;
            syncthing = lib.mkDefault cfg.syncthing.enable;
          };
        };
      })
    ];
  };
}
