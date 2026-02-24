{
  config,
  lib,
  ...
}:
let
  cfgRemote = config.dr460nixed.remote-build;
in
{
  options.dr460nixed.remote-build = with lib; {
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

  config = lib.mkIf cfgRemote.enable {
    nix = {
      # The remote builder to use for distributed builds
      buildMachines = [
        {
          hostName = cfgRemote.host;
          maxJobs = 16;
          protocol = "ssh-ng";
          supportedFeatures = [
            "nixos-test"
            "benchmark"
            "big-parallel"
            "kvm"
          ];
          systems = [
            "x86_64-linux"
            "aarch64-linux"
          ];
        }
      ];

      # Allow distributed builds
      distributedBuilds = lib.mkIf cfgRemote.enableGlobally true;

      settings = {
        # Trust the remote machines cache signatures
        trusted-substituters = [ "ssh-ng://${cfgRemote.host}" ];
      };
    };

    # Let root ssh into the remote builder seamlessly
    home-manager.users."root" = {
      home.stateVersion = "26.05";
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
