{
  description = "Dr460nixed NixOS flake ❄️";

  inputs = {
    # We roll unstable, as usual
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Chaotic Nyx!
    chaotic-nyx.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # For accessing deploy-rs' utility Nix functions
    deploy-rs.url = "github:serokell/deploy-rs";

    # Garuda Linux flake - most of my system settings are here
    garuda = {
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
      url = "github:nix-community/lanzaboote/v0.3.0";
    };

    # Nixd language server
    nixd.url = "github:nix-community/nixd";

    # Secrets management
    sops-nix.url = "github:Mic92/sops-nix";

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

    # Automated system themes
    stylix.url = "github:danth/stylix";
  };

  outputs =
    { deploy-rs
    , garuda
    , impermanence
    , lanzaboote
    , nixd
    , nixpkgs
    , self
    , sops-nix
    , spicetify-nix
    , ...
    } @ inputs:
    let
      nixos = garuda.nixpkgs;
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
        lanzaboote.nixosModules.lanzaboote
        sops-nix.nixosModules.sops
        spicetify-nix.nixosModule
        {
          nixpkgs.overlays = [ nixd.overlays.default ];
        }
      ];
      pkgs = import garuda.nixpkgs { inherit system; };
      sshUser = "deploy";
      user = "root";
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
          deploy-rs
          git
          gnupg
          nix
          nixos-generators
          nixpkgs-fmt
          sops
          statix
        ];
      };

      # Defines a formatter for "nix fmt"
      formatter.${system} = garuda.nixpkgs.legacyPackages.${system}.nixpkgs-fmt;

      # All the system configurations
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
          ++ [
          ./hosts/dragons-ryzen/dragons-ryzen.nix
          impermanence.nixosModules.impermanence
        ];
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
          ++ [ ./hosts/live-usb/live-usb.nix ];
        inherit specialArgs;
      };
      # To-do for installations
      nixosConfigurations."rpiImage" = garuda.lib.garudaSystem {
        inherit system;
        modules = defaultModules
          ++ [
          ./hosts/rpi-dragon/rpi-dragon.nix
          "${nixos}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        ];
        inherit specialArgs;
      };

      # Deployment configurations for deploy-rs
      deploy.nodes = {
        "tv-nixos" = {
          hostname = "100.120.171.12";
          inherit sshUser;
          inherit user;
          profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."tv-nixos";
        };
        "dragons-ryzen" = {
          hostname = "127.0.0.1";
          inherit sshUser;
          inherit user;
          profiles.system.path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations."dragons-ryzen";
        };
        "oracle-dragon" = {
          hostname = "100.86.102.115";
          inherit sshUser;
          inherit user;
          profiles.system.path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations."oracle-dragon";
          remoteBuild = true;
        };
        "rpi-dragon" = {
          hostname = "100.85.210.126";
          inherit sshUser;
          inherit user;
          profiles.system.path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations."rpi-dragon";
          remoteBuild = true;
        };
      };
    };
}
