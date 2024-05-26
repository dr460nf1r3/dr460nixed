{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  cfgRemote = config.dr460nixed.remote-build;
  cfgSuper = config.dr460nixed.nix-super;
in {
  options.dr460nixed = with lib; {
    nix-super = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Replaces nix with nix-super, which tracks future features of nix.
        '';
      };
    };
    remote-build = {
      enable = mkOption {
        default = false;
        example = true;
        type = types.bool;
        description = mdDoc ''
          Enable the capability of building via nix on a remote machine when specified via command line flag.
        '';
      };
      enableGlobally = mkOption {
        default = false;
        example = true;
        type = types.bool;
        description = mdDoc ''
          Enables remote builds via enableDistributedBuild rather than making it opt-in via command line.
        '';
      };
      host = mkOption {
        default = "";
        type = types.str;
        example = "dragons-ryzen";
        description = mdDoc ''
          Specifies the target host for remote builds.
        '';
      };
      port = mkOption {
        default = 22;
        type = types.int;
        example = 1022;
        description = mdDoc ''
          Specifies the target port for remote builds.
        '';
      };
      trustedPublicKey = mkOption {
        default = null;
        type = types.str;
        example = "remote-build:8vrLBvFoMiKVKRYD//30bhUBTEEiuupfdQzl2UoMms4=";
        description = mdDoc ''
          Specifies the substitutors cache signing key for remote builds.
        '';
      };
      user = mkOption {
        default = null;
        type = types.str;
        example = "build";
        description = mdDoc ''
          Specifies the target user for remote builds.
        '';
      };
    };
  };

  config = {
    # General nix settings
    nix = {
      # The remote builder to use for distributed builds
      buildMachines = lib.mkIf cfgRemote.enable [
        {
          hostName = cfgRemote.host;
          maxJobs = 16;
          protocol = "ssh-ng";
          supportedFeatures = ["nixos-test" "benchmark" "big-parallel" "kvm"];
          systems = ["x86_64-linux" "aarch64-linux"];
        }
      ];

      # Allow distributed builds
      distributedBuilds = lib.mkIf cfgRemote.enableGlobally true;

      # Dont warn about dirty flakes and accept flake configs by default
      extraOptions = ''
        http-connections = 0
        warn-dirty = false
      '';

      # Make use of nix-super if it is enabled, else use latest available
      package = lib.mkIf cfgSuper.enable pkgs.nixSuper;

      # Nix.conf settings
      settings = {
        # Accept flake configs by default
        accept-flake-config = true;

        # Test out ca-derivations (https://nixos.wiki/wiki/Ca-derivations)
        experimental-features = ["ca-derivations"];

        # Lix cache
        extra-substituters = ["https://cache.lix.systems"];

        # For direnv GC roots
        keep-derivations = true;
        keep-outputs = true;

        # Continue building derivations if one fails
        keep-going = true;

        # Show more log lines for failed builds
        log-lines = 20;

        # Max number of parallel jobs
        max-jobs = "auto";

        # Enable certain system features
        system-features = ["big-parallel" "kvm"];

        # Build inside sandboxed environments
        sandbox = pkgs.stdenv.isLinux;

        # Trust the remote machines cache signatures
        trusted-substituters = lib.mkIf cfgRemote.enable ["ssh-ng://${cfgRemote.host}"];

        # Specify the path to the nix registry
        flake-registry = "/etc/nix/registry.json";

        substituters = [
          "https://cache.garnix.io" # extra things here and there
          "https://catppuccin.cachix.org" # a cache for Catppuccin-nix
          "https://devenv.cachix.org" # Devenv cache
          "https://nix-community.cachix.org" # nix-community cache
          "https://nix-gaming.cachix.org" # nix-gaming
          "https://nixpkgs-unfree.cachix.org" # unfree-package cache
          "https://numtide.cachix.org" # another unfree package cache
          "https://pre-commit-hooks.cachix.org" # pre-commit hooks
        ];
        trusted-public-keys = [
          "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
          "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
          "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw="
          "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
          "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
          "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
          "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
        ];
      };
    };

    # Nix-super - https://github.com/privatevoid-net/nix-super
    nixpkgs.overlays = lib.mkIf cfgSuper.enable [
      (_: _prev: {
        nixSuper = inputs.nix-super.packages.x86_64-linux.default;
      })
    ];

    environment = {
      etc = with inputs; {
        # set channels (backwards compatibility)
        "nix/flake-channels/home-manager".source = home-manager;
        "nix/flake-channels/nixpkgs".source = nixpkgs;
        "nix/flake-channels/system".source = self;

        # preserve current flake in /etc
        "nixos/flake".source = self;
      };

      # Git is required for flakes, and cachix for binary substituters
      systemPackages = with pkgs; [git cachix];
    };

    # Let root ssh into the remote builder seamlessly
    home-manager.users."root" = lib.mkIf cfgRemote.enable {
      home.stateVersion = "23.11"; # Specify this since its otherwise unset
      programs.ssh.extraConfig = ''
        Host ${cfgRemote.host}
          HostName ${cfgRemote.host}
          Port ${toString cfgRemote.port}
          User ${cfgRemote.user}
      '';
    };

    # Supply a shortcut for the remote builder
    programs = {
      bash.shellAliases = {
        "rem" = "sudo nix build -v --builders ssh://${cfgRemote.host}";
        "remb" = "sudo nixos-rebuild switch -v --builders ssh://${cfgRemote.host} --flake";
      };
      fish = {
        shellAbbrs = {
          "rem" = "sudo nix build -v --builders ssh://${cfgRemote.host}";
          "remb" = "sudo nixos-rebuild switch -v --builders ssh://${cfgRemote.host} --flake";
        };
      };
    };
  };
}
