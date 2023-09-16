{ pkgs, ... }: {
  # Lets sign by default
  programs.git.signing.signByDefault = true;

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

    # Easy terminal tabbing
    tmux = {
      baseIndex = 1;
      clock24 = true;
      enable = true;
      extraConfig = ''
        set -g default-terminal "screen-256color"
        set -g status-bg black
      '';
      historyLimit = 10000;
      newSession = true;
      sensibleOnTop = false;
      shell = "${pkgs.fish}/bin/fish";
    };
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
      # Use available binary caches, this is not Gentoo
      # this also allows us to use remote builders to reduce build times and batter usage
      builders-use-substitutes = true;

      # A few extra binary caches and their public keys
      substituters = [
        "https://cache.garnix.io"
        "https://dr460nf1r3.cachix.org"
      ];
      trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "dr460nf1r3.cachix.org-1:eLI/ymdDmYKBwwSNuA0l6zvfDZuZfh0OECGKzuv8xvU="
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

}
