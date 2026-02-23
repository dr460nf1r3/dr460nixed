{
  inputs,
  self,
  dragonLib,
  ...
}:
{
  flake =
    let
      # Default modules to use in all systems
      defaultModules = [
        ../nixos/modules
        ../nixos/modules/garuda-compat.nix
        {
          _module.args = {
            inherit inputs self dragonLib;
          };
        }
        inputs.disko.nixosModules.disko
        inputs.home-manager.nixosModules.home-manager
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.lix-module.nixosModules.default
        inputs.sops-nix.nixosModules.sops
        inputs.spicetify-nix.nixosModules.default
        inputs.ucodenix.nixosModules.ucodenix
      ];

      # Our images should be cleaner, so we use a different set of modules
      imageModules = [
        ../overlays/default.nix
        {
          _module.args = {
            inherit inputs self dragonLib;
          };
        }
        ../nixos/modules/common.nix
        ../nixos/modules/desktops.nix
        ../nixos/modules/deterministic-ids.nix
        ../nixos/modules/development.nix
        ../nixos/modules/garuda-compat.nix
        ../nixos/modules/home-manager.nix
        ../nixos/modules/locales.nix
        ../nixos/modules/misc.nix
        ../nixos/modules/nix.nix
        ../nixos/modules/users.nix
        ../users/nico/nixos.nix
        inputs.home-manager.nixosModules.home-manager
        inputs.lix-module.nixosModules.default
        inputs.sops-nix.nixosModules.sops
        inputs.nixos-generators.nixosModules.all-formats
        inputs.spicetify-nix.nixosModules.default
        "${toString inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
      ];

      specialArgs = {
        inherit
          inputs
          self
          dragonLib
          ;
        keys.nico = inputs.keys_nico;
      };
    in
    {
      # All the system configurations
      nixosConfigurations = {
        cup-dragon = dragonLib.patchedGarudaSystem {
          system = "x86_64-linux";
          modules = defaultModules ++ [ ./cup-dragon/cup-dragon.nix ];
          inherit specialArgs;
        };

        dev-container = dragonLib.patchedNixosSystem {
          system = "x86_64-linux";
          modules = [
            "${inputs.nixpkgs}/nixos/modules/virtualisation/lxc-container.nix"
            ../nixos/modules/dev-container/dev-container.nix
          ];
          inherit specialArgs;
        };

        # My main device (Lenovo Slim 7)
        dragons-ryzen = dragonLib.patchedGarudaSystem {
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
        dragons-strix = dragonLib.patchedGarudaSystem {
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
        dr460nixed-base = dragonLib.patchedGarudaSystem {
          system = "x86_64-linux";
          modules = imageModules ++ [ ./images/base.nix ];
          inherit specialArgs;
        };

        # Dr460nized desktop image for nixos-generators
        dr460nixed-desktop = dragonLib.patchedGarudaSystem {
          system = "x86_64-linux";
          modules = imageModules ++ [ ./images/iso.nix ];
          inherit specialArgs;
        };

        # For WSL, mostly used at work only
        nixos-wsl = dragonLib.patchedGarudaSystem {
          system = "x86_64-linux";
          modules = defaultModules ++ [
            ./nixos-wsl/nixos-wsl.nix
            inputs.nixos-wsl.nixosModules.wsl
          ];
          inherit specialArgs;
        };
      };
    };
}
