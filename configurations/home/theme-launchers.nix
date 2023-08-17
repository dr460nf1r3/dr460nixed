# To-do: eventually replace static files with Nix expressions, like
# desktopItems = [ (makeDesktopItem {
#   name = "rustdesk";
#   exec = meta.mainProgram;
#   icon = "rustdesk";
#   desktopName = "RustDesk";
#   comment = meta.description;
#   genericName = "Remote Desktop";
#   categories = ["Network"];
# }) ];

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
  home.file."${appdir}/chromium-gate.desktop".text = ''
    [Desktop Entry]
    Categories=Network;WebBrowser;
    Comment=Access the Internet
    Exec=chromium-gate %U
    GenericName[en_GB]=Web Browser
    GenericName=Web Browser
    Icon=chromium-gate
    MimeType=application/pdf;application/rdf+xml;application/rss+xml;application/xhtml+xml;application/xhtml_xml;application/xml;image/gif;image/jpeg;image/png;image/webp;text/html;text/xml;x-scheme-handler/http;x-scheme-handler/https;x-scheme-handler/webcal;x-scheme-handler/mailto;x-scheme-handler/about;x-scheme-handler/unknown
    Name=Chromium Gate
    NoDisplay=false
    Path=
    StartupNotify=true
    StartupWMClass=chromium-browser
    Terminal=false
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
  home.file."${appdir}/keybase.desktop".text = ''
    [Desktop Entry]
    Categories=Network;
    Comment=An Electron GUI for Keybase
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
  home.file."${appdir}/teams-for-linux.desktop".text = ''
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
  home.file."${appdir}/org.pipewire.Helvum.desktop".text = ''
    [Desktop Entry]
    Categories=AudioVideo;Audio;Video;Midi;Settings;GNOME;GTK;
    Comment=A patchbay for pipewire
    Exec=${pkgs.helvum}/bin/helvum
    GenericName=Patchbay
    Icon=gnome-sound-properties
    Name=Helvum
    NoDisplay=false
    Path=
    StartupNotify=true
    Terminal=false
    TerminalOptions=
    Type=Application
    X-KDE-SubstituteUID=false
    X-KDE-Username=
  '';
  home.file."${appdir}/startcenter.desktop".text = ''
    [Desktop Action Base]
    Exec=${pkgs.libreoffice-qt}/bin/soffice --base
    Name=Base

    [Desktop Action Calc]
    Exec=${pkgs.libreoffice-qt}/bin/soffice --calc
    Name=Calc

    [Desktop Action Draw]
    Exec=${pkgs.libreoffice-qt}/bin/soffice --draw
    Name=Draw

    [Desktop Action Impress]
    Exec=${pkgs.libreoffice-qt}/bin/soffice --impress
    Name=Impress

    [Desktop Action Math]
    Exec=${pkgs.libreoffice-qt}/bin/soffice --math
    Name=Math

    [Desktop Action Writer]
    Exec=${pkgs.libreoffice-qt}/bin/soffice --writer
    Name=Writer

    [Desktop Entry]
    Actions=Writer;Calc;Impress;Draw;Base;Math;
    Categories=Office;X-Red-Hat-Base;X-SuSE-Core-Office;
    Comment=Launch applications to create text documents, spreadsheets, presentations, drawings, formulas, and databases, or open recently used documents.
    Exec=${pkgs.libreoffice-qt}/bin/soffice %U
    GenericName[en_GB]=Office
    GenericName=Office
    Icon=org.libreoffice.LibreOffice-startcenter
    MimeType=application/vnd.openofficeorg.extension;x-scheme-handler/vnd.libreoffice.cmis;x-scheme-handler/vnd.sun.star.webdav;x-scheme-handler/vnd.sun.star.webdavs;x-scheme-handler/vnd.libreoffice.command;x-scheme-handler/ms-word;x-scheme-handler/ms-powerpoint;x-scheme-handler/ms-excel;x-scheme-handler/ms-visio;x-scheme-handler/ms-access;
    Name=LibreOffice
    NoDisplay=false
    StartupNotify=true
    StartupWMClass=libreoffice-startcenter
    Terminal=false
    Type=Application
    Version=1.0
    X-GIO-NoFuse=true
    X-KDE-Protocols=file,http,ftp,webdav,webdavs
    X-KDE-SubstituteUID=false
  '';
  home.file."${appdir}/math.desktop".text = ''
    [Desktop Action NewDocument]
    Exec=${pkgs.libreoffice-qt}/bin/soffice --math
    Icon=document-new
    Name[en_GB]=New Formula
    Name=New Formula

    [Desktop Entry]
    Actions=NewDocument;
    Categories=Office;Education;Science;Math;X-Red-Hat-Base;
    Comment=Create and edit scientific formulas and equations.
    Exec=${pkgs.libreoffice-qt}/bin/soffice --math %U
    GenericName[en_GB]=Formula Editor
    GenericName=Formula Editor
    Icon=org.libreoffice.LibreOffice.math
    InitialPreference=5
    Keywords=Equation;OpenDocument Formula;Formula;odf;MathML;
    MimeType=application/vnd.oasis.opendocument.formula;application/vnd.sun.xml.math;application/vnd.oasis.opendocument.formula-template;text/mathml;application/mathml+xml;
    Name=LibreOffice Math
    NoDisplay=false
    StartupNotify=true
    StartupWMClass=libreoffice-math
    Terminal=false
    Type=Application
    Version=1.0
    X-GIO-NoFuse=true
    X-KDE-Protocols=file,http,ftp,webdav,webdavs
    X-KDE-SubstituteUID=false
  '';
  home.file."${appdir}/impress.desktop".text = ''
    [Desktop Action NewDocument]
    Exec=${pkgs.libreoffice-qt}/bin/soffice --impress
    Icon=document-new
    Name[en_GB]=New Presentation
    Name=New Presentation

    [Desktop Entry]
    Actions=NewDocument;
    Categories=Office;Presentation;X-Red-Hat-Base;
    Comment=Create and edit presentations for slideshows, meetings and Web pages.
    Exec=${pkgs.libreoffice-qt}/bin/soffice --impress %U
    GenericName[en_GB]=Presentation
    GenericName=Presentation
    Icon=org.libreoffice.LibreOffice.impress
    InitialPreference=5
    Keywords=Slideshow;Slides;OpenDocument Presentation;Microsoft PowerPoint;Microsoft Works;OpenOffice Impress;odp;ppt;pptx;
    MimeType=application/vnd.oasis.opendocument.presentation;application/vnd.oasis.opendocument.presentation-template;application/vnd.sun.xml.impress;application/vnd.sun.xml.impress.template;application/mspowerpoint;application/vnd.ms-powerpoint;application/vnd.openxmlformats-officedocument.presentationml.presentation;application/vnd.ms-powerpoint.presentation.macroEnabled.12;application/vnd.openxmlformats-officedocument.presentationml.template;application/vnd.ms-powerpoint.template.macroEnabled.12;application/vnd.openxmlformats-officedocument.presentationml.slide;application/vnd.openxmlformats-officedocument.presentationml.slideshow;application/vnd.ms-powerpoint.slideshow.macroEnabled.12;application/vnd.oasis.opendocument.presentation-flat-xml;application/x-iwork-keynote-sffkey;application/vnd.apple.keynote;
    Name=LibreOffice Impress
    NoDisplay=false
    StartupNotify=true
    StartupWMClass=libreoffice-impress
    Terminal=false
    Type=Application
    Version=1.0
    X-GIO-NoFuse=true
    X-KDE-Protocols=file,http,ftp,webdav,webdavs
    X-KDE-SubstituteUID=false
  '';
  home.file."${appdir}/draw.desktop".text = ''
    [Desktop Action NewDocument]
    Exec=${pkgs.libreoffice-qt}/bin/soffice --draw
    Icon=document-new
    Name[en_GB]=New Drawing
    Name=New Drawing

    [Desktop Entry]
    Actions=NewDocument;
    Categories=Office;FlowChart;Graphics;2DGraphics;VectorGraphics;X-Red-Hat-Base;
    Comment=Create and edit drawings, flow charts and logos.
    Exec=${pkgs.libreoffice-qt}/bin/soffice --draw %U
    GenericName[en_GB]=Drawing Program
    GenericName=Drawing Program
    Icon=org.libreoffice.LibreOffice.draw
    InitialPreference=5
    Keywords=Vector;Schema;Diagram;Layout;OpenDocument Graphics;Microsoft Publisher;Microsoft Visio;Corel Draw;cdr;odg;svg;pdf;vsd;
    MimeType=application/vnd.oasis.opendocument.graphics;application/vnd.oasis.opendocument.graphics-flat-xml;application/vnd.oasis.opendocument.graphics-template;application/vnd.sun.xml.draw;application/vnd.sun.xml.draw.template;application/vnd.visio;application/x-wpg;application/vnd.corel-draw;application/vnd.ms-publisher;image/x-freehand;application/clarisworks;application/x-pagemaker;application/pdf;application/x-stardraw;image/x-emf;image/x-wmf;
    Name=LibreOffice Draw
    NoDisplay=false
    StartupNotify=true
    StartupWMClass=libreoffice-draw
    Terminal=false
    Type=Application
    Version=1.0
    X-GIO-NoFuse=true
    X-KDE-Protocols=file,http,ftp,webdav,webdavs
    X-KDE-SubstituteUID=false
  '';
  home.file."${appdir}/calc.desktop".text = ''
    [Desktop Action NewDocument]
    Exec=${pkgs.libreoffice-qt}/bin/soffice --calc
    Icon=document-new
    Name[en_GB]=New Spreadsheet
    Name=New Spreadsheet

    [Desktop Entry]
    Actions=NewDocument;
    Categories=Office;Spreadsheet;X-Red-Hat-Base;
    Comment=Perform calculations, analyze information and manage lists in spreadsheets.
    Exec=${pkgs.libreoffice-qt}/bin/soffice --calc %U
    GenericName[en_GB]=Spreadsheet
    GenericName=Spreadsheet
    Icon=org.libreoffice.LibreOffice.calc
    InitialPreference=5
    Keywords=Accounting;Stats;OpenDocument Spreadsheet;Chart;Microsoft Excel;Microsoft Works;OpenOffice Calc;ods;xls;xlsx;
    MimeType=application/vnd.oasis.opendocument.spreadsheet;application/vnd.oasis.opendocument.spreadsheet-template;application/vnd.sun.xml.calc;application/vnd.sun.xml.calc.template;application/msexcel;application/vnd.ms-excel;application/vnd.openxmlformats-officedocument.spreadsheetml.sheet;application/vnd.ms-excel.sheet.macroEnabled.12;application/vnd.openxmlformats-officedocument.spreadsheetml.template;application/vnd.ms-excel.template.macroEnabled.12;application/vnd.ms-excel.sheet.binary.macroEnabled.12;text/csv;application/x-dbf;text/spreadsheet;application/csv;application/excel;application/tab-separated-values;application/vnd.lotus-1-2-3;application/vnd.oasis.opendocument.chart;application/vnd.oasis.opendocument.chart-template;application/x-dbase;application/x-dos_ms_excel;application/x-excel;application/x-msexcel;application/x-ms-excel;application/x-quattropro;application/x-123;text/comma-separated-values;text/tab-separated-values;text/x-comma-separated-values;text/x-csv;application/vnd.oasis.opendocument.spreadsheet-flat-xml;application/vnd.ms-works;application/clarisworks;application/x-iwork-numbers-sffnumbers;application/vnd.apple.numbers;application/x-starcalc;
    Name=LibreOffice Calc
    NoDisplay=false
    StartupNotify=true
    StartupWMClass=libreoffice-calc
    Terminal=false
    Type=Application
    Version=1.0
    X-GIO-NoFuse=true
    X-KDE-Protocols=file,http,ftp,webdav,webdavs
    X-KDE-SubstituteUID=false
  '';
  home.file."${appdir}/base.desktop".text = ''
    [Desktop Action NewDocument]
    Exec=${pkgs.libreoffice-qt}/bin/soffice --base
    Icon=document-new
    Name[en_GB]=New Database
    Name=New Database

    [Desktop Entry]
    Actions=NewDocument;
    Categories=Office;Database;X-Red-Hat-Base;
    Comment=Manage databases, create queries and reports to track and manage your information.
    Exec=${pkgs.libreoffice-qt}/bin/soffice --base %U
    GenericName[en_GB]=Database Development
    GenericName=Database Development
    Icon=org.libreoffice.LibreOffice.base
    InitialPreference=5
    Keywords=Data;SQL;
    MimeType=application/vnd.oasis.opendocument.base;application/vnd.sun.xml.base;
    Name=LibreOffice Base
    NoDisplay=false
    StartupNotify=true
    StartupWMClass=libreoffice-base
    Terminal=false
    Type=Application
    Version=1.0
    X-GIO-NoFuse=true
    X-KDE-Protocols=file,http,ftp,webdav,webdavs
    X-KDE-SubstituteUID=false
  '';
  home.file."${appdir}/writer.desktop".text = ''
    [Desktop Action NewDocument]
    Exec=${pkgs.libreoffice-qt}/bin/soffice --writer
    Icon=document-new
    Name[en_GB]=New Document
    Name=New Document

    [Desktop Entry]
    Actions=NewDocument;
    Categories=Office;WordProcessor;X-Red-Hat-Base;
    Comment=Create and edit text and graphics in letters, reports, documents and Web pages.
    Exec=${pkgs.libreoffice-qt}/bin/soffice --writer %U
    GenericName[en_GB]=Word Processor
    GenericName=Word Processor
    Icon=org.libreoffice.LibreOffice-writer
    InitialPreference=5
    Keywords=Text;Letter;Fax;Document;OpenDocument Text;Microsoft Word;Microsoft Works;Lotus WordPro;OpenOffice Writer;CV;odt;doc;docx;rtf;
    MimeType=application/vnd.oasis.opendocument.text;application/vnd.oasis.opendocument.text-template;application/vnd.oasis.opendocument.text-web;application/vnd.oasis.opendocument.text-master;application/vnd.oasis.opendocument.text-master-template;application/vnd.sun.xml.writer;application/vnd.sun.xml.writer.template;application/vnd.sun.xml.writer.global;application/msword;application/vnd.ms-word;application/x-doc;application/x-hwp;application/rtf;text/rtf;application/vnd.wordperfect;application/wordperfect;application/vnd.lotus-wordpro;application/vnd.openxmlformats-officedocument.wordprocessingml.document;application/vnd.ms-word.document.macroEnabled.12;application/vnd.openxmlformats-officedocument.wordprocessingml.template;application/vnd.ms-word.template.macroEnabled.12;application/vnd.ms-works;application/vnd.stardivision.writer-global;application/x-extension-txt;application/x-t602;text/plain;application/vnd.oasis.opendocument.text-flat-xml;application/x-fictionbook+xml;application/macwriteii;application/x-aportisdoc;application/prs.plucker;application/vnd.palm;application/clarisworks;application/x-sony-bbeb;application/x-abiword;application/x-iwork-pages-sffpages;application/vnd.apple.pages;application/x-mswrite;application/x-starwriter;
    Name=LibreOffice Writer
    NoDisplay=false
    StartupNotify=true
    StartupWMClass=libreoffice-writer
    Terminal=false
    Type=Application
    Version=1.0
    X-GIO-NoFuse=true
    X-KDE-Protocols=file,http,ftp,webdav,webdavs
    X-KDE-SubstituteUID=false
  '';
}
