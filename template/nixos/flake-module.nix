{ inputs, ... }:
{
  flake =
    let
      # Default modules to use in all systems
      defaultModules = [
        ./modules
        inputs.disko.nixosModules.disko
        inputs.hosts.nixosModule
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.spicetify-nix.nixosModule
      ];

      # Our images should be cleaner, so we use a different set of modules
      imageModules = [
        ./modules/desktops.nix
        ./modules/locales.nix
        ./modules/misc.nix
        inputs.hosts.nixosModule
        inputs.nixos-generators.nixosModules.all-formats
        inputs.spicetify-nix.nixosModule
        "${toString inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
      ];

      specialArgs = { inherit inputs; };
    in
    {
      # All the system configurations
      nixosConfigurations = {
        # The first device to set up
        example-hostname = inputs.garuda-nix.lib.garudaSystem {
          system = "x86_64-linux";
          modules = defaultModules ++ [
            ./example-hostname/example-hostname.nix
            ./modules/disko/example-layout.nix
            {
              _module.args.disks = [ "example-disk" ];
            }
          ];
          inherit specialArgs;
        };

        # Dr460nixed base image for nixos-generators
        dr460nixed-base = inputs.garuda-nix.lib.garudaSystem {
          system = "x86_64-linux";
          modules = imageModules ++ [ ./modules/images/base.nix ];
          inherit specialArgs;
        };

        # Dr460nized desktop image for nixos-generators
        dr460nixed-desktop = inputs.garuda-nix.lib.garudaSystem {
          system = "x86_64-linux";
          modules = imageModules ++ [ ./modules/images/iso.nix ];
          inherit specialArgs;
        };
      };
    };
}
