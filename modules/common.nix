{ config
, inputs
, lib
, pkgs
, sources
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

  config = mkIf cfg.common.enable
    {
      ## A few kernel tweaks
      boot.kernel.sysctl = {
        "kernel.printks" = "3 3 3 3";
        "kernel.sysrq" = 0;
        "kernel.unprivileged_userns_clone" = 1;
      };

      # Microcode and firmware updates
      hardware = {
        cpu = {
          amd.updateMicrocode = true;
          intel.updateMicrocode = true;
        };
        enableRedistributableFirmware = true;
      };

      services = {
        # handle ACPI events
        acpid.enable = true;
        # discard blocks that are not in use by the filesystem, good for SSDs
        fstrim.enable = true;
        # firmware updater for machine hardware
        fwupd.enable = true;
        # limit systemd journal size
        journald.extraConfig = ''
          SystemMaxUse=50M
          RuntimeMaxUse=10M
        '';
      };

      # We want to be insulted on wrong passwords
      # & allow deployment of configurations via Colmena
      security.sudo = {
        execWheelOnly = true;
        extraConfig = ''
          Defaults pwfeedback
          deploy ALL=(ALL) NOPASSWD:ALL
        '';
        package = pkgs.sudo.override { withInsults = true; };
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
        gnupg.agent.enable = true;
        # type "fuck" to fix the last command that made you go "fuck"
        thefuck.enable = true;
      };

      # Enable locating files via locate
      services.locate = {
        enable = true;
        interval = "hourly";
        localuser = null;
        locate = pkgs.plocate;
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
        # Make builds run with low priority so my system stays responsive
        daemonCPUSchedPolicy = "idle";
        daemonIOSchedClass = "idle";

        # Do garbage collections whenever there is less than 1GB free space left
        extraOptions = ''
          min-free = ${toString (100 * 1024 * 1024)}
          max-free = ${toString (1024 * 1024 * 1024)}
          accept-flake-config = true
          http-connections = 0
          warn-dirty = false
        '';

        # Do daily garbage collections
        gc = {
          automatic = true;
          dates = "daily";
          options = "--delete-older-than 5d";
        };

        settings = {
          # Only allow the wheel group to handle Nix
          allowed-users = [ "@wheel" ];
          # Allow using flakes
          auto-optimise-store = true;
          # use binary cache, its not gentoo
          # this also allows us to use remote builders to reduce build times and batter usage
          builders-use-substitutes = true;

          # A few extra binary caches
          extra-substituters = [
            "https://colmena.cachix.org"
            "https://dr460nf1r3.cachix.org"
            "https://garuda-linux.cachix.org"
            "https://nix-community.cachix.org"
            "https://nixpkgs-unfree.cachix.org"
            "https://nyx.chaotic.cx"
          ];
          extra-trusted-public-keys = [
            "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
            "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg="
            "dr460nf1r3.cachix.org-1:ujkI5l3i3m6Jh3J8phRXtnUbKdrn7JIxb/dPAO3ePbI="
            "garuda-linux.cachix.org-1:tWw7YBE6qZae0L6BbyNrHo8G8L4sHu5QoDp0OXv70bg="
            "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
            "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
            "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
          ];
          # enable new nix command and flakes
          # and also "unintended" recursion as well as content addresssed nix
          extra-experimental-features = [ "flakes" "nix-command" "recursive-nix" "ca-derivations" ];

          # continue building derivations if one fails
          keep-going = true;
          # show more log lines for failed builds
          log-lines = 20;

          # for direnv GC roots
          keep-derivations = true;
          keep-outputs = true;
          max-jobs = "auto";
          system-features = [ "big-parallel" "kvm" "recursive-nix" ];
          trusted-users = [ "@wheel" "deploy" ];
        };
        # pin the registry to avoid downloading and evalıationg a new nixpkgs
        # version everytime
        # this will add each flake input as a registry
        # to make nix3 commands consistent with your flake
        # registry = mapAttrs (_: v: { flake = v; }) inputs;

        # This will additionally add your inputs to the system's legacy channels
        # Making legacy nix commands consistent as well, awesome!
        nixPath = mapAttrsToList (key: _: "${key}=flake:${key}") config.nix.registry;

        package = pkgs.nixUnstable;
      };

      # Allow unfree packages
      nixpkgs.config.allowUnfree = true;

      # Clean results periodically
      systemd.services.nix-clean-result = {
        serviceConfig.Type = "oneshot";
        description = "Auto clean all result symlinks created by nixos-rebuild test";
        script = ''
          "${config.nix.package.out}/bin/nix-store" --gc --print-roots | "${pkgs.gawk}/bin/awk" 'match($0, /^(.*\/result) -> \/nix\/store\/[^-]+-nixos-system/, a) { print a[1] }' | xargs -r -d\\n rm
        '';
        before = [ "nix-gc.service" ];
        wantedBy = [ "nix-gc.service" ];
      };

      # Print a diff when running system updates
      system.activationScripts.diff = ''
        if [[ -e /run/current-system ]]; then
          (
            for i in {1..3}; do
              result=$(${config.nix.package}/bin/nix store diff-closures /run/current-system "$systemConfig" 2>&1)
              if [ $? -eq 0 ]; then
                printf '%s' "$result"
                break
              fi
            done
          )
        fi
      '';

      # Automatic system upgrades
      # system.autoUpgrade = {
      #   enable = false;
      #   dates = "hourly";
      #   flags = [ "--refresh" ];
      #   flake = "github:dr460nf1r3/device-configurations";
      # };
    };
} 
