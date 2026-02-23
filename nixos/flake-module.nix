{
  inputs,
  self,
  dragonLib,
  lib,
  ...
}:
{
  flake = {
    # Expose dr460nixed and other modules for use in other flakes
    nixosModules = {
      default = self.nixosModules.dr460nixed;
      dr460nixed = import ./modules;
    };

    # Expose home-manager modules
    homeModules =
      let
        hmDir = ../home-manager;
        hmFiles = builtins.readDir hmDir;
        hmNixFiles = lib.filterAttrs (n: v: v == "regular" && lib.hasSuffix ".nix" n) hmFiles;
        hmModules = lib.mapAttrs' (
          n: _: lib.nameValuePair (lib.removeSuffix ".nix" n) (import (hmDir + "/${n}"))
        ) hmNixFiles;

        # Also include modules from subdirectories if any (e.g. nico/nico.nix)
        nicoModules = {
          nico = import ../users/nico/nico.nix;
          email = import ../users/nico/email.nix;
          not-standalone = import ../users/nico/not-standalone.nix;
        };
      in
      hmModules // nicoModules;

    # The default template for this flake
    templates = {
      default = self.templates.dr460nixed;
      dr460nixed = {
        description = "A basic dr460nixed flake to build a custom flake from ❄️🐉";
        path = ../template;
      };
    };

    # Home configuration for my Garuda Linux
    homeConfigurations."nico" = inputs.home-manager.lib.homeManagerConfiguration {
      extraSpecialArgs = {
        inherit inputs self dragonLib;
      };
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        self.homeModules.nico
        self.homeModules.standalone
      ];
    };
  };
}
