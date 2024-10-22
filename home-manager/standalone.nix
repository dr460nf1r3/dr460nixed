{
  lib,
  pkgs,
  ...
}: let
  configDir = ".config";

  # JamesDSP Dolby presets
  game = pkgs.fetchurl {
    url = "https://cloud.garudalinux.org/s/eimgmWmN485tHGw/download/game.irs";
    sha256 = "0d1lfbzca6wqfqxd6knzshc00khhgfqmk36s5xf1wyh703sdxk79";
  };
  movie = pkgs.fetchurl {
    url = "https://cloud.garudalinux.org/s/K8CpHZYTiLyXLSd/download/movie.irs";
    sha256 = "1r3s8crbmvzm71yqrkp8d8x4xyd3najz82ck6vbh1v9kq6jclc0w";
  };
  music = pkgs.fetchurl {
    url = "https://cloud.garudalinux.org/s/cbPLFeAMeJazKxC/download/music-balanced.irs";
    sha256 = "1szssbqk3dnaqhg3syrzq9zqfb18phph5yy5m3xfnjgllj2yphy0";
  };
  voice = pkgs.fetchurl {
    url = "https://cloud.garudalinux.org/s/wJSs9gckrNidTBo/download/voice.irs";
    sha256 = "1b643m8v7j15ixi2g6r2909vwkq05wi74ybccbdnp4rkms640y4w";
  };
