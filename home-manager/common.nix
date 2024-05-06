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
    # Easy terminal tabbing
    tmux = {
      baseIndex = 1;
      clock24 = true;
      enable = true;
      extraConfig = ''
        set -g default-shell ${pkgs.fish}/bin/fish
        set -g default-terminal "screen-256color"
        set -g status-bg black
      '';
      historyLimit = 10000;
      newSession = true;
      sensibleOnTop = false;
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

  # I don't use docs, so just disable them
  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };
}
