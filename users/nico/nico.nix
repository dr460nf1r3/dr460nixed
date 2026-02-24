{ lib, ... }:
let
  forwardPostgres = "-L 5433:127.0.0.1:5432";
  hetznerStoragebox = "your-storagebox.de";
  immortalis = "immortalis.kanyu-bushi.ts.net";
  user = "nico";
in
{
  # Import individual configuration snippets
  imports = [
    ./email.nix
    ../../home-manager
  ];

  dr460nixed.hm = {
    common.enable = true;
    git = {
      enable = true;
      userEmail = "root@dr460nf1r3.org";
      userName = "Nico Jensch";
      signingKey = "D245D484F3578CB17FD6DA6B67DB29BFF3C96757";
    };
    shell.enable = true;
  };

  # I'm working with git a lot
  programs = {
    # Bash receives aliases
    bash = {
      shellAliases = {
        "b1" = "ssh -p23 u342919@u342919.${hetznerStoragebox}";
        "b2" = "ssh -p23 u358867@u358867.${hetznerStoragebox}";
        "c" = "ssh -p666 ${user}@cup-dragon";
        "g1" = "ssh -p666 ${user}@${immortalis}";
        "g2" = "ssh ${user}@${immortalis}";
        "g3" = "ssh -p1022 ${user}@216.158.66.108";
        "g4" = "ssh -p224 ${user}@${immortalis}";
        "g5" = "ssh -p225 ${user}@${immortalis}";
        "g6" = "ssh -p226 ${user}@${immortalis}";
        "g7" = "ssh -p227 ${user}@116.202.208.112";
        "g8" = "ssh -p222 ${user}@${immortalis}";
        "g9" = "ssh -p229 ${user}@${immortalis} ${forwardPostgres}";
      };
    };
    # Fish receives auto-expanding abbreviations (much cooler!)
    fish = {
      shellAbbrs = {
        "b1" = "ssh -p23 u342919@u342919.${hetznerStoragebox}";
        "b2" = "ssh -p23 u358867@u358867.${hetznerStoragebox}";
        "c" = "ssh -p666 ${user}@cup-dragon";
        "g1" = "ssh -p666 ${user}@${immortalis}";
        "g2" = "ssh ${user}@${immortalis}";
        "g3" = "ssh -p1022 ${user}@216.158.66.108";
        "g4" = "ssh -p224 ${user}@${immortalis}";
        "g5" = "ssh -p225 ${user}@${immortalis}";
        "g6" = "ssh -p226 ${user}@${immortalis}";
        "g7" = "ssh -p227 ${user}@116.202.208.112";
        "g8" = "ssh -p222 ${user}@${immortalis}";
        "g9" = "ssh -p229 ${user}@${immortalis} ${forwardPostgres}";
      };
    };
  };

  home.stateVersion = lib.mkForce "26.05";
}
