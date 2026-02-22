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
  config = {
    home-manager.extraSpecialArgs = {
      inherit inputs self;
      inherit (inputs.self) drLib;
    };
    garuda.home-manager.modules = lib.mkMerge [
      [ ../../home-manager/common.nix ]
      (lib.mkIf cfg.desktops.enable [ ../../home-manager/desktops.nix ])
      (lib.mkIf cfg.development.enable [ ../../home-manager/development.nix ])
    ];
  };
}
