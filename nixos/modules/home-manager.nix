{
  config,
  lib,
  ...
}: let
  cfg = config.dr460nixed;
in {
  config = {
    garuda.home-manager.modules = lib.mkMerge [
      [../../home-manager/common.nix]
      (lib.mkIf cfg.desktops.enable [../../home-manager/desktops.nix])
      (lib.mkIf cfg.development.enable [../../home-manager/development.nix])
    ];
  };
}
