{pkgs, ...}: {
  # Invididual terminal app configs
  programs = {
    # Common Bash aliases & tmux autostart for SSH sessions
    bash = {
      enable = true;
      initExtra = ''
        if [ -z "$TMUX" ] &&  [ "$SSH_CLIENT" != "" ]; then
          exec ${pkgs.tmux}/bin/tmux a
        fi
      '';
    };
  };

  # General nix settings
  nix = {
    # Don't warn about dirty flakes and accept flake configs by default
    extraOptions = ''
      accept-flake-config = true
      http-connections = 0
      warn-dirty = false
    '';
    settings = {
      # A few extra binary caches and their public keys
      substituters = [
        "https://cache.garnix.io"
        "https://nyx.chaotic.cx/"
      ];
      trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
        "nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="
      ];

      # Enable certain system features
      system-features = ["big-parallel" "kvm"];

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

  # TODO: find out why this package is actually relevant for this config when the active version reports 2.19.3?
  # Should be irrelevant for my use case anyways as I don't use this config on a shared machine.
  # https://github.com/NixOS/nix/security/advisories/GHSA-2ffj-w4mj-pg37
  nixpkgs.config.permittedInsecurePackages = [
    "nix-2.16.2"
  ];
}
