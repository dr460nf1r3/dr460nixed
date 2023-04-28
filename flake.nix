{
  description = "Dr460nixed NixOS flake ❄️";

  inputs = {
    # We roll unstable, as usual
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Chaotic Nyx!
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # My SSH keys
    keys_nico = {
      flake = false;
      url = "https://github.com/dr460nf1r3.keys";
    };
  };

  outputs =
    { chaotic
    , nixpkgs
    , ...
    } @ inputs:
    let
      nixos = nixpkgs;
      system = "x86_64-linux";
      specialArgs = {
        sources = {
          chaotic-toolbox = inputs.src-chaotic-toolbox;
          repoctl = inputs.src-repoctl;
        };
        keys = { nico = inputs.keys_nico; };
      };
      #overlays = _: { nixpkgs.overlays = [ nur.overlay ]; };
      defaultModules = [
        #./modules/default.nix
        chaotic.nixosModules.default
        #nur.nixosModules.nur
        #overlays
        #sops-nix.nixosModules.sops
        #stylix.nixosModules.stylix
      ];

    in
    {
      # Colmena profiles for easy deployment
      colmena = {
        meta = {
          nixpkgs = import nixpkgs {
            overlays = [ ];
            system = "${system}";
          };
          inherit specialArgs;
        };
        defaults = {
          deployment = {
            targetUser = "deploy";
          };
          imports = defaultModules;
        };
        # My main device (Lenovo Slim 7)
        slim-lair = {
          deployment = {
            allowLocalDeployment = true;
            tags = [ "laptops" "main" ];
          };
          imports = [
            ./hosts/slim-lair/slim-lair.nix
          ];
        };
        # My old laptop serving as TV
        tv-nixos = {
          deployment = {
            tags = [ "servers" "tv" ];
          };
          imports = [ ./hosts/tv-nixos/tv-nixos.nix ];
        };
        # Free Tier Oracle aarch64 VM
        oracle-dragon = {
          deployment = {
            buildOnTarget = true;
            tags = [ "oracle" "servers" ];
          };
          imports = [ ./hosts/oracle-dragon/oracle-dragon.nix ];
          nixpkgs.system = "aarch64-linux";
        };
        # My Raspberry Pi 4B
        rpi-dragon = {
          deployment = {
            buildOnTarget = true;
            tags = [ "rpi" "servers" ];
          };
          imports = [ ./hosts/rpi-dragon/rpi-dragon.nix ];
          nixpkgs.system = "aarch64-linux";
        };
      };

      # All the system configurations (flake)
      # My old laptop serving as TV
      nixosConfigurations."tv-nixos" = nixos.lib.nixosSystem {
        inherit system;
        modules = defaultModules
          ++ [ ./hosts/tv-nixos/tv-nixos.nix ];
        inherit specialArgs;
      };
      # My main device (Lenovo Slim 7)
      nixosConfigurations."slim-lair" = nixos.lib.nixosSystem {
        inherit system;
        modules = defaultModules
          ++ [
          ./hosts/slim-lair/slim-lair.nix
          #impermanence.nixosModules.impermanence
        ];
        inherit specialArgs;
      };
      # Free Tier Oracle aarch64 VM
      nixosConfigurations."oracle-dragon" = nixos.lib.nixosSystem {
        system = "aarch64-linux";
        modules = defaultModules
          ++ [ ./hosts/oracle-dragon/oracle-dragon.nix ];
        inherit specialArgs;
      };
      # My Raspberry Pi 4B
      nixosConfigurations."rpi-dragon" = nixos.lib.nixosSystem {
        system = "aarch64-linux";
        modules = defaultModules
          ++ [ ./hosts/rpi-dragon/rpi-dragon.nix ];
        inherit specialArgs;
      };
      # For WSL, mostly used at work only
      nixosConfigurations."nixos-wsl" = nixos.lib.nixosSystem {
        inherit system;
        modules = defaultModules
          ++ [ ./hosts/nixos-wsl/nixos-wsl.nix ];
        inherit specialArgs;
      };
      # To-do for installations
      nixosConfigurations."live-usb" = nixos.lib.nixosSystem {
        inherit system;
        modules = defaultModules
          ++ [
          ./hosts/live-usb/live-usb.nix
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ];
        inherit specialArgs;
      };
    };
}
