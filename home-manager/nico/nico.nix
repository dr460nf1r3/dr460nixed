{pkgs, ...}: let
  appdir = ".local/share/applications";
in {
  # Import individual configuration snippets
  imports = [
    ./email.nix
    ./shells.nix
  ];

  # I'm working with git a lot
  programs.git = {
    signing = {
      key = "D245D484F3578CB17FD6DA6B67DB29BFF3C96757";
      signByDefault = true;
    };
    userEmail = "root@dr460nf1r3.org";
    userName = "Nico Jensch";
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
