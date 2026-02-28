{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.dr460nixed.hm.core;
  corePkgs = import ../nixos/modules/apps/core-packages.nix { inherit pkgs lib; };
in
{
  options.dr460nixed.hm.core = {
    enable = lib.mkEnableOption "Core Home Manager configuration with essential packages";
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      EDITOR = "micro";
      MOZ_USE_XINPUT2 = "1";
      QT_STYLE_OVERRIDE = "kvantum";
      SDL_AUDIODRIVER = "pipewire";
      VISUAL = "zed";
    };

    # use the shared core package list stored under nixos/modules/apps;
    # referencing a location outside home-manager makes this suitable for
    # both NixOS and standalone use.
    home.packages = corePkgs;

  };
}
