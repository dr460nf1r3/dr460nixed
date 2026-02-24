{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.dr460nixed.hm.shell;
in
{
  options.dr460nixed.hm.shell = {
    enable = lib.mkEnableOption "shell configuration and aliases";
  };

  config = lib.mkIf cfg.enable {
    programs.bash.shellAliases = {
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

    programs.fish = {
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
        ${pkgs.fastfetch}/bin/fastfetch -L nixos --load-config config.jsonc
      '';
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    programs.eza = {
      enable = true;
      git = true;
      icons = true;
    };

    programs.starship = {
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
  };
}
