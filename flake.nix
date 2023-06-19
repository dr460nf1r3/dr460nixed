{
  description = "Dr460nixed NixOS flake ❄️";

  inputs = {
    # We roll unstable, as usual
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Chaotic Nyx!
    chaotic-nyx.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # Garuda Linux subsystem - soon to have more options from the system
    garuda = {
      inputs.chaotic.follows = "chaotic-nyx";
      inputs.garuda-nixpkgs.follows = "chaotic-nyx/nixpkgs";
      url = "gitlab:garuda-linux/garuda-nix-subsystem/main";
    };

    # Home configuration management
    home-manager = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/home-manager/master";
    };

    # My SSH keys
    keys_nico = {
      flake = false;
      url = "https://github.com/dr460nf1r3.keys";
    };

    # Prismlauncher
    nix-minecraft = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:misterio77/nix-minecraft";
    };

    # Nixd language server
    nixd.url = "github:nix-community/nixd";

    # Secrets management
    sops-nix.url = "github:Mic92/sops-nix";

    # The Chaotic toolbox
    src-chaotic-toolbox = {
      flake = false;
      url = "github:chaotic-aur/toolbox";
    };
    src-repoctl = {
      flake = false;
      url = "github:cassava/repoctl";
    };

    # Automated system themes
    stylix.url = "github:danth/stylix";
  };

  outputs =
    { home-manager
    , nixd
    , garuda
    , sops-nix
    , stylix
    , ...
    } @ inputs:
    let
      nixos = garuda;
      system = "x86_64-linux";
      specialArgs = {
        sources = {
          chaotic-toolbox = inputs.src-chaotic-toolbox;
          repoctl = inputs.src-repoctl;
        };
        keys = { nico = inputs.keys_nico; };
      };
      defaultModules = [
        ./modules/default.nix
        home-manager.nixosModules.home-manager
        sops-nix.nixosModules.sops
        stylix.nixosModules.stylix
        {
          nixpkgs.overlays = [ nixd.overlays.default ];
        }
      ];
      pkgs = import garuda.nixpkgs {
        inherit system;
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
      formatter.${system} = nixos.legacyPackages.${system}.nixpkgs-fmt;

      # Colmena profiles for easy deployment
      colmena = {
        meta = {
          nixpkgs = import garuda.nixpkgs {
            overlays = [ nixd.overlays.default ];
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
        dragons-ryzen = {
          deployment = {
            allowLocalDeployment = true;
            tags = [ "laptops" "main" ];
            targetHost = "100.99.129.81";
          };
          imports = [ ./hosts/dragons-ryzen/dragons-ryzen.nix ];
        };
        # My old laptop serving as TV
        tv-nixos = {
          deployment = {
            tags = [ "servers" "tv" ];
            targetHost = "100.120.171.12";
          };
          imports = [ ./hosts/tv-nixos/tv-nixos.nix ];
        };
        # Free Tier Oracle aarch64 VM
        oracle-dragon = {
          deployment = {
            buildOnTarget = true;
            tags = [ "oracle" "servers" ];
            targetHost = "100.86.102.115";
          };
          imports = [ ./hosts/oracle-dragon/oracle-dragon.nix ];
          nixpkgs.system = "aarch64-linux";
        };
        # My Raspberry Pi 4B
        rpi-dragon = {
          deployment = {
            buildOnTarget = true;
            tags = [ "rpi" "servers" ];
            targetHost = "100.85.210.126";
          };
          imports = [ ./hosts/rpi-dragon/rpi-dragon.nix ];
          nixpkgs.system = "aarch64-linux";
        };
      };

      # All the system configurations (flake)
      # My old laptop serving as TV
      nixosConfigurations."tv-nixos" = garuda.lib.garudaSystem {
        inherit system;
        modules = defaultModules
          ++ [ ./hosts/tv-nixos/tv-nixos.nix ];
        inherit specialArgs;
      };
      # My main device (Lenovo Slim 7)
      nixosConfigurations."dragons-ryzen" = garuda.lib.garudaSystem {
        inherit system;
        modules = defaultModules
          ++ [ ./hosts/dragons-ryzen/dragons-ryzen.nix ];
        inherit specialArgs;
      };
      # Free Tier Oracle aarch64 VM
      nixosConfigurations."oracle-dragon" = garuda.lib.garudaSystem {
        system = "aarch64-linux";
        modules = defaultModules
          ++ [ ./hosts/oracle-dragon/oracle-dragon.nix ];
        inherit specialArgs;
      };
      # My Raspberry Pi 4B
      nixosConfigurations."rpi-dragon" = garuda.lib.garudaSystem {
        system = "aarch64-linux";
        modules = defaultModules
          ++ [ ./hosts/rpi-dragon/rpi-dragon.nix ];
        inherit specialArgs;
      };
      # For WSL, mostly used at work only
      nixosConfigurations."nixos-wsl" = garuda.lib.garudaSystem {
        inherit system;
        modules = defaultModules
          ++ [ ./hosts/nixos-wsl/nixos-wsl.nix ];
        inherit specialArgs;
      };
      # To-do for installations
      nixosConfigurations."live-usb" = garuda.lib.garudaSystem {
        inherit system;
        modules = defaultModules
          ++ [
          ./hosts/live-usb/live-usb.nix
          "${garuda}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ];
        inherit specialArgs;
      };
    };
}
