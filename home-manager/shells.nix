let
  immortalis = "immortalis.kanyu-bushi.ts.net";
  hetznerStoragebox = "your-storagebox.de";
  forwardPostgres = "-L 5432:127.0.0.1:5432";
  user = "nico";
in
{
  # SSH shortcuts
  programs = {
    bash.shellAliases = {
      "b1" = "ssh -p23 u342919@u342919.${hetznerStoragebox}";
      "b2" = "ssh -p23 u358867@u358867.${hetznerStoragebox}";
      "g" = "mosh ${user}@google-dragon.emperor-mercat.ts.net";
      "g1" = "ssh -p 666 ${user}@${immortalis}";
      "g2" = "ssh ${user}@${immortalis}";
      "g3" = "ssh -p 223 ${user}@${immortalis}";
      "g4" = "ssh -p 224 ${user}@${immortalis}";
      "g5" = "ssh -p 225 ${user}@${immortalis}";
      "g6" = "ssh -p 226 ${user}@${immortalis}";
      "g7" = "ssh -p 227 ${user}@${immortalis}";
      "g8" = "ssh -p 222 ${user}@${immortalis}";
      "g9" = "ssh -p 229 ${user}@${immortalis} ${forwardPostgres}";
      "m" = "mosh ${user}@garuda-mail.kanyu-bushi.ts.net";
      "o" = "mosh ${user}@oracle-dragon.emperor-mercat.ts.net";
    };
    fish.shellAbbrs = {
      "b1" = "ssh -p23 u342919@u342919.${hetznerStoragebox}";
      "b2" = "ssh -p23 u358867@u358867.${hetznerStoragebox}";
      "g" = "mosh ${user}@google-dragon.emperor-mercat.ts.net";
      "g1" = "ssh -p 666 ${user}@${immortalis}";
      "g2" = "ssh ${user}@${immortalis}";
      "g3" = "ssh -p 223 ${user}@${immortalis}";
      "g4" = "ssh -p 224 ${user}@${immortalis}";
      "g5" = "ssh -p 225 ${user}@${immortalis}";
      "g6" = "ssh -p 226 ${user}@${immortalis}";
      "g7" = "ssh -p 227 ${user}@${immortalis}";
      "g8" = "ssh -p 222 ${user}@${immortalis}";
      "g9" = "ssh -p 229 ${user}@${immortalis} ${forwardPostgres}";
      "m" = "mosh ${user}@garuda-mail.kanyu-bushi.ts.net";
      "o" = "mosh ${user}@oracle-dragon.emperor-mercat.ts.net";
    };
  };
}
