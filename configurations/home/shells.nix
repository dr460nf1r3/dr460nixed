let
  immortalis = "116.202.208.112";
in
{
  # SSH shortcuts
  programs = {
    bash.shellAliases = {
      "c" = "mosh nico@100.108.204.61";
      "g" = "mosh nico@100.75.73.33";
      "g1" = "ssh -p 666 nico@${immortalis}";
      "g2" = "ssh nico@${immortalis}";
      "g3" = "ssh -p 223 nico@${immortalis}";
      "g4" = "ssh -p 224 nico@${immortalis}";
      "g5" = "ssh -p 225 nico@${immortalis}";
      "g6" = "ssh -p 226 nico@${immortalis}";
      "g7" = "ssh -p 227 nico@${immortalis}";
      "g8" = "ssh -p 222 nico@${immortalis}";
      "g9" = "ssh -p 229 nico@${immortalis} -L 5432:127.0.0.1:5432";
      "m" = "mosh nico@100.109.201.47";
      "o" = "mosh nico@100.86.102.115";
      "w" = "mosh nico@100.64.127.121";
    };
    fish.shellAbbrs = {
      "c" = "mosh nico@100.108.204.61";
      "g" = "mosh nico@100.75.73.33";
      "g1" = "ssh -p 666 nico@${immortalis}";
      "g2" = "ssh nico@${immortalis}";
      "g3" = "ssh -p 223 nico@${immortalis}";
      "g4" = "ssh -p 224 nico@${immortalis}";
      "g5" = "ssh -p 225 nico@${immortalis}";
      "g6" = "ssh -p 226 nico@${immortalis}";
      "g7" = "ssh -p 227 nico@${immortalis}";
      "g8" = "ssh -p 222 nico@${immortalis}";
      "g9" = "ssh -p 229 nico@${immortalis} -L 5432:127.0.0.1:5432";
      "m" = "mosh nico@100.109.201.47";
      "o" = "mosh nico@100.86.102.115";
      "w" = "mosh nico@100.64.127.121";
    };
  };
}
