{
  lib,
  config,
  ...
}:
let
  cfg = config.dr460nixed.hm.shell;
  userCfg = config.dr460nixed.hm.user;
  defaultAliases = {
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
  defaultFishAbbrs = {
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
  defaultFishAliases = {
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
  userAliases = userCfg.shellAliases;
  userFishAbbrs = userCfg.fishAbbreviations;
in
{
  options.dr460nixed.hm.shell = {
    enable = lib.mkEnableOption "shell configuration and aliases";
  };

  config = lib.mkIf cfg.enable {
    programs.bash.shellAliases = defaultAliases // userAliases;

    programs.fish = {
      enable = true;
      shellAbbrs = defaultFishAbbrs // userFishAbbrs;
      shellAliases = defaultFishAliases;
      shellInit = ''
        set fish_greeting
      '';
    };

    programs.starship.enable = true;
    programs.eza.enable = true;
  };
}
