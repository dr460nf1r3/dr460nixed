{pkgs, ...}: let
  appdir = ".local/share/applications";
in {
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
