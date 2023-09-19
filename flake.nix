{
  description = "Dr460nixed NixOS flake ❄️";

  nixConfig.extra-substituters = ["https://cache.garnix.io"];
  nixConfig.extra-trusted-public-keys = ["cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="];

  inputs = {
    # Chaotic Nyx!
    chaotic-nyx.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
    chaotic-nyx.inputs.home-manager.follows = "home-manager";

    # Devshell to set up a development environment
    devshell.url = "github:numtide/devshell";
    devshell.flake = false;

    # Disko for Nix-managed partition management
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    # Required by some other flakes
    flake-compat.url = "github:edolstra/flake-compat";
    flake-compat.flake = false;

    # Required by some other flakes
    flake-parts.url = "github:hercules-ci/flake-parts";
    flake-parts.inputs.nixpkgs-lib.follows = "nixpkgs";

    # Required by pre-commit-hooks
    flake-utils.url = "github:numtide/flake-utils";

    # Garuda Linux flake - most of my system settings are here
    # garuda-nix.url = "/home/nico/Documents/misc/garuda-nix-subsystem";
    garuda-nix.url = "gitlab:garuda-linux/garuda-nix-subsystem/main";
    garuda-nix.inputs.chaotic-nyx.follows = "chaotic-nyx";
    garuda-nix.inputs.devshell.follows = "devshell";
    garuda-nix.inputs.flake-parts.follows = "flake-parts";
    garuda-nix.inputs.flake-utils.follows = "flake-utils";
    garuda-nix.inputs.home-manager.follows = "home-manager";
    garuda-nix.inputs.nix-index-database.follows = "nix-index-database";
    garuda-nix.inputs.nixos-hardware.follows = "nixos-hardware";
    garuda-nix.inputs.nixpkgs.follows = "nixpkgs";
    garuda-nix.inputs.pre-commit-hooks.follows = "pre-commit-hooks";
    garuda-nix.inputs.spicetify-nix.follows = "spicetify-nix";

    # Gitignore common input
    gitignore.url = "github:hercules-ci/gitignore.nix";
    gitignore.inputs.nixpkgs.follows = "nixpkgs";

    # Home-manager for managing my home directory
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Reset rootfs every reboot
    impermanence.url = "github:nix-community/impermanence";

    # My SSH keys
    keys_nico.url = "https://github.com/dr460nf1r3.keys";
    keys_nico.flake = false;

    # Lanzaboote for secure boot support
    lanzaboote.url = "github:nix-community/lanzaboote/master";
    lanzaboote.inputs.flake-compat.follows = "flake-compat";
    lanzaboote.inputs.flake-parts.follows = "flake-parts";
    lanzaboote.inputs.flake-utils.follows = "flake-utils";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
    lanzaboote.inputs.pre-commit-hooks-nix.follows = "pre-commit-hooks";

    # MicroVMs based on Nix
    microvm.url = "github:astro/microvm.nix";
    microvm.inputs.flake-utils.follows = "flake-utils";
    microvm.inputs.nixpkgs.follows = "nixpkgs";

    # Nixd language server
    nixd.url = "github:nix-community/nixd";
    nixd.inputs.flake-parts.follows = "flake-parts";
    nixd.inputs.nixpkgs.follows = "nixpkgs";

    # Nix gaming-related packages and modules
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-gaming.inputs.flake-parts.follows = "flake-parts";
    nix-gaming.inputs.nixpkgs.follows = "nixpkgs";

    # Have a local index of nixpkgs for fast launching of apps
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # Bring native understanding of Nix packages to containerd
    nix-snapshotter.url = "github:pdtpartners/nix-snapshotter";
    nix-snapshotter.inputs.flake-compat.follows = "flake-compat";
    nix-snapshotter.inputs.flake-parts.follows = "flake-parts";
    nix-snapshotter.inputs.nixpkgs.follows = "nixpkgs";

    # feature-rich and convenient fork of the Nix package manager
    nix-super.url = "github:privatevoid-net/nix-super";
    nix-super.inputs.flake-compat.follows = "flake-compat";
    nix-super.inputs.nixpkgs.follows = "nixpkgs";

    nixos-anywhere.url = "https://raw.githubusercontent.com/numtide/nixos-anywhere/main/src/nixos-anywhere.sh";
    nixos-anywhere.flake = false;

    # NixOS generators to build system images
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    # NixOS hardware database
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # NixOS WSL
    nixos-wsl.url = "github:nix-community/nixos-wsl";
    nixos-wsl.inputs.flake-compat.follows = "flake-compat";
    nixos-wsl.inputs.flake-utils.follows = "flake-utils";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    # The source of all truth!
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";

    # Easy linting of the flake and all kind of other stuff
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
    pre-commit-hooks.inputs.flake-compat.follows = "flake-compat";
    pre-commit-hooks.inputs.flake-utils.follows = "flake-utils";
    pre-commit-hooks.inputs.gitignore.follows = "gitignore";
    pre-commit-hooks.inputs.nixpkgs.follows = "nixpkgs";
    pre-commit-hooks.inputs.nixpkgs-stable.follows = "nixpkgs-stable";

    # Secrets management
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix.inputs.nixpkgs-stable.follows = "nixpkgs-stable";

    # Spicetify
    spicetify-nix.url = "github:the-argus/spicetify-nix";
    spicetify-nix.inputs.flake-utils.follows = "flake-utils";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    # The Chaotic toolbox
    src-chaotic-toolbox.url = "github:chaotic-aur/toolbox";
    src-chaotic-toolbox.flake = false;
    src-repoctl.url = "github:cassava/repoctl";
    src-repoctl.flake = false;
  };

  outputs = {
    devshell,
    flake-parts,
    nixpkgs,
    pre-commit-hooks,
    self,
    ...
  } @ inp: let
    inputs = inp;
    perSystem = {
      pkgs,
      system,
      ...
    }: {
      # This basically allows using the devshell as flake app
      apps.default = self.outputs.devShells.${system}.default.flakeApp;

      # Pre-commit hooks are set up automatically via nix-shell / nix develop
      checks.pre-commit-check = pre-commit-hooks.lib.${system}.run {
        hooks = {
          actionlint.enable = true;
          alejandra-quiet = {
            description = "Run Alejandra in quiet mode";
            enable = true;
            entry = ''
              ${pkgs.alejandra}/bin/alejandra --quiet
            '';
            files = "\\.nix$";
            name = "alejandra";
          };
          commitizen.enable = true;
          deadnix.enable = true;
          nil.enable = true;
          prettier.enable = true;
          yamllint.enable = true;
          statix.enable = true;
        };
        src = ./.;
      };

      # Handy devshell for working with this flake
      devShells = let
        # Import the devshell module as module rather than a flake input
        makeDevshell = import "${inp.devshell}/modules" pkgs;
        mkShell = config:
          (makeDevshell {
            configuration = {
              inherit config;
              imports = [];
            };
          })
          .shell;
      in rec {
        default = dr460nixed-shell;
        dr460nixed-shell = mkShell {
          devshell.name = "dr460nixed-devshell";
          commands = [
            {
              command = "bash ${inp.nixos-anywhere}";
              help = "Helps installing NixOS on any host";
              name = "nixos-anywhere";
            }
            {
              category = "dr460nixed";
              command = "${self.packages.${system}.repl}/bin/dr460nixed-repl";
              help = "Start a repl shell with all flake outputs available";
              name = "repl";
            }
            {
              category = "dr460nixed";
              command = "nix build .#iso";
              help = "Builds a NixOS ISO with all most important configurations";
              name = "buildiso";
            }
            {package = "age";}
            {package = "commitizen";}
            {package = "gnupg";}
            {package = "manix";}
            {package = "mdbook";}
            {package = "nix-melt";}
            {package = "pre-commit";}
            {package = "rsync";}
            {package = "sops";}
            {package = "yamlfix";}
          ];
          devshell.startup.preCommitHooks.text = self.checks.${system}.pre-commit-check.shellHook;
          env = [
            {
              name = "NIX_PATH";
              value = "${nixpkgs}";
            }
          ];
        };
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
        inputs.pre-commit-hooks.flakeModule
      ];

      # The systems currently available
      systems = ["x86_64-linux" "aarch64-linux"];

      # This applies to all systems
      inherit perSystem;
    };
}