in {
  # Import individual configuration snippets
  imports = [
    ./common.nix
    ./misc.nix
  ];
  # Enable Kvantum theme and GTK & place a few bigger files
  home.file = {
    "${configDir}/jamesdsp/irs/game.irs".source = game;
    "${configDir}/jamesdsp/irs/movie.irs".source = movie;
    "${configDir}/jamesdsp/irs/music.irs".source = music;
    "${configDir}/jamesdsp/irs/voice.irs".source = voice;
  };
  # Compatibility for GNOME apps
  dconf.enable = true;

  nixpkgs.config.allowUnfree = true;
  nix.package = pkgs.nixVersions.stable;

  nix.settings = {
    # Allow using flakes & automatically optimize the nix store
    auto-optimise-store = true;

    # Use available binary caches, this is not Gentoo
    # this also allows us to use remote builders to reduce build times and batter usage
    builders-use-substitutes = true;

    # Enable experimental features
    experimental-features = [
      "auto-allocate-uids"
      "flakes"
      "nix-command"
    ];
  };

  # Disable those as they are not needed in standalone
  services = {
    gpg-agent = {
      enableExtraSocket = lib.mkForce false;
      enableScDaemon = lib.mkForce false;
    };
    syncthing = {
      enable = lib.mkForce false;
    };
  };
  programs.mangohud.enable = lib.mkForce false;

  # Use micro as editor
  home.sessionVariables = {
    ALSOFT_DRIVERS = "pipewire";
    EDITOR = "micro";
    GTK_THEME = "Sweet-Dark";
    MOZ_USE_XINPUT2 = "1";
    QT_STYLE_OVERRIDE = "kvantum";
    SDL_AUDIODRIVER = "pipewire";
    VISUAL = "micro";
  };

  # Programs & global config
  programs = {
    bash.shellAliases = {
      ".." = "cd ..";
      "..." = "cd ../../";
      "...." = "cd ../../../";
      "....." = "cd ../../../../";
      "......" = "cd ../../../../../";
      "bat" = "bat --style header --style snip --style changes";
      "cat" = "bat --style header --style snip --style changes";
      "cls" = "clear";
      "dd" = "dd progress=status";
      "dir" = "dir --color=auto";
      "egrep" = "egrep --color=auto";
      "fastfetch" = "fastfetch -l nixos";
      "fgrep" = "fgrep --color=auto";
      "gcommit" = "git commit -m";
      "gitlog" = "git log --oneline --graph --decorate --all";
      "glcone" = "git clone";
      "gpr" = "git pull --rebase";
      "gpull" = "git pull";
      "gpush" = "git push";
      "ip" = "ip --color=auto";
      "jctl" = "journalctl -p 3 -xb";
      "psmem" = "ps auxf | sort -nr -k 4";
      "psmem10" = "ps auxf | sort -nr -k 4 | head -1";
      "su" = "sudo su -";
      "tarnow" = "tar acf ";
      "tree" = "eza --git --color always -T";
      "untar" = "tar zxvf ";
      "vdir" = "vdir --color=auto";
      "wget" = "wget -c";
    };

    # Direnv for per-directory environment variables
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    # Eza for a better ls
    eza = {
      enable = true;
      git = true;
      icons = true;
    };

    # The fish shell, default for terminals
    fish = {
      enable = true;
      shellAbbrs = {
        ".." = "cd ..";
        "..." = "cd ../../";
        "...." = "cd ../../../";
        "....." = "cd ../../../../";
        "......" = "cd ../../../../../";
        "cls" = "clear";
        "diffnix" = "nvd diff $(sh -c 'ls -d1v /nix/var/nix/profiles/system-*-link|tail -n 2')";
        "edit" = "sops";
        "gcommit" = "git commit -m";
        "glcone" = "git clone";
        "gpr" = "git pull --rebase";
        "gpull" = "git pull";
        "gpush" = "git push";
        "reb" = " sudo nixos-rebuild switch -L";
        "roll" = "sudo nixos-rebuild switch --rollback";
        "run" = "nix run nixpkgs#";
        "su" = "sudo su -";
        "tarnow" = "tar acf ";
        "test" = "sudo nixos-rebuild switch --test";
        "tree" = "eza --git --color always -T";
        "untar" = "tar zxvf ";
        "use" = "nix shell nixpkgs#";
      };
      shellAliases = {
        "bat" = "bat --style header --style snip --style changes";
        "cat" = "bat --style header --style snip --style changes";
        "dd" = "dd progress=status";
        "diffnix" = "nvd diff $(sh -c 'ls -d1v /nix/var/nix/profiles/system-*-link|tail -n 2')";
        "dir" = "dir --color=auto";
        "egrep" = "egrep --color=auto";
        "fastfetch" = "fastfetch -l nixos";
        "fgrep" = "fgrep --color=auto";
        "gitlog" = "git log --oneline --graph --decorate --all";
        "ip" = "ip --color=auto";
        "jctl" = "journalctl -p 3 -xb";
        "psmem" = "ps auxf | sort -nr -k 4";
        "psmem10" = "ps auxf | sort -nr -k 4 | head -1";
        "vdir" = "vdir --color=auto";
        "wget" = "wget -c";
      };
      shellInit = ''
        set fish_greeting
        ${pkgs.fastfetch}/bin/fastfetch -L nixos --load-config paleofetch.jsonc
      '';
    };

    # This is needed to make use of the home-manager
    home-manager.enable = true;

    # Nix index for faster search
    nix-index.enable = true;

    # The starship prompt
    starship = {
      enable = true;
      settings = {
        cmd_duration = {
          disabled = false;
          format = "took [$duration]($style)";
          min_time = 1;
        };
        directory = {
          style = "purple";
          truncate_to_repo = true;
          truncation_length = 0;
          truncation_symbol = "repo: ";
        };
        hostname = {
          disabled = false;
          format = "[$hostname]($style) in ";
          ssh_only = false;
          style = "bold dimmed red";
          trim_at = "-";
        };
        scan_timeout = 10;
        status = {
          disabled = false;
          map_symbol = true;
        };
        sudo.disabled = false;
        username = {
          format = " [$user]($style)@";
          show_always = true;
          style_root = "bold red";
          style_user = "bold red";
        };
      };
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
    };
  };

  # Only CLI apps
  home.packages = with pkgs; [
    age
    alejandra
    ansible
    appimage-run
    asciinema
    bind
    bind.dnsutils
    btop
    cached-nix-shell
    cloudflared
    deadnix
    duf
    eza
    gh
    heroku
    hugo
    jq
    killall
    manix
    micro
    mongodb-compass
    mosh
    nerdctl
    nettools
    nix-prefetch-git
    nixd
    nixos-generators
    nixpkgs-lint
    nixpkgs-review
    nmap
    nodePackages_latest.prettier
    nodejs
    nvd
    ruff
    shellcheck
    shfmt
    sops
    sqlite
    statix
    tldr
    tmux
    traceroute
    ugrep
    ventoy-full
    vulnix
    wget
    whois
    yarn
  ];

  # Don't change this
  home = {
    homeDirectory = "/home/nico";
    stateVersion = "23.11";
    username = "nico";
  };
}
