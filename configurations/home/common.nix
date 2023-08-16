{ pkgs, ... }: {
  # Import individual configuration snippets
  imports = [ ./shells.nix ];

  # Always needed home-manager settings - don't touch!
  home.homeDirectory = "/home/nico";
  home.stateVersion = "22.11";
  home.username = "nico";

  # I'm working with git a lot
  programs.git = {
    diff-so-fancy.enable = true;
    enable = true;
    extraConfig = {
      core = { editor = "micro"; };
      init = { defaultBranch = "main"; };
      pull = { rebase = true; };
    };
    signing = {
      key = "D245D484F3578CB17FD6DA6B67DB29BFF3C96757";
      signByDefault = true;
    };
    userEmail = "root@dr460nf1r3.org";
    userName = "Nico Jensch";
  };

  # GPG for signing commits mostly
  programs.gpg = {
    enable = true;
    settings = {
      cert-digest-algo = "SHA512";
      charset = "utf-8";
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
      fixed-list-mode = true;
      keyid-format = "0xlong";
      list-options = "show-uid-validity";
      no-comments = true;
      no-emit-version = true;
      no-greeting = true;
      no-symkey-cache = true;
      personal-cipher-preferences = "AES256 AES192 AES";
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
      personal-digest-preferences = "SHA512 SHA384 SHA256";
      require-cross-certification = true;
      s2k-cipher-algo = "AES256";
      s2k-digest-algo = "SHA512";
      throw-keyids = true;
      verify-options = "show-uid-validity";
      with-fingerprint = true;
    };
  };

  # Invididual terminal app configs
  programs = {
    # Common Bash aliases & tmux autostart
    bash = {
      enable = true;
      initExtra = ''
        if [ -z "$TMUX" ] &&  [ "$SSH_CLIENT" != "" ]; then
          exec ${pkgs.tmux}/bin/tmux a || exec /usr/bin/tmux a
        fi
      '';
    };

    # The better cat replacement
    bat = {
      enable = true;
      config.theme = "GitHub";
    };

    # Btop to view resource usage
    btop = {
      enable = true;
      settings = {
        color_theme = "TTY";
        proc_tree = false;
        theme_background = false;
      };
    };

    # Direnv for per-directory environment variables
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # Exa as ls replacement
    exa = {
      enable = true;
      enableAliases = true;
    };

    # Fish shell
    fish.enable = true;

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
        sudo = { disabled = false; };
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
      historyLimit = 10000;
      newSession = true;
      sensibleOnTop = false;
      shell = "${pkgs.fish}/bin/fish";
    };
  };

  # Always use configured caches
  home.file = {
    ".config/nix/nix.conf".text = ''
      substituters = https://cache.nixos.org https://chaotic-nyx.cachix.org https://dr460nf1r3.cachix.org
      trusted-public-keys = chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8= dr460nf1r3.cachix.org-1:eLI/ymdDmYKBwwSNuA0l6zvfDZuZfh0OECGKzuv8xvU= 
    '';
    ".local/share/nix/trusted-settings.json".text = ''
      substituters = https://cache.nixos.org https://chaotic-nyx.cachix.org https://dr460nf1r3.cachix.org
      trusted-public-keys = chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8= dr460nf1r3.cachix.org-1:eLI/ymdDmYKBwwSNuA0l6zvfDZuZfh0OECGKzuv8xvU= 
    '';
  };

  # Enable dircolors
  programs.dircolors.enable = true;

  # Disable manpages
  manual.manpages.enable = false;
}
