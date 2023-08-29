{ pkgs, ... }: {
  # Import individual configuration snippets
  imports = [ ./shells.nix ];

  # I'm working with git a lot
  programs.git = {
    signing = {
      key = "D245D484F3578CB17FD6DA6B67DB29BFF3C96757";
      signByDefault = true;
    };
    userEmail = "root@dr460nf1r3.org";
    userName = "Nico Jensch";
  };

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

  # Always use my cache
  nix.extraOptions = ''
    extra-substituters = https://dr460nf1r3.cachix.org
    extra-trusted-public-keys = dr460nf1r3.cachix.org-1:eLI/ymdDmYKBwwSNuA0l6zvfDZuZfh0OECGKzuv8xvU=
  '';
}
