{pkgs, ...}: {
  # Don't forget to always load my .profile
  home.file = {
    ".bash_profile".text = ''
      [[ -f ~/.bashrc ]] && . ~/.bashrc
      [[ -f ~/.profile ]] && . ~/.profile
    '';
  };

  # Invididual terminal app configs
  programs = {
    # Common Bash aliases & tmux autostart
    bash = {
      enable = true;
      initExtra = ''
        if [ -z "$TMUX" ] &&  [ "$SSH_CLIENT" != "" ]; then
          exec ${pkgs.tmux}/bin/tmux
        fi
      '';
      shellAliases = {
        # Shortcuts for SSH
        "b" = "ssh -p 666 nico@89.58.13.188";
        "c" = "ssh -p 420 nico@89.58.13.188";
        "e" = "ssh nico@89.58.13.188";
        "g1" = "ssh -p 222 nico@65.108.140.36";
        "g2" = "ssh -p 226 nico@65.108.140.36";
        "g3" = "ssh -p 223 nico@65.108.140.36";
        "g4" = "ssh -p 224  nico@65.108.140.36";
        "g5" = "ssh -p 225  nico@65.108.140.36";
        "g6" = "ssh -p 226 nico@65.108.140.36";
        "g7" = "ssh -p 227  nico@65.108.140.36";
        "m" = "ssh -p 6969 nico@89.58.13.1886";
        "o" = "ssh nico@130.61.136.149";
        "w" = "ssh -p 6666 nico@89.58.13.188";
      };
    };

    # The better cat replacement
    bat = {
      enable = true;
      config = {theme = "gruvbox-dark";};
    };

    # Btop to view resource usage
    btop = {
      enable = true;
      settings = {
        color_theme = "gruvbox-dark";
        proc_tree = true;
        theme_background = false;
      };
    };

    # Exa as ls replacement
    exa = {
      enable = true;
      enableAliases = true;
    };

    # Fish shell
    fish = {
      enable = true;
      shellAbbrs = {
        # Shortcuts for SSH
        "b" = "ssh -p 666 nico@89.58.13.188";
        "c" = "ssh -p 420 nico@89.58.13.188";
        "e" = "ssh nico@89.58.13.188";
        "g1" = "ssh -p 222 nico@65.108.140.36";
        "g2" = "ssh -p 226 nico@65.108.140.36";
        "g3" = "ssh -p 223 nico@65.108.140.36";
        "g4" = "ssh -p 224  nico@65.108.140.36";
        "g5" = "ssh -p 225  nico@65.108.140.36";
        "g6" = "ssh -p 226 nico@65.108.140.36";
        "g7" = "ssh -p 227  nico@65.108.140.36";
        "m" = "ssh -p 6969 nico@89.58.13.1886";
        "o" = "ssh nico@130.61.136.14";
        "w" = "ssh -p 6666 nico@89.58.13.188";
      };
      shellInit = ''
        # Functions to allow repeating previous command with !!
        function __history_previous_command
          switch (commandline -t)
          case "!"
            commandline -t $history[1]; commandline -f repaint
          case "*"
            commandline -i !
          end
        end
        function _history_previous_command_arguments
          switch (commandline -t)
          case "!"
            commandline -t ""
            commandline -f history-token-search-backward
          case "*"
            commandline -i '$'
          end
        end

        # Actually bind the keys
        bind ! __history_previous_command
        bind '$' __history_previous_command_arguments

        # Fish command history
        function history
          builtin history --show-time='%F %T '
        end
      '';
    };

    # The starship prompt
    starship = {
      enable = true;
      settings = {
        username = {
          format = " [$user]($style)@";
          show_always = true;
          style_root = "bold red";
          style_user = "bold red";
        };
        hostname = {
          disabled = false;
          format = "[$hostname]($style) in ";
          ssh_only = false;
          style = "bold dimmed red";
          trim_at = "-";
        };
        scan_timeout = 10;
        directory = {
          style = "purple";
          truncate_to_repo = true;
          truncation_length = 0;
          truncation_symbol = "repo: ";
        };
        status = {
          disabled = false;
          map_symbol = true;
        };
        sudo = {disabled = false;};
        cmd_duration = {
          disabled = false;
          format = "took [$duration]($style)";
          min_time = 1;
        };
      };
    };

    # Easy terminal tabbing
    tmux = {
      baseIndex = 1;
      clock24 = true;
      enable = true;
      extraConfig = ''
        set-option -ga terminal-overrides ",*256col*:Tc,alacritty:Tc"
      '';
      historyLimit = 10000;
      newSession = true;
      sensibleOnTop = false;
      shell = "${pkgs.fish}/bin/fish";
    };
  };
}
