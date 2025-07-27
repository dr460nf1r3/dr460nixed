{pkgs, ...}: {
  # Individual terminal app configs
  programs = {
    # Common Bash aliases & tmux autostart for SSH sessions
    bash = {
      bashrcExtra = ''
        export PATH=$HOME/.local/bin:$PATH

        if [[ ! -v ENV_CLEANED ]]; then
          export ENV_CLEANED=1
          QT_PLUGIN_PATH_MOD="$(echo $QT_PLUGIN_PATH | tr ':' '\n' | grep "/" | awk '!x[$0]++' | head -c -1 | tr '\n' ':')"
          XDG_DATA_DIRS_MOD="$(echo $XDG_DATA_DIRS | tr ':' '\n' | grep "/" | awk '!x[$0]++' | head -c -1 | tr '\n' ':')"
          XDG_CONFIG_DIRS_MOD="$(echo $XDG_CONFIG_DIRS | tr ':' '\n' | grep "/" | awk '!x[$0]++' | head -c -1 | tr '\n' ':')"
          export QT_PLUGIN_PATH=$QT_PLUGIN_PATH_MOD
          export XDG_DATA_DIRS=$XDG_DATA_DIRS_MOD
          export XDG_CONFIG_DIRS=$XDG_CONFIG_DIRS_MOD
        fi
      '';
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
        "https://cache.garnix.io" # extra things here and there
        # "https://cache.saumon.network/proxmox-nixos" # proxmox on NixOS - SSL failure as of 240817
        "https://catppuccin.cachix.org" # a cache for Catppuccin-nix
        "https://nix-community.cachix.org" # nix-community cache
        "https://nix-gaming.cachix.org" # nix-gaming
        "https://nixpkgs-unfree.cachix.org" # unfree-package cache
        "https://numtide.cachix.org" # another unfree package cache
        "https://pre-commit-hooks.cachix.org" # pre-commit hooks
      ];
      trusted-public-keys = [
        "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
        "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
        "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
        "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
        "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
        # "proxmox-nixos:nveXDuVVhFDRFx8Dn19f1WDEaNRJjPrF2CPD2D+m1ys="
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

  # Fastfetch config
  home.file.".config/fastfetch/config.jsonc".source = ./misc/config.jsonc;

  # Theming
  catppuccin.enable = true;

  # I don't use docs, so just disable them
  manual = {
    html.enable = false;
    json.enable = false;
    manpages.enable = false;
  };
  programs.man.enable = false;
}
