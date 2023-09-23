{pkgs, ...}: let
  appdir = ".local/share/applications";
  forwardPostgres = "-L 5432:127.0.0.1:5432";
  hetznerStoragebox = "your-storagebox.de";
  immortalis = "immortalis.kanyu-bushi.ts.net";
  user = "nico";
in {
  # Import individual configuration snippets
  imports = [./email.nix];

  # I'm working with git a lot
  programs = {
    # Bash receives aliases
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
    # Fish receives auto-expanding abbreviations (much cooler!)
    fish = {
      enable = true;
      shellAbbrs = {
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
    git = {
      signing = {
        key = "D245D484F3578CB17FD6DA6B67DB29BFF3C96757";
        signByDefault = true;
      };
      userEmail = "root@dr460nf1r3.org";
      userName = "Nico Jensch";
    };
  };

  # The apps themes not everyone might want
  home.file = {
    "${appdir}/teams-for-linux.desktop".text = ''
      [Desktop Entry]
      Categories=Network;InstantMessaging;Chat
      Comment=Unofficial Microsoft Teams client for Linux
      Exec=${pkgs.teams-for-linux}/bin/teams-for-linux
      Icon=teams-for-linux
      Name=Microsoft Teams
      NoDisplay=false
      Path=
      StartupNotify=true
      Terminal=false
      TerminalOptions=
      Type=Application
      Version=1.4
      X-KDE-SubstituteUID=false
      X-KDE-Username=
    '';
    "${appdir}/zenmonitor.desktop".text = ''
      [Desktop Entry]
      Categories=GTK;System;
      Comment=Monitoring software for AMD Zen-based CPUs
      Exec=${pkgs.zenmonitor}/bin/zenmonitor
      Icon=aptik-battery-monitor
      Keywords=CPU;AMD;zen;system;core;speed;clock;temperature;voltage;
      Name=Zenmonitor
      NoDisplay=false
      Path=
      StartupNotify=true
      Terminal=false
      TerminalOptions=
      Type=Application
      X-KDE-SubstituteUID=false
      X-KDE-Username=
    '';
  };
}
