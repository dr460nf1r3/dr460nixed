{ config
, lib
, pkgs
, ...
}:
with lib;
let
  cfg = config.dr460nixed;
in
{
  options.dr460nixed = {
    common = {
      enable = mkOption
        {
          default = true;
          type = types.bool;
          description = mdDoc ''
            Whether to enable common system configurations.
          '';
        };
    };
    rpi = mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Whether this is a Raspberry Pi.
        '';
      };
    nodocs = mkOption
      {
        default = true;
        type = types.bool;
        description = mdDoc ''
          Whether to disable the documentation.
        '';
      };
  };

  config = mkIf cfg.common.enable {
    ## A few kernel tweaks
    boot.kernel.sysctl = { "kernel.unprivileged_userns_clone" = 1; };

    # We want to be insulted on wrong passwords
    # & allow deployment of configurations via Colmena
    security.sudo = {
      execWheelOnly = true;
      extraConfig = ''
        deploy ALL=(ALL) NOPASSWD:ALL
      '';
    };

    # Increase open file limit for sudoers
    security.pam.loginLimits = [
      {
        domain = "@wheel";
        item = "nofile";
        type = "soft";
        value = "524288";
      }
      {
        domain = "@wheel";
        item = "nofile";
        type = "hard";
        value = "1048576";
      }
    ];

    # Always needed applications
    programs = {
      git = {
        enable = true;
        lfs.enable = true;
      };
      # The GnuPG agent
      gnupg.agent = {
        enable = true;
        pinentryFlavor = "curses";
      };
    };

    # Who needs documentation when there is the internet? #bl04t3d
    documentation = mkIf cfg.nodocs {
      dev.enable = false;
      doc.enable = false;
      enable = true;
      info.enable = false;
      man.enable = false;
      nixos.enable = false;
    };

    # General nix settings
    nix = {
      # Do garbage collections whenever there is less than 1GB free space left
      extraOptions = ''
        accept-flake-config = true
        http-connections = 0
        warn-dirty = false
      '';

      settings = {
        trusted-users = [ "@wheel" "deploy" ];

        # Use available binary caches, this is not Gentoo
        # this also allows us to use remote builders to reduce build times and batter usage
        builders-use-substitutes = true;

        # A few extra binary caches and their public keys
        substituters = [
          "https://dr460nf1r3.cachix.org"
          "https://garuda-linux.cachix.org"
          "https://nix-community.cachix.org"
          "https://numtide.cachix.org"
        ];
        trusted-public-keys = [
          "dr460nf1r3.cachix.org-1:eLI/ymdDmYKBwwSNuA0l6zvfDZuZfh0OECGKzuv8xvU="
          "garuda-linux.cachix.org-1:tWw7YBE6qZae0L6BbyNrHo8G8L4sHu5QoDp0OXv70bg="
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
          "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
        ];

        # Enable certain system features
        system-features = [ "big-parallel" "kvm" "recursive-nix" ];

        # Continue building derivations if one fails
        keep-going = true;

        # Show more log lines for failed builds
        log-lines = 20;

        # For direnv GC roots
        keep-derivations = true;
        keep-outputs = true;

        # Max number of parallel jobs
        max-jobs = "auto";
      };
    };
  };
} 
