{
  description = "Dr460nixed NixOS flake ❄️";

  nixConfig.extra-substituters = [ "https://dr460nf1r3.cachix.org" ];
  nixConfig.extra-trusted-public-keys = [ "dr460nf1r3.cachix.org-1:eLI/ymdDmYKBwwSNuA0l6zvfDZuZfh0OECGKzuv8xvU=" ];

  inputs = {
    # Chaotic Nyx!
    chaotic-nyx.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

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

    # Nix-on-Droid
    nix-on-droid.url = "github:t184256/nix-on-droid";
    nix-on-droid.inputs.nixpkgs.follows = "nixpkgs";

    # NixOS generators to build system images
    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    # NixOS hardware database
    nixos-hardware.url = "github:NixOS/nixos-hardware";

    # NixOS WSL
    nixos-wsl.url = "github:nix-community/nixos-wsl";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    # Easy linting of the flake
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
  };

  outputs =
    { disko
    , flake-utils
    , garuda-nix
    , impermanence
    , lanzaboote
    , nix-index-database
    , nix-on-droid
    , nixd
    , nixos-generators
    , nixos-hardware
    , nixos-wsl
    , nixpkgs
    , pre-commit-hooks
    , self
    , sops-nix
    , spicetify-nix
    , ...
    } @ inputs:
    let
      defaultModules = [
        # make flake inputs accessiable in NixOS
        {
          _module.args.self = self;
          _module.args.inputs = self.inputs;
          nixpkgs.overlays = [ nixd.overlays.default ];
        }
        ./modules/default.nix
        disko.nixosModules.disko
        lanzaboote.nixosModules.lanzaboote
        nix-index-database.nixosModules.nix-index
        sops-nix.nixosModules.sops
        spicetify-nix.nixosModule
      ];
      specialArgs = {
        inherit spicetify-nix;
        keys.nico = inputs.keys_nico;
        sources = {
          chaotic-toolbox = inputs.src-chaotic-toolbox;
          repoctl = inputs.src-repoctl;
        };
      };
      system = "x86_64-linux";
    in
    {
      # All the system configurations
      # My main device (Lenovo Slim 7)
      nixosConfigurations."dragons-ryzen" = garuda-nix.lib.garudaSystem {
        inherit system;
        modules = defaultModules
        ++ [
          ./hosts/dragons-ryzen/dragons-ryzen.nix
          impermanence.nixosModules.impermanence
          nixos-hardware.nixosModules.common-cpu-amd
          nixos-hardware.nixosModules.common-cpu-amd-pstate
          nixos-hardware.nixosModules.common-gpu-amd
        ];
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
        ++ [
          ./hosts/rpi-dragon/rpi-dragon.nix
          nixos-hardware.nixosModules.raspberry-pi-4
        ];
        inherit specialArgs;
      };
      # My old laptop serving as TV
      nixosConfigurations."tv-nixos" = garuda-nix.lib.garudaSystem {
        inherit system;
        modules = defaultModules
        ++ [
          ./hosts/tv-nixos/tv-nixos.nix
          nixos-hardware.nixosModules.common-gpu-intel
          nixos-hardware.nixosModules.lenovo-thinkpad-t470s
        ];
        inherit specialArgs;
      };
      # My Pixel 6 via Nix-on-Droid
      nixOnDroidConfigurations."mobile-dragon" = nix-on-droid.lib.nixOnDroidConfiguration {
        # home-manager-path = inputs.garuda-nix.inputs.home-manager.outPath;
        modules = [
          ./modules/default.nix
          nix-index-database.nixosModules.nix-index
          sops-nix.nixosModules.sops
        ];
        pkgs = import nixpkgs {
          system = "aarch64-linux";
          overlays = [ nix-on-droid.overlays.default ];
        };
      };
    } // flake-utils.lib.eachDefaultSystem (system:
    let
      modules = [
        ./modules/images/base.nix
        ./modules/images/iso.nix
        ./modules/nix.nix
        nix-index-database.nixosModules.nix-index
      ];
      pkgs = nixpkgs.legacyPackages.${system}.pkgs;
      specialArgs = {
        inherit inputs;
        keys.nico = inputs.keys_nico;
      };
    in
    {
      # Set those up via "nix develop", then automatically used at "git commit"
      checks.pre-commit-check = pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          actionlint.enable = true;
          commitizen.enable = true;
          deadnix.enable = true;
          hadolint.enable = true;
          nil.enable = true;
          nixpkgs-fmt.enable = true;
          prettier.enable = true;
          shellcheck.enable = true;
        };
        settings.deadnix = {
          edit = true;
          hidden = true;
          noLambdaArg = true;
        };
      };

      # The shell to enter with "nix develop"
      devShell = nixpkgs.legacyPackages.${system}.mkShell {
        name = "dr460nixed";
        packages = with pkgs; [
          age
          commitizen
          deadnix
          git
          gnupg
          manix
          nix
          nixpkgs-fmt
          rsync
          sops
          statix
        ];
        shellHook = ''
          ${self.checks.${system}.pre-commit-check}
          echo "Welcome to the dr460nixed shell! ❄️"
        '';
      };

      # Defines a formatter for "nix fmt"
      formatter = nixpkgs.legacyPackages.${system}.nixpkgs-fmt;

      # Defines what to build via Hydra (if I get to use it)
      hydraJobs = {
        inherit (self)
          packages;
      };

      # Images to be built via "nix build"
      packages = {
        iso = nixos-generators.nixosGenerate {
          format = "install-iso";
          inherit modules;
          inherit specialArgs;
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          system = "x86_64-linux";
        };
        vbox = nixos-generators.nixosGenerate {
          format = "virtualbox";
          inherit modules;
          inherit specialArgs;
          pkgs = nixpkgs.legacyPackages.x86_64-linux;
          system = "x86_64-linux";
        };
      };
    });
}
   
