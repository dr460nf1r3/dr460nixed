{
  config,
  lib,
  ...
}: let
  cfg = config.dr460nixed;
in {
  config = {
    garuda.home-manager.modules = lib.mkMerge [
      [../../home-manager/kde.nix]
      (lib.mkIf cfg.desktops.enable [../../home-manager/desktops.nix])
    ];
  };
}
