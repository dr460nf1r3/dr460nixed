{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.dr460nixed.shells;
in
{
  options.dr460nixed.shells = {
    enable = mkEnableOption "Basic shell aliases";
  };

  config = mkIf cfg.enable {
    # Use micro as editor
    environment.sessionVariables = {
      EDITOR = "${pkgs.micro}/bin/micro";
      VISUAL = "${pkgs.micro}/bin/micro";
    };

    # These are the packages I always want in a shell
    environment.systemPackages = with pkgs; [
      age
      bind
      bitwarden-cli
      btop
      cached-nix-shell
      cachix
      cloudflared
      colmena
      curl
      direnv
      duf
      exa
      home-manager
      jq
      killall
      micro
      nettools
      nmap
      nur.repos.federicoschonborn.fastfetch
      python3
      sops
      tldr
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
        "ls" = "exa -al --color=always --group-directories-first --icons";
        "micro" = "micro -colorscheme geany -autosu true -mkparents true";
        "psmem" = "ps auxf | sort -nr -k 4";
        "psmem10" = "ps auxf | sort -nr -k 4 | head -1";
        "su" = "sudo su -";
        "tarnow" = "tar acf ";
        "untar" = "tar zxvf ";
        "vdir" = "vdir --color=auto";
        "wget" = "wget -c";
      };
      command-not-found.enable = false;
      fish = {
        enable = true;
        vendor = {
          config.enable = true;
          completions.enable = true;
        };
        shellAbbrs = {
          "cls" = "clear";
          "edit" = "sops";
          "gcommit" = "git commit -m";
          "glcone" = "git clone";
          "gpr" = "git pull --rebase";
          "gpull" = "git pull";
          "gpush" = "git push";
          "reb" = " sudo nixos-rebuild switch -L";
          "roll" = "sudo nixos-rebuild switch --rollback";
          "su" = "sudo su -";
          "use" = "nix shell nixpkgs#";
          "tarnow" = "tar acf ";
          "test" = "sudo nixos-rebuild switch --test";
          "untar" = "tar zxvf ";
        };
        shellAliases = {
          "bat" = "bat --style header --style snip --style changes";
          "dd" = "dd progress=status";
          "dir" = "dir --color=auto";
          "egrep" = "egrep --color=auto";
          "fastfetch" = "fastfetch -l nixos";
          "fgrep" = "fgrep --color=auto";
          "gitlog" = "git log --oneline --graph --decorate --all";
          "ip" = "ip --color=auto";
          "jctl" = "journalctl -p 3 -xb";
          "ls" = "exa -al --color=always --group-directories-first --icons";
          "micro" = "micro -colorscheme geany -autosu true -mkparents true";
          "psmem" = "ps auxf | sort -nr -k 4";
          "psmem10" = "ps auxf | sort -nr -k 4 | head -1";
          "vdir" = "vdir --color=auto";
          "wget" = "wget -c";
        };
        shellInit = ''
          set fish_greeting
          fastfetch --load-config neofetch
        '';
      };
    };
  };
}
