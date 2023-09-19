{pkgs, ...}:
with builtins; let
  appdir = ".local/share/applications";
  configDir = ".config";

  # JamesDSP Dolby presets
  game = fetchurl {
    url = "https://cloud.garudalinux.org/s/eimgmWmN485tHGw/download/game.irs";
    sha256 = "0d1lfbzca6wqfqxd6knzshc00khhgfqmk36s5xf1wyh703sdxk79";
  };
  movie = fetchurl {
    url = "https://cloud.garudalinux.org/s/K8CpHZYTiLyXLSd/download/movie.irs";
    sha256 = "1r3s8crbmvzm71yqrkp8d8x4xyd3najz82ck6vbh1v9kq6jclc0w";
  };
  music = fetchurl {
    url = "https://cloud.garudalinux.org/s/cbPLFeAMeJazKxC/download/music-balanced.irs";
    sha256 = "1szssbqk3dnaqhg3syrzq9zqfb18phph5yy5m3xfnjgllj2yphy0";
  };
  voice = fetchurl {
    url = "https://cloud.garudalinux.org/s/wJSs9gckrNidTBo/download/voice.irs";
    sha256 = "1b643m8v7j15ixi2g6r2909vwkq05wi74ybccbdnp4rkms640y4w";
  };
in {
  # Theme our desktop launchers
  imports = [./theme-launchers.nix];

  # Compatibility for GNOME apps
  dconf.enable = true;

  # Enable Kvantum theme and GTK & place a few bigger files
  home.file = {
    "${appdir}/btop.desktop".text = ''
      [Desktop Entry]
      Categories=System;Monitor;ConsoleOnly;
      Comment=Resource monitor that shows usage and stats for processor, memory, disks, network and processes
      Exec=${pkgs.btop}/bin/btop
      GenericName=System Monitor
      Icon=org.kde.resourcesMonitor
      Keywords=system;process;task
      Name=btop++
      NoDisplay=false
      Path=
      StartupNotify=true
      Terminal=true
      TerminalOptions=
      Type=Application
      Version=1.0
      X-KDE-SubstituteUID=false
      X-KDE-Username=
    '';
    "${appdir}/fish.desktop".text = ''
      [Desktop Entry]
      Categories=ConsoleOnly;System;
      Comment=The user-friendly command line shell
      Exec=${pkgs.fish}/bin/fish
      Icon=fish
      Name=Fish
      NoDisplay=false
      Path=
      StartupNotify=true
      Terminal=true
      TerminalOptions=
      Type=Application
      Version=1.0
      X-KDE-SubstituteUID=false
      X-KDE-Username=
    '';
    "${appdir}/micro.desktop".text = ''
      [Desktop Entry]
      Categories=Utility;TextEditor;Development;
      Comment=Edit text files in a terminal
      Exec=${pkgs.micro}/bin/micro %F
      GenericName=Text Editor
      Icon=text-editor
      Keywords=text;editor;syntax;terminal;
      MimeType=text/plain;text/x-chdr;text/x-csrc;text/x-c++hdr;text/x-c++src;text/x-java;text/x-dsrc;text/x-pascal;text/x-perl;text/x-python;application/x-php;application/x-httpd-php3;application/x-httpd-php4;application/x-httpd-php5;application/xml;text/html;text/css;text/x-sql;text/x-diff;
      Name=Micro
      NoDisplay=false
      Path=
      StartupNotify=false
      Terminal=true
      TerminalOptions=
      Type=Application
      X-KDE-SubstituteUID=false
      X-KDE-Username=
    '';
    "${configDir}/autostart/jdsp-gui.desktop".text = ''
      [Desktop Entry]
      Exec=${pkgs.jamesdsp}/bin/jamesdsp --tray
      Icon=jamesdsp
      Name=JamesDSP for Linux
      StartupNotify=false
      Terminal=false
      Type=Application
      X-KDE-autostart-after=panel
      X-KDE-autostart-phase=2
    '';
    "${configDir}/jamesdsp/irs/game.irs".source = game;
    "${configDir}/jamesdsp/irs/movie.irs".source = movie;
    "${configDir}/jamesdsp/irs/music.irs".source = music;
    "${configDir}/jamesdsp/irs/voice.irs".source = voice;
  };
}
