{
  description = "Dr460nixed NixOS flake ❄️";

  nixConfig = {
    extra-substituters = ["https://cache.garnix.io"];
    extra-trusted-public-keys = ["cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="];
  };

  inputs = {
    # Archlinux development
    archix = {
      url = "github:SamLukeYes/archix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Always updated auto-cpufreq
    auto-cpufreq = {
      url = "github:AdnanHodzic/auto-cpufreq";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Chaotic Nyx!
    chaotic-nyx = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.home-manager.follows = "home-manager";
      inputs.systems.follows = "systems";
    };

    # Devshell to set up a development environment
    devshell = {
      url = "github:numtide/devshell";
      flake = false;
    };

    # Disko for Nix-managed partition management
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Required by some other flakes
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };

    # Required by some other flakes
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Required by pre-commit-hooks
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    # Garuda Linux flake - most of my system settings are here
    garuda-nix = {
      # url = "/home/nico/Documents/misc/garuda-nix-subsystem";
      url = "gitlab:garuda-linux/garuda-nix-subsystem/main";
      inputs.chaotic-nyx.follows = "chaotic-nyx";
      inputs.devshell.follows = "devshell";
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
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks-nix.follows = "pre-commit-hooks";
    };

    # MicroVMs based on Nix
    microvm = {
      url = "github:astro/microvm.nix";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Nixd language server
    nixd = {
      url = "github:nix-community/nixd";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
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
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Feature-rich and convenient fork of the Nix package manager
    nix-super = {
      url = "github:privatevoid-net/nix-super";
      inputs.flake-compat.follows = "flake-compat";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Script to install NixOS on any host
    nixos-anywhere = {
      url = "https://raw.githubusercontent.com/numtide/nixos-anywhere/main/src/nixos-anywhere.sh";
      flake = false;
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
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # The source of all truth!
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nixpkgs-stable.follows = "nixpkgs";

    # Easy linting of the flake and all kind of other stuff
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-utils.follows = "flake-utils";
      inputs.gitignore.follows = "gitignore";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs-stable";
    };

    # Spicetify
    spicetify-nix = {
      url = "github:the-argus/spicetify-nix";
      inputs.flake-utils.follows = "flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Ad and malware blocking hosts file
    stevenblack-hosts = {
      url = "github:stevenblack/hosts";
      flake = false;
    };

    # Used by multiple other flakes
    systems.url = "github:nix-systems/default";
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
            {
              category = "dr460nixed";
              command = "${self.packages.${system}.installer}/bin/dr460nixed-installer";
              help = "Allows installing a basic dr460nixed installation";
              name = "installer";
            }
            {package = "age";}
            {package = "commitizen";}
            {package = "gnupg";}
            {package = "manix";}
            {package = "mdbook";}
            {package = "nix-melt";}
            {package = "nixos-install-tools";}
            {package = "pre-commit";}
            {package = "rsync";}
            {package = "sops";}
            # {package = "yamlfix";} - broken as of 231101
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
