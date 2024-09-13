{
  description = "Dr460nixed NixOS flake ❄️";

  nixConfig = {
    extra-substituters = [
      "https://cache.garnix.io"
    ];
    extra-trusted-public-keys = [
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };

  inputs = {
    # Chaotic Nyx!
    chaotic-nyx = {
      url = "github:chaotic-cx/nyx/nyxpkgs-unstable";
      inputs.home-manager.follows = "home-manager";
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
    flake-compat.url = "github:edolstra/flake-compat";

    # Required by some other flakes
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    # Another thing required by other flakes
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
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
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit-hooks-nix.follows = "pre-commit-hooks";
    };

    # Lets give Lix another try
    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/2.91.0.tar.gz";
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

    # Convenient system hardening
    nix-mineral = {
      url = "github:cynicsketch/nix-mineral";
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
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    # Easy linting of the flake and all kind of other stuff
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.flake-compat.follows = "flake-compat";
      inputs.gitignore.follows = "gitignore";
      inputs.nixpkgs-stable.follows = "nixpkgs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Proxmox on NixOS - this one needs its own Nixpkgs instance
    proxmox-nixos = {
      url = "github:SaumonNet/proxmox-nixos";
      inputs.flake-compat.follows = "flake-compat";
      inputs.utils.follows = "flake-utils";
    };

    # Secrets management
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.nixpkgs-stable.follows = "nixpkgs";
    };

    # Spicetify
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.flake-compat.follows = "flake-compat";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Fresh ucode packages
    ucodenix = {
      url = "github:e-tho/ucodenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Systems flake
    systems.url = "github:nix-systems/x86_64-linux";
  };

  outputs = {
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
          check-json.enable = true;
          check-yaml.enable = true;
          detect-private-keys.enable = true;
          deadnix.enable = true;
          flake-checker.enable = true;
          nil.enable = true;
          prettier.enable = true;
          pre-commit-hook-ensure-sops.enable = true;
          yamllint.enable = true;
          statix.enable = true;
          typos.enable = true;
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
            # {package = "nix-melt";} - currently broken due to Rust 1.80
            {package = "nixos-anywhere";}
            {package = "nixos-install-tools";}
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
