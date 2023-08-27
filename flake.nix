{
  description = "Dr460nixed NixOS flake ❄️";

  inputs = {
    # We roll unstable, as usual
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Chaotic Nyx!
    chaotic-nyx.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # Disko for Nix-managed partition management
    disko = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/disko";
    };

    # Required by pre-commit-hooks
    flake-utils.url = "github:numtide/flake-utils";

    # Garuda Linux flake - most of my system settings are here
    garuda-nix = {
      inputs.chaotic.follows = "chaotic-nyx";
      inputs.garuda-nixpkgs.follows = "nixpkgs";
      url = "gitlab:garuda-linux/garuda-nix-subsystem/main";
    };

    # Reset rootfs every reboot
    impermanence.url = "github:nix-community/impermanence";

    # My SSH keys
    keys_nico = {
      flake = false;
      url = "https://github.com/dr460nf1r3.keys";
    };

    # Lanzaboote for secure boot support
    lanzaboote = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/lanzaboote";
    };

    # Nixd language server
    nixd = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:nix-community/nixd";
    };

    # NixOS WSL
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Easy linting of the flake
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    # Secrets management
    sops-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      url = "github:Mic92/sops-nix";
    };

    # Spicetify
    spicetify-nix = {
      inputs.nixpkgs.follows = "nixpkgs";
      url = "github:the-argus/spicetify-nix";
    };

    # The Chaotic toolbox
    src-chaotic-toolbox = {
      flake = false;
      url = "github:chaotic-aur/toolbox";
    };
    src-repoctl = {
      flake = false;
      url = "github:cassava/repoctl";
    };
  };

  outputs =
    { disko
    , flake-utils
    , garuda-nix
    , impermanence
    , lanzaboote
    , nixd
    , nixpkgs
    , nixos-wsl
    , pre-commit-hooks
    , sops-nix
    , self
    , spicetify-nix
    , ...
    } @ inputs:
    let
      system = "x86_64-linux";
      specialArgs = {
        inherit spicetify-nix;
        keys.nico = inputs.keys_nico;
        sources = {
          chaotic-toolbox = inputs.src-chaotic-toolbox;
          repoctl = inputs.src-repoctl;
        };
      };
      defaultModules = [
        ./modules/default.nix
        disko.nixosModules.disko
        lanzaboote.nixosModules.lanzaboote
        sops-nix.nixosModules.sops
        spicetify-nix.nixosModule
        {
          nixpkgs.overlays = [ nixd.overlays.default ];
        }
      ];
      pkgs = import nixpkgs { inherit system; };
    in
    {
      # Defines a formatter for "nix fmt"
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;

      # All the system configurations
      # My old laptop serving as TV
      nixosConfigurations."tv-nixos" = garuda-nix.lib.garudaSystem {
        inherit system;
        modules = defaultModules
        ++ [ ./hosts/tv-nixos/tv-nixos.nix ];
        inherit specialArgs;
      };
      # My main device (Lenovo Slim 7)
      nixosConfigurations."dragons-ryzen" = garuda-nix.lib.garudaSystem {
        inherit system;
        modules = defaultModules
        ++ [
          ./hosts/dragons-ryzen/dragons-ryzen.nix
          impermanence.nixosModules.impermanence
        ];
        inherit specialArgs;
      };
      # Free Tier Oracle aarch64 VM
      nixosConfigurations."oracle-dragon" = garuda-nix.lib.garudaSystem {
        system = "aarch64-linux";
        modules = defaultModules
        ++ [ ./hosts/oracle-dragon/oracle-dragon.nix ];
        inherit specialArgs;
      };
      # My Raspberry Pi 4B
      nixosConfigurations."rpi-dragon" = garuda-nix.lib.garudaSystem {
        system = "aarch64-linux";
        modules = defaultModules
        ++ [ ./hosts/rpi-dragon/rpi-dragon.nix ];
        inherit specialArgs;
      };
      # For WSL, mostly used at work only
      nixosConfigurations."nixos-wsl" = garuda-nix.lib.garudaSystem {
        inherit system;
        modules = defaultModules
        ++ [
          ./hosts/nixos-wsl/nixos-wsl.nix
          nixos-wsl.nixosModules.wsl
        ];
        inherit specialArgs;
      };
      # To-do for installations
      nixosConfigurations."portable-dragon" = garuda-nix.lib.garudaSystem {
        inherit system;
        modules = defaultModules
        ++ [
          ./hosts/portable-dragon/portable-dragon.nix
          "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
        ];
        inherit specialArgs;
      };
      # To-do for installations
      nixosConfigurations."rpiImage" = garuda-nix.lib.garudaSystem {
        inherit system;
        modules = defaultModules
        ++ [
          ./hosts/rpi-dragon/rpi-dragon.nix
          "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        ];
        inherit specialArgs;
      };
    } //
    flake-utils.lib.eachDefaultSystem (system:
    {
      checks = {
        pre-commit-check = pre-commit-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            deadnix.enable = true;
            nixpkgs-fmt.enable = true;
            prettier.enable = true;
            shellcheck.enable = true;
          };
          settings = {
            deadnix = {
              edit = true;
              hidden = true;
            };
          };
        };
      };

      devShell = nixpkgs.legacyPackages.${system}.mkShell {
        name = "dr460nixed";
        inherit (self.checks.${system}.pre-commit-check) shellHook;
        packages = with pkgs; [
          age
          deadnix
          git
          gnupg
          nix
          nixos-generators
          nixpkgs-fmt
          rsync
          sops
          statix
        ];
      };
    });
}
