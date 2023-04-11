{ pkgs, ... }:
let
  appdir = ".local/share/applications";
in
{
  # All of these either have no BeautyLine icon or their description sucks
  home.file."${appdir}/com.borgbase.Vorta.desktop".text = ''
    [Desktop Entry]
    Categories=Utility;Archiving;Qt;
    Comment=
    Exec=${pkgs.vorta}/bin/vorta
    GenericName=Backup Software
    Icon=org.kde.kbackup
    Keywords=borg;
    Name=Vorta
    NoDisplay=false
    Path=
    StartupNotify=true
    StartupWMClass=vorta
    Terminal=false
    TerminalOptions=
    Type=Application
    X-KDE-SubstituteUID=false
    X-KDE-Username=
  '';
  home.file."${appdir}/btop.desktop".text = ''
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
  home.file."${appdir}/fish.desktop".text = ''
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
  home.file."${appdir}/com.yubico.authenticator.desktop".text = ''
    [Desktop Entry]
    Categories=Utility;
    Comment=
    Exec=${pkgs.yubioath-flutter}/bin/yubioath-flutter
    GenericName=Yubico Authenticator
    Icon=keysmith
    Keywords=Yubico;Authenticator;
    Name=Yubico Authenticator
    NoDisplay=false
    Path=
    StartupNotify=true
    Terminal=false
    TerminalOptions=
    Type=Application
    X-KDE-SubstituteUID=false
    X-KDE-Username=
  '';
  home.file."${appdir}/keybase.desktop".text = ''
    [Desktop Entry]
    Categories=Network;
    Comment=
    Exec=${pkgs.keybase}/bin/keybase-gui %u
    Icon=keyring-manager
    MimeType=x-scheme-handler/web+stellar;x-scheme-handler/keybase;application/x-saltpack;
    Name=Keybase
    NoDisplay=false
    Path=
    StartupNotify=false
    Terminal=false
    TerminalOptions=
    Type=Application
    X-KDE-SubstituteUID=false
    X-KDE-Username=
  '';
  home.file."${appdir}/zenmonitor.desktop".text = ''
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
  home.file."${appdir}/gimp.desktop".text = ''
    [Desktop Entry]
    Categories=Graphics;2DGraphics;RasterGraphics;GTK;
    Comment=Create images and edit photographs
    Exec=${pkgs.gimp}/bin/gimp-2.10 %U
    GenericName=Image Editor
    Icon=gimp
    Keywords=GIMP;graphic;design;illustration;painting;
    MimeType=image/bmp;image/g3fax;image/gif;image/x-fits;image/x-pcx;image/x-portable-anymap;image/x-portable-bitmap;image/x-portable-graymap;image/x-portable-pixmap;image/x-psd;image/x-sgi;image/x-tga;image/x-xbitmap;image/x-xwindowdump;image/x-xcf;image/x-compressed-xcf;image/x-gimp-gbr;image/x-gimp-pat;image/x-gimp-gih;image/x-sun-raster;image/tiff;image/jpeg;image/x-psp;application/postscript;image/png;image/x-icon;image/x-xpixmap;image/x-exr;image/webp;image/x-webp;image/heif;image/heic;image/avif;image/jxl;image/svg+xml;application/pdf;image/x-wmf;image/jp2;image/x-xcursor;
    Name=GIMP
    NoDisplay=false
    Path=
    StartupNotify=true
    Terminal=false
    TerminalOptions=
    TryExec=gimp-2.10
    Type=Application
    Version=1.0
    X-KDE-SubstituteUID=false
    X-KDE-Username=
  '';
  home.file."${appdir}/micro.desktop".text = ''
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
}

