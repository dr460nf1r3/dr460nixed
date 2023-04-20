{
  description = "Dr460nixed NixOS flake ❄️";

  inputs = {
    # We roll unstable, as usual
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Chaotic Nyx!
    chaotic-nyx.url = "github:chaotic-cx/nyx/appmenu-gtk3-module";

    # Home configuration management
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Reset rootfs every reboot vis ZFS snapshots
    impermanence.url = "github:nix-community/impermanence";

    # My SSH keys
    keys_nico = {
      url = "https://github.com/dr460nf1r3.keys";
      flake = false;
    };

    # Secure boot support
    lanzaboote.url = "github:nix-community/lanzaboote";

    # Prismlauncher
    nix-minecraft = {
      url = "github:misterio77/nix-minecraft";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nix user repository
    nur.url = "github:nix-community/NUR";

    # Secrets management
    sops-nix.url = "github:Mic92/sops-nix";

    # The Chaotic toolbox
    src-chaotic-toolbox = {
      url = "github:chaotic-aur/toolbox";
      flake = false;
    };
    src-repoctl = {
      url = "github:cassava/repoctl";
      flake = false;
    };

    # Automated system themes
    stylix.url = "github:danth/stylix";
  };

  outputs =
    { chaotic-nyx
    , home-manager
    , impermanence
    , lanzaboote
    , nixpkgs
    , nur
    , sops-nix
    , stylix
    , ...
    } @ inputs:
    let
      nixos = nixpkgs;
      system = "x86_64-linux";
      specialArgs = {
        sources = {
          chaotic-toolbox = inputs.src-chaotic-toolbox;
          inherit (inputs) mesa-git-src;
          inherit (inputs) nixpkgs;
          repoctl = inputs.src-repoctl;
        };
        keys = { nico = inputs.keys_nico; };
      };
      overlays = _: {
        nixpkgs.overlays = [
          (_final: prev: {
            unstable = nixpkgs.legacyPackages.${prev.system};
          })
          nur.overlay
        ];
      };
      defaultModules = [
        ./modules/default.nix
        chaotic-nyx.nixosModules.default
        home-manager.nixosModules.home-manager
        nur.nixosModules.nur
        overlays
        sops-nix.nixosModules.sops
        stylix.nixosModules.stylix
      ];
      pkgs = import nixpkgs {
        inherit system;
        config = {
          tarball-ttl = 0;
        };
      };
    in
    {
      # The default checks to run on Nix files
      checks.${system} = import ./lib/checks { inherit pkgs; };

      # The devshell exposed by .envrc
      devShells.${system}.default = pkgs.mkShell {
        name = "dr460nixed";
        packages = with pkgs; [
          age
          colmena
          deadnix
          git
          gnupg
          nix
          nixpkgs-fmt
          sops
          statix
        ];
      };

      # Defines a formatter for "nix fmt"
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;

      # Colmena profiles for easy deployment
      colmena = {
        meta = {
          nixpkgs = import nixpkgs {
            system = "${system}";
            overlays = [ ];
          };
          inherit specialArgs;
        };
        defaults = {
          imports = defaultModules;
          deployment = {
            targetUser = "deploy";
          };
        };
        # My main device (Lenovo Slim 7)
        slim-lair = {
          deployment = {
            allowLocalDeployment = true;
            tags = [ "laptops" "main" ];
          };
          imports = [
            ./hosts/slim-lair/slim-lair.nix
            impermanence.nixosModules.impermanence
            lanzaboote.nixosModules.lanzaboote
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
        modules =
          defaultModules
          ++ [
            ./hosts/tv-nixos/tv-nixos.nix
          ];
        inherit specialArgs;
      };
      # My main device (Lenovo Slim 7)
      nixosConfigurations."slim-lair" = nixos.lib.nixosSystem {
        inherit system;
        modules =
          defaultModules
          ++ [
            ./hosts/slim-lair/slim-lair.nix
            impermanence.nixosModules.impermanence
            lanzaboote.nixosModules.lanzaboote
          ];
        inherit specialArgs;
      };
      # Free Tier Oracle aarch64 VM
      nixosConfigurations."oracle-dragon" = nixos.lib.nixosSystem {
        system = "aarch64-linux";
        modules =
          defaultModules
          ++ [
            ./hosts/oracle-dragon/oracle-dragon.nix
          ];
        inherit specialArgs;
      };
      # My Raspberry Pi 4B
      nixosConfigurations."rpi-dragon" = nixos.lib.nixosSystem {
        system = "aarch64-linux";
        modules =
          defaultModules
          ++ [
            ./hosts/rpi-dragon/rpi-dragon.nix
          ];
        inherit specialArgs;
      };
      # For WSL, mostly used at work only
      nixosConfigurations."nixos-wsl" = nixos.lib.nixosSystem {
        inherit system;
        modules =
          defaultModules
          ++ [
            ./hosts/nixos-wsl/nixos-wsl.nix
          ];
        inherit specialArgs;
      };
      # To-do for installations
      nixosConfigurations."live-usb" = nixos.lib.nixosSystem {
        inherit system;
        modules =
          defaultModules
          ++ [
            ./hosts/live-usb/live-usb.nix
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
          ];
        inherit specialArgs;
      };
    };
}
