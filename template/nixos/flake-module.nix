{inputs, ...}: {
  flake = let
    # Default modules to use in all systems
    defaultModules = [
      ./modules
      inputs.disko.nixosModules.disko
      inputs.lanzaboote.nixosModules.lanzaboote
    ];

    # Our images should be cleaner, so we use a different set of modules
    imageModules = [
      ./modules/desktops.nix
      ./modules/locales.nix
      inputs.nixos-generators.nixosModules.all-formats
      "${toString inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
    ];

    specialArgs = {inherit inputs;};
  in {
    # All the system configurations
    nixosConfigurations = {
      # The first device to set up
      example-hostname = inputs.garuda-nix.lib.garudaSystem {
        system = "x86_64-linux";
        modules =
          defaultModules
          ++ [
            ./example-hostname/example-hostname.nix
            ./modules/disko/example-disko.nix
            {
              _module.args.disks = ["example-disk"];
            }
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
    };
  };
}
