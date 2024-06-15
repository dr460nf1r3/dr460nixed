{
  description = "Dr460nixed NixOS flake ❄️";

  nixConfig = {
    extra-substituters = [
      "https://cache.garnix.io"
      "https://devenv.cachix.org"
    ];
    extra-trusted-public-keys = [
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
    ];
  };

  inputs = {
    # Chaotic Nyx!
    chaotic-nyx = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.home-manager.follows = "home-manager";
    };

    # Devenv to set up a development environment
    devenv = {
      url = "github:cachix/devenv";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks.follows = "pre-commit-hooks";
    };

    # Disko for Nix-managed partition management
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Required by some other flakes
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Garuda Linux flake - most of my system settings are here
    garuda-nix = {
      # url = "/home/nico/Documents/misc/garuda-nix-subsystem";
      url = "gitlab:garuda-linux/garuda-nix-subsystem/main";
      inputs.chaotic-nyx.follows = "chaotic-nyx";
      inputs.flake-parts.follows = "flake-parts";
      inputs.home-manager.follows = "home-manager";
      inputs.nix-index-database.follows = "nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks.follows = "pre-commit-hooks";
    };

    # Gitignore common input
    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home-manager for managing my home directory
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Ad and malware blocking hosts file
    hosts = {
      url = "github:StevenBlack/hosts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Reset rootfs every reboot
    impermanence.url = "github:nix-community/impermanence";

    # My SSH keys
    keys_nico = {
      url = "https://github.com/dr460nf1r3.keys";
      flake = false;
    };

    # Lanzaboote for secure boot support
    lanzaboote = {
      url = "github:nix-community/lanzaboote/master";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks-nix.follows = "pre-commit-hooks";
    };

    # Nix gaming-related packages and modules
    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Have a local index of nixpkgs for fast launching of apps
    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Declarative Minecraft server management
    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.flake-compat.follows = "chaotic-nyx/flake-compat";
      inputs.flake-utils.follows = "chaotic-nyx/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Feature-rich and convenient fork of the Nix package manager
    nix-super = {
      url = "github:privatevoid-net/nix-super";
      inputs.flake-compat.follows = "chaotic-nyx/flake-compat";
      inputs.flake-parts.follows = "flake-parts";
      # inputs.nixpkgs.follows = "nixpkgs"; # Broken as of 240518, needs own instance
      inputs.pre-commit-hooks.follows = "pre-commit-hooks";
    };

    # NixOS generators to build system images
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # NixOS hardware database
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # NixOS WSL
    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.flake-compat.follows = "chaotic-nyx/flake-compat";
      inputs.flake-utils.follows = "chaotic-nyx/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # The source of all truth!
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Easy linting of the flake and all kind of other stuff
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.flake-compat.follows = "chaotic-nyx/flake-compat";
      inputs.gitignore.follows = "gitignore";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };

    # Spicetify
    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.flake-utils.follows = "chaotic-nyx/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    devenv,
    flake-parts,
    pre-commit-hooks,
    ...
  } @ inp: let
    inputs = inp;
    perSystem = {
      lib,
      pkgs,
      ...
    }: {
      devenv.shells.default = {
        imports = [
          ./devenv/pre-commit.nix
          ./devenv/packages.nix
        ];
        cachix = {
          enable = true;
          pull = [
            "chaotic-nyx"
            "dr460nf1r3"
            "pre-commit-hooks"
          ];
        };
        # https://github.com/cachix/devenv/issues/528#issuecomment-1556108767
        containers = lib.mkForce {};
        difftastic.enable = true;
        enterShell = ''
          echo "Welcome to Dr460nixed's ❄️ devenv!"
        '';
        languages = {
          nix = {
            enable = true;
            lsp.package = pkgs.nixd;
          };
          shell.enable = true;
        };
        name = "Dr460nixed";
      };

      # By default, alejandra is WAY to verbose
      formatter = pkgs.writeShellScriptBin "alejandra" ''
        exec ${pkgs.alejandra}/bin/alejandra --quiet "$@"
      '';
    };
  in
    flake-parts.lib.mkFlake {inherit inputs;} {
      # Imports flake-modules
      imports = [
        ./nixos/flake-module.nix
        ./packages/flake-module.nix
        inputs.devenv.flakeModule
        inputs.pre-commit-hooks.flakeModule
      ];

      # The systems currently available
      systems = ["x86_64-linux" "aarch64-linux"];

      # This applies to all systems
      inherit perSystem;
    };
}
