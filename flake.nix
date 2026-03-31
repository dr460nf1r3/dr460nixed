{
  description = "Dr460nixed NixOS flake ❄️";

  nixConfig = {
    extra-substituters = [
      "https://cache.nixos.org/"
      "https://devenv.cachix.org"
      "https://cache.garnix.io"
    ];
    extra-trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
    ];
  };

  inputs = {
    catppuccin = {
      url = "github:catppuccin/nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    devenv = {
      url = "github:cachix/devenv";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
      inputs.git-hooks.follows = "git-hooks";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-compat.url = "github:edolstra/flake-compat";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
    };

    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.systems.follows = "systems";
    };

    garuda-nix = {
      url = "gitlab:garuda-linux/garuda-nix-subsystem/main";
      # url = "git+file:///home/nico/Projects/misc/dr460nixed/garuda-nix-subsystem";
      inputs.catppuccin.follows = "catppuccin";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
      inputs.git-hooks.follows = "git-hooks";
      inputs.home-manager.follows = "home-manager";
      inputs.nix-index-database.follows = "nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.treefmt-nix.follows = "treefmt-nix";
    };

    git-hooks = {
      url = "github:cachix/git-hooks.nix";
      inputs.flake-compat.follows = "flake-compat";
      inputs.gitignore.follows = "gitignore";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    gitignore = {
      url = "github:hercules-ci/gitignore.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
      inputs.home-manager.follows = "home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    keys_nico = {
      url = "https://github.com/dr460nf1r3.keys";
      flake = false;
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/master";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.pre-commit.follows = "pre-commit-hooks";
    };

    lix = {
      url = "https://git.lix.systems/lix-project/lix/archive/main.tar.gz";
      flake = false;
    };

    lix-module = {
      url = "https://git.lix.systems/lix-project/nixos-module/archive/main.tar.gz";
      inputs.flake-utils.follows = "flake-utils";
      inputs.lix.follows = "lix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-cachyos-kernel = {
      url = "github:xddxdd/nix-cachyos-kernel/release";
      inputs.flake-compat.follows = "flake-compat";
      inputs.flake-parts.follows = "flake-parts";
    };

    nix-gaming = {
      url = "github:fufexan/nix-gaming";
      inputs.flake-parts.follows = "flake-parts";
      inputs.git-hooks.follows = "git-hooks";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-gaming-edge = {
      url = "github:powerofthe69/nix-gaming-edge";
      inputs.millennium.follows = "";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-minecraft = {
      url = "github:Infinidoge/nix-minecraft";
      inputs.flake-compat.follows = "flake-compat";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware";

    nixos-wsl = {
      url = "github:nix-community/nixos-wsl";
      inputs.flake-compat.follows = "flake-compat";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.flake-compat.follows = "flake-compat";
      inputs.gitignore.follows = "gitignore";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quadlet-nix = {
      url = "github:SEIAROTg/quadlet-nix";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.systems.follows = "systems";
    };

    systems.url = "github:nix-systems/x86_64-linux";

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    ucodenix.url = "github:e-tho/ucodenix";

    # Patches (auto-applying to inputs)
    nixpkgs-patch-nvidia-590 = {
      url = "https://github.com/NixOS/nixpkgs/pull/490123.patch";
      flake = false;
    };

    # Workarounds
    syncthing-nixpkgs.url = "github:NixOS/nixpkgs/90c93f32066ca8fdcb0ee5b568363b7e10c52eaf";
  };

  outputs =
    {
      flake-parts,
      nixpkgs,
      self,
      ...
    }@inputs:
    let

      keys = {
        nico = inputs.keys_nico;
      };

      dragonLib = import ./lib {
        inherit inputs self;
        outputs = self;
        inherit keys;
      };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      _module.args.dragonLib = dragonLib;
      imports = [
        ./hosts/flake-module.nix
        ./nixos/flake-module.nix
        ./packages/flake-module.nix
        inputs.devenv.flakeModule
        inputs.git-hooks.flakeModule
        inputs.disko.flakeModules.default
        inputs.home-manager.flakeModules.home-manager
        inputs.treefmt-nix.flakeModule
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];

      perSystem =
        {
          system,
          config,
          ...
        }:
        let
          pkgsLix = import nixpkgs {
            inherit system;
            overlays = [ inputs.lix-module.overlays.default ];
          };
        in
        {
          treefmt = {
            projectRootFile = "flake.nix";
            package = pkgsLix.treefmt;
            programs = {
              actionlint.enable = true;
              deadnix.enable = true;
              nixfmt.enable = true;
              prettier.enable = true;
              statix.enable = true;
              typos.enable = true;
              yamllint.enable = true;
            };
          };

          pre-commit.settings = {
            package = pkgsLix.prek;
            hooks = {
              actionlint.enable = true;
              commitizen.enable = true;
              check-json.enable = true;
              check-yaml.enable = true;
              detect-private-keys.enable = true;
              deadnix.enable = true;
              flake-checker.enable = true;
              nil = {
                enable = true;
                package = pkgsLix.nil;
              };
              nixfmt.enable = true;
              prettier.enable = true;
              pre-commit-hook-ensure-sops.enable = true;
              statix.enable = true;
              typos.enable = true;
              yamllint.enable = true;
            };
          };

          legacyPackages = {
            inherit (config) githubActions;
          };

          devenv.shells = import ./maintenance/dev-shells {
            inherit
              inputs
              system
              config
              ;
            pkgs = pkgsLix;
          };
        };

      flake = {
        inherit dragonLib;

        diskoConfigurations = {
          btrfs-subvolumes = import ./nixos/modules/disko/btrfs-subvolumes.nix { };
          luks-btrfs-subvolumes = import ./nixos/modules/disko/luks-btrfs-subvolumes.nix { };
          simple-efi = import ./nixos/modules/disko/simple-efi.nix { };
          zfs-encrypted = import ./nixos/modules/disko/zfs-encrypted.nix { };
          zfs = import ./nixos/modules/disko/zfs.nix { };
        };
      };
    };
}
