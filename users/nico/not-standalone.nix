{ pkgs, ... }:
let
  appdir = ".local/share/applications";
in
{
  # The apps themes not everyone might want
  home.file = {
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
