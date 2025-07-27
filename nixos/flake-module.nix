{
  inputs,
  self,
  ...
}: {
  flake = let
    # Default modules to use in all systems
    defaultModules = [
      ./modules
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
      ./modules/desktops.nix
      ./modules/locales.nix
      ./modules/misc.nix
      inputs.lix-module.nixosModules.default
      inputs.nixos-generators.nixosModules.all-formats
      inputs.spicetify-nix.nixosModules.default
      "${toString inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
    ];

    specialArgs = {
      inherit inputs;
      keys.nico = inputs.keys_nico;
      self = {
        inherit (self) inputs;
        inherit (self) nixosModules;
        packages = self.packages.x86_64-linux;
      };
    };
  in {
    # All the system configurations
    nixosConfigurations = {
      cup-dragon = inputs.garuda-nix.lib.garudaSystem {
        system = "x86_64-linux";
        modules =
          defaultModules
          ++ [./cup-dragon/cup-dragon.nix];
        inherit specialArgs;
      };

      dev-container = inputs.nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          "${inputs.nixpkgs}/nixos/modules/virtualisation/lxc-container.nix"
          ./modules/dev-container/dev-container.nix
        ];
      };

      # My main device (Lenovo Slim 7)
      dragons-ryzen = inputs.garuda-nix.lib.garudaSystem {
        system = "x86_64-linux";
        modules =
          defaultModules
          ++ [
            ./dragons-ryzen/dragons-ryzen.nix
            inputs.impermanence.nixosModules.impermanence
            inputs.nixos-hardware.nixosModules.common-cpu-amd
            inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
            inputs.nixos-hardware.nixosModules.common-gpu-amd
          ];
        inherit specialArgs;
      };

      # Dr460nixed base image for nixos-generators
      dr460nixed-base = inputs.garuda-nix.lib.garudaSystem {
        system = "x86_64-linux";
        modules =
          imageModules ++ [./images/base.nix];
        inherit specialArgs;
      };

      # Dr460nized desktop image for nixos-generators
      dr460nixed-desktop = inputs.garuda-nix.lib.garudaSystem {
        system = "x86_64-linux";
        modules =
          imageModules ++ [./images/iso.nix];
        inherit specialArgs;
      };

      # For WSL, mostly used at work only
      nixos-wsl = inputs.garuda-nix.lib.garudaSystem {
        system = "x86_64-linux";
        modules =
          defaultModules
          ++ [
            ./nixos-wsl/nixos-wsl.nix
            inputs.nixos-wsl.nixosModules.wsl
          ];
        inherit specialArgs;
      };

      # Homeserver on Proxmox
      pve-dragon-1 = inputs.garuda-nix.lib.garudaSystem {
        system = "x86_64-linux";
        modules =
          defaultModules
          ++ [./pve-dragon-1/pve-dragon-1.nix];
        inherit specialArgs;
      };
    };

    # Expose dr460nixed and other modules for use in other flakes
    nixosModules = {
      default = self.nixosModules.dr460nixed;
      dr460nixed = import ./modules;
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
      extraSpecialArgs = {inherit inputs;};
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux;
      modules = [
        ../home-manager/nico/nico.nix
        ../home-manager/standalone.nix
        inputs.catppuccin.homeModules.catppuccin
        inputs.chaotic-nyx.homeManagerModules.default
        inputs.spicetify-nix.homeManagerModules.default
      ];
    };
  };
}
