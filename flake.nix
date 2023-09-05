{
  description = "Dr460nixed NixOS flake ❄️";

  nixConfig.extra-substituters = [ "https://dr460nf1r3.cachix.org" ];
  nixConfig.extra-trusted-public-keys = [ "dr460nf1r3.cachix.org-1:eLI/ymdDmYKBwwSNuA0l6zvfDZuZfh0OECGKzuv8xvU=" ];

  inputs = {
    # Chaotic Nyx!
    chaotic-nyx.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # Devshell to set up a development environment
    devshell.url = "github:numtide/devshell";

    # Disko for Nix-managed partition management
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # Required by some other flakes
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    # Required by pre-commit-hooks
    flake-utils.url = "github:numtide/flake-utils";

    # Garuda Linux flake - most of my system settings are here
    garuda-nix.url = "gitlab:garuda-linux/garuda-nix-subsystem/main";
    garuda-nix.inputs.chaotic.follows = "chaotic-nyx";
    garuda-nix.inputs.garuda-nixpkgs.follows = "nixpkgs";

    # Reset rootfs every reboot
    impermanence.url = "github:nix-community/impermanence";

    # My SSH keys
    keys_nico.url = "https://github.com/dr460nf1r3.keys";
    keys_nico.flake = false;

    # Lanzaboote for secure boot support
    lanzaboote.url = "github:nix-community/lanzaboote/master";
    lanzaboote.inputs.flake-parts.follows = "flake-parts";

    # Nixd language server
    nixd.url = "github:nix-community/nixd";
    nixd.inputs.flake-parts.follows = "flake-parts";
    nixd.inputs.nixpkgs.follows = "nixpkgs";

    # Have a local index of nixpkgs for fast launching of apps
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # NixOS generators to build system images
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    # NixOS hardware database
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # NixOS WSL
    nixos-wsl.url = "github:nix-community/nixos-wsl";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    # The source of all truth!
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Easy linting of the flake and all kind of other stuff
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";

    # Secrets management
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    # Spicetify
    spicetify-nix.url = "github:the-argus/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    # The Chaotic toolbox
    src-chaotic-toolbox.url = "github:chaotic-aur/toolbox";
    src-chaotic-toolbox.flake = false;
    src-repoctl.url = "github:cassava/repoctl";
    src-repoctl.flake = false;

    # Treefmt for advanced linting / formatting
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { devshell
    , flake-parts
    , nixpkgs
    , ...
    } @ inputs:
    flake-parts.lib.mkFlake { inherit inputs; }
      {
        imports = [
          ./devshell/flake-module.nix
          ./nixos/flake-module.nix
          inputs.devshell.flakeModule
          inputs.pre-commit-hooks.flakeModule
        ];

        systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];

        perSystem = { pkgs, system, ... }: {
          # Defines a formatter for "nix fmt"
          formatter = pkgs.nixpkgs-fmt;

          _module.args.pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        };
      };
}
   
