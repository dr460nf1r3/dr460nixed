{
  inputs,
  self,
  drLib,
  ...
}:
{
  flake =
    let
      # Default modules to use in all systems
      defaultModules = [
        ./modules
        {
          _module.args = {
            inherit inputs self drLib;
          };
        }
        inputs.disko.nixosModules.disko
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.lix-module.nixosModules.default
        inputs.sops-nix.nixosModules.sops
        inputs.spicetify-nix.nixosModules.default
        inputs.ucodenix.nixosModules.ucodenix
      ];

      # Our images should be cleaner, so we use a different set of modules
      imageModules = [
        ../overlays
        {
          _module.args = {
            inherit inputs self drLib;
          };
        }
        ./modules/desktops.nix
        ./modules/locales.nix
        ./modules/misc.nix
        inputs.lix-module.nixosModules.default
        inputs.nixos-generators.nixosModules.all-formats
        inputs.spicetify-nix.nixosModules.default
        "${toString inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
      ];

      specialArgs = {
        inherit
          inputs
          self
          drLib
          ;
        keys.nico = inputs.keys_nico;
      };
    in
    {
      # All the system configurations
      nixosConfigurations = {
        cup-dragon = drLib.patchedGarudaSystem {
          system = "x86_64-linux";
          modules = defaultModules ++ [ ./cup-dragon/cup-dragon.nix ];
          inherit specialArgs;
        };

        dev-container = drLib.patchedNixosSystem {
          system = "x86_64-linux";
          modules = [
            "${inputs.nixpkgs}/nixos/modules/virtualisation/lxc-container.nix"
            ./modules/dev-container/dev-container.nix
          ];
        };

        # My main device (Lenovo Slim 7)
        dragons-ryzen = drLib.patchedGarudaSystem {
          system = "x86_64-linux";
          modules = defaultModules ++ [
            ./dragons-ryzen/dragons-ryzen.nix
            inputs.impermanence.nixosModules.impermanence
            inputs.nixos-hardware.nixosModules.common-cpu-amd
            inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
            inputs.nixos-hardware.nixosModules.common-gpu-amd
          ];
          inherit specialArgs;
        };

        # My main device (Lenovo Slim 7)
        dragons-strix = drLib.patchedGarudaSystem {
          system = "x86_64-linux";
          modules = defaultModules ++ [
            ./dragons-strix/dragons-strix.nix
            inputs.impermanence.nixosModules.impermanence
            inputs.nixos-hardware.nixosModules.common-cpu-amd
            inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
            inputs.nixos-hardware.nixosModules.common-cpu-amd-zenpower
            inputs.nixos-hardware.nixosModules.common-pc-laptop
            inputs.nixos-hardware.nixosModules.common-pc-ssd
          ];
          inherit specialArgs;
        };

        # Dr460nixed base image for nixos-generators
        dr460nixed-base = drLib.patchedGarudaSystem {
          system = "x86_64-linux";
          modules = imageModules ++ [ ./images/base.nix ];
          inherit specialArgs;
        };

        # Dr460nized desktop image for nixos-generators
        dr460nixed-desktop = drLib.patchedGarudaSystem {
          system = "x86_64-linux";
          modules = imageModules ++ [ ./images/iso.nix ];
          inherit specialArgs;
        };

        # For WSL, mostly used at work only
        nixos-wsl = drLib.patchedGarudaSystem {
          system = "x86_64-linux";
          modules = defaultModules ++ [
            ./nixos-wsl/nixos-wsl.nix
            inputs.nixos-wsl.nixosModules.wsl
          ];
          inherit specialArgs;
        };
      };

      # Expose dr460nixed and other modules for use in other flakes
      nixosModules = {
        default = self.nixosModules.dr460nixed;
        dr460nixed = import ./modules;
      };

      # Expose home-manager modules
      homeModules = {
        common = import ../home-manager/common.nix;
        desktops = import ../home-manager/desktops.nix;
        development = import ../home-manager/development.nix;
        kde = import ../home-manager/kde.nix;
        misc = import ../home-manager/misc.nix;
        standalone = import ../home-manager/standalone.nix;
        theme-launchers = import ../home-manager/theme-launchers.nix;
        nico = import ../home-manager/nico/nico.nix;
      };

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
        extraSpecialArgs = { inherit inputs self drLib; };
        pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
        modules = [
          self.homeModules.nico
          self.homeModules.standalone
          inputs.catppuccin.homeModules.catppuccin
          inputs.spicetify-nix.homeManagerModules.default
        ];
      };
    };
}
