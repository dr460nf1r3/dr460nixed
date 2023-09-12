{
  description = "Dr460nixed NixOS flake ❄️";

  nixConfig.extra-substituters = [ "https://dr460nf1r3.cachix.org" ];
  nixConfig.extra-trusted-public-keys = [ "dr460nf1r3.cachix.org-1:eLI/ymdDmYKBwwSNuA0l6zvfDZuZfh0OECGKzuv8xvU=" ];

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
    flake-utils.inputs.systems.follows = "systems";

    # Garuda Linux flake - most of my system settings are here
    # garuda-nix.url = "/home/nico/Documents/misc/garuda-nix-subsystem";
    garuda-nix.url = "gitlab:garuda-linux/garuda-nix-subsystem/main";
    garuda-nix.inputs.chaotic-nyx.follows = "chaotic-nyx";
    garuda-nix.inputs.devshell.follows = "devshell";
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

    # Nixd language server
    nixd.url = "github:nix-community/nixd";
    nixd.inputs.flake-parts.follows = "flake-parts";
    nixd.inputs.nixpkgs.follows = "nixpkgs";

    # MicroVMs based on Nix
    microvm.url = "github:astro/microvm.nix";
    microvm.inputs.flake-utils.follows = "flake-utils";
    microvm.inputs.nixpkgs.follows = "nixpkgs";

    # Nix gaming-related packages and modules
    nix-gaming.url = "github:fufexan/nix-gaming";
    nix-gaming.inputs.flake-parts.follows = "flake-parts";
    nix-gaming.inputs.nixpkgs.follows = "nixpkgs";

    # Have a local index of nixpkgs for fast launching of apps
    nix-index-database.url = "github:Mic92/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

    # feature-rich and convenient fork of the Nix package manager
    nix-super.url = "github:privatevoid-net/nix-super";
    nix-super.inputs.flake-compat.follows = "flake-compat";
    nix-super.inputs.nixpkgs.follows = "nixpkgs";

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

    # Common input
    systems.url = "github:nix-systems/default";

    # Treefmt for advanced linting / formatting
    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs =
    { devshell
    , flake-parts
    , nixpkgs
    , pre-commit-hooks
    , self
    , ...
    } @ inp:
    let
      inputs = inp;
      perSystem =
        { pkgs
        , system
        , ...
        }: {
          apps.default = self.outputs.devShells.${system}.default.flakeApp;

          checks.pre-commit-check = pre-commit-hooks.lib.${system}.run {
            hooks = {
              actionlint.enable = true;
              commitizen.enable = true;
              deadnix.enable = true;
              nil.enable = true;
              nixpkgs-fmt.enable = true;
              prettier.enable = true;
              yamllint.enable = true;
              statix.enable = true;
            };
            src = ./.;
          };

          devShells =
            let
              makeDevshell = import "${inp.devshell}/modules" pkgs;
              mkShell = config: (makeDevshell {
                configuration = {
                  inherit config;
                  imports = [ ];
                };
              }).shell;
            in
            rec {
              default = dr460nixed-shell;
              dr460nixed-shell = mkShell {
                devshell.name = "dr460nixed-devshell";
                commands = [
                  { package = "age"; }
                  { package = "commitizen"; }
                  { package = "gnupg"; }
                  { package = "manix"; }
                  { package = "mdbook"; }
                  { package = "nix-melt"; }
                  { package = "pre-commit"; }
                  { package = "rsync"; }
                  { package = "sops"; }
                  { package = "yamlfix"; }
                ];
                devshell.startup = {
                  preCommitHooks.text = self.checks.${system}.pre-commit-check.shellHook;
                  dr460nixedEnv.text = ''
                    export NIX_PATH=nixpkgs=${nixpkgs}
                  '';
                };
              };
            };

          formatter = pkgs.nixpkgs-fmt;

          packages.docs = pkgs.runCommand "dr460nixed-docs"
            { nativeBuildInputs = with pkgs; [ bash mdbook ]; }
            ''
              bash -c "errors=$(mdbook build -d $out ${./.}/docs |& grep ERROR)
              if [ \"$errors\" ]; then
                exit 1
              fi"
            '';

        };
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        ./nixos/flake-module.nix
        inputs.devshell.flakeModule
        inputs.pre-commit-hooks.flakeModule
      ];
      systems = [ "x86_64-linux" "aarch64-linux" ];
      inherit perSystem;
    };
}









