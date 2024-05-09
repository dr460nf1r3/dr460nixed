{
  lib,
  pkgs,
  ...
}: {
  # Import common configurations
  imports = [
    ../modules/nix.nix
    ../modules/shells.nix
  ];

  # WSL flake settings
  wsl = {
    # NixOS specific settings
    defaultUser = "nico";
    enable = true;
    interop.register = true;
    nativeSystemd = true;
    startMenuLaunchers = true;

    # Enable integration with Docker Desktop (needs to be installed)
    docker-desktop.enable = true;

    # Generic WSL settings
    wslConf = {
      automount.root = "/mnt";
      network.generateResolvConf = false;
    };
  };

  # Required by nixos-wsl
  networking.nftables.enable = lib.mkForce false;

  # Suppress warning about this one having no effect
  # we ship adblocking capabilities here usually
  networking.extraHosts = lib.mkForce '''';

  # Use the newer Docker 24
  virtualisation = {
    docker = {
      autoPrune = {
        enable = true;
        flags = ["--all"];
      };
      enable = true;
      enableOnBoot = false;
    };
  };

  # Use micro as editor
  environment.sessionVariables = {
    EDITOR = "${pkgs.micro}/bin/micro";
    VISUAL = "${pkgs.micro}/bin/micro";
  };

  # Often needed apps
  environment.systemPackages = with pkgs; [
    age
    alejandra
    ansible
    asciinema
    bat
    bind
    btop
    cachix
    cloudflared
    curl
    deadnix
    duf
    eza
    fastfetch
    git
    htop
    jq
    killall
    manix
    micro
    mosh
    nettools
    nixos-generators
    nmap
    nvd
    python3
    rsync
    screen
    shellcheck
    shfmt
    sops
    tldr
    tmux
    traceroute
    ugrep
    wget
    whois
  ];

  # Programs & global config
  programs = {
    bash.shellAliases = {
      # General useful things & theming
      "bat" = "bat --style header --style snip --style changes";
      "cat" = "bat --style header --style snip --style changes";
      "dd" = "dd progress=status";
      "dir" = "dir --color=auto";
      "fastfetch" = "fastfetch -l nixos";
      "ip" = "ip --color=auto";
      "jctl" = "journalctl -p 3 -xb";
      "ls" = "eza -al --color=always --group-directories-first --icons";
      "micro" = "micro -colorscheme geany -autosu true -mkparents true";
      "su" = "sudo su -";
      "tarnow" = "tar acf ";
      "untar" = "tar zxvf ";
      "wget" = "wget -c";
    };
    fish = {
      enable = true;
      vendor = {
        completions.enable = true;
        config.enable = true;
      };
      shellAbbrs = {
        "su" = "sudo su -";
        "tarnow" = "tar acf ";
        "test" = "sudo nixos-rebuild switch --test";
        "untar" = "tar zxvf ";
      };
      shellAliases = {
        "bat" = "bat --style header --style snip --style changes";
        "cat" = "bat --style header --style snip --style changes";
        "dd" = "dd progress=status";
        "dir" = "dir --color=auto";
        "fastfetch" = "fastfetch -l nixos";
        "gitlog" = "git log --oneline --graph --decorate --all";
        "ip" = "ip --color=auto";
        "jctl" = "journalctl -p 3 -xb";
        "ls" = "eza -al --color=always --group-directories-first --icons";
        "micro" = "micro -colorscheme geany -autosu true -mkparents true";
        "wget" = "wget -c";
      };
      shellInit = ''
        set fish_greeting
        fastfetch -l nixos --load-config neofetch
      '';
    };
  };

  # NixOS stuff
  system.stateVersion = "23.11";
}
