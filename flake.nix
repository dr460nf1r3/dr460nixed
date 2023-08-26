{
  description = "Dr460nixed NixOS flake ❄️";

  inputs = {
    # We roll unstable, as usual
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Chaotic Nyx!
    chaotic-nyx.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # Disko for Nix-managed partition management
    inputs = {
      disko.url = "github:nix-community/disko";
      disko.inputs.nixpkgs.follows = "nixpkgs";
    };

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
    , garuda-nix
    , impermanence
    , lanzaboote
    , nixd
    , nixpkgs
    , sops-nix
    , spicetify-nix
    , ...
    } @ inputs:
    let
      nixos = garuda-nix.nixpkgs;
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
      pkgs = import garuda-nix.nixpkgs { inherit system; };
    in
    {
      # The default checks to run on Nix files
      checks.${system} = import ./lib/checks { inherit pkgs; };

      # The devshell exposed by .envrc
      devShells.${system}.default = pkgs.mkShell {
        name = "dr460nixed";
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

      # Defines a formatter for "nix fmt"
      formatter.${system} = garuda-nix.nixpkgs.legacyPackages.${system}.nixpkgs-fmt;

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
          ++ [ ./hosts/nixos-wsl/nixos-wsl.nix ];
        inherit specialArgs;
      };
      # To-do for installations
      nixosConfigurations."live-usb" = garuda-nix.lib.garudaSystem {
        inherit system;
        modules = defaultModules
          ++ [ ./hosts/live-usb/live-usb.nix ];
        inherit specialArgs;
      };
      # To-do for installations
      nixosConfigurations."rpiImage" = garuda-nix.lib.garudaSystem {
        inherit system;
        modules = defaultModules
          ++ [
          ./hosts/rpi-dragon/rpi-dragon.nix
          "${nixos}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        ];
        inherit specialArgs;
      };
    };
}
