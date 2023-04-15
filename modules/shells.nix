{ config
, lib
, pkgs
, ...
}:
with lib;
let
  cfg = config.dr460nixed.shells;
in
{
  options.dr460nixed.shells.enable = lib.mkOption
    {
      default = true;
      type = types.bool;
      description = lib.mdDoc ''
        Whether the shell should receive our aliases and themes.
      '';
    };

  config = mkIf cfg.enable {
    # Use micro as editor
    environment.sessionVariables = {
      EDITOR = "${pkgs.micro}/bin/micro";
      VISUAL = "${pkgs.micro}/bin/micro";
    };

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
          fastfetch -l nixos --load-config neofetch
        '';
      };
    };
  };
}
