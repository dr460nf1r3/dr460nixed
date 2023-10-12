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
        default = null;
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

      # Make use of nix-super if it is enabled
      package = lib.mkIf cfgSuper.enable pkgs.nixSuper;

      # Nix.conf settings
      settings = {
        # Accept flake configs by default
        accept-flake-config = true;

        # Test out ca-derivations (https://nixos.wiki/wiki/Ca-derivations)
        experimental-features = ["ca-derivations"];

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

        # Trust the remote machines cache signatures
        trusted-public-keys = lib.mkIf cfgRemote.enable ["${cfgRemote.trustedPublicKey}"];
        trusted-substituters = lib.mkIf cfgRemote.enable ["ssh-ng://${cfgRemote.host}"];
      };
    };

    # Nix-super - https://github.com/privatevoid-net/nix-super
    nixpkgs.overlays = lib.mkIf cfgSuper.enable [
      (_: _prev: {
        nixSuper = inputs.nix-super.packages.x86_64-linux.default;
      })
    ];

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
