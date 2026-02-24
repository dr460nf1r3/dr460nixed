{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
let
  cfg = config.dr460nixed.hm.common;
in
{
  options.dr460nixed.hm.common = {
    enable = lib.mkEnableOption "common Home Manager configuration";
  };

  config = lib.mkIf cfg.enable {
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
        inherit (inputs.self.dragonLib.binaryCaches) substituters;
        inherit (inputs.self.dragonLib.binaryCaches) trusted-public-keys;

        # Enable certain system features
        system-features = [
          "big-parallel"
          "kvm"
        ];

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

    # I don't use docs, so just disable them
    manual = {
      html.enable = false;
      json.enable = false;
      manpages.enable = true;
    };
    programs.man.enable = true;
  };
}
