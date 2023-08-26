{ lib
, ...
}:
with builtins; let
  immutable = true;

  configDir = ".config";
  kvantumDir = ".config/Kvantum";
  localDir = ".local/share";

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
in
{
  # Theme our desktop launchers
  imports = [ ./theme-launchers.nix ];

  # Compatibility for GNOME apps
  dconf.enable = true;

  # Enable Kvantum theme and GTK & place a few bigger files
  home.file = lib.mkIf immutable {
    "${configDir}/autostart/nextcloud-client.desktop".text = ''
      [Desktop Entry]
      Exec=nextcloud --background
      Icon=Nextcloud
      Name=Nextcloud
      StartupNotify=false
      Terminal=false
      Type=Application
    '';
    "${configDir}/autostart/syncthingtray.desktop".text = ''
      [Desktop Entry]
      Exec=syncthingtray
      Icon=syncthingtray
      Name=Syncthing Tray
      Terminal=false
      Type=Application
    '';

    "${configDir}/baloofilerc".text = ''
      [General]
      exclude filters=*~,*.part,*.o,*.la,*.lo,*.loT,*.moc,moc_*.cpp,qrc_*.cpp,ui_*.h,cmake_install.cmake,CMakeCache.txt,CTestTestfile.cmake,libtool,config.status,confdefs.h,autom4te,conftest,confstat,Makefile.am,*.gcode,.ninja_deps,.ninja_log,build.ninja,*.csproj,*.m4,*.rej,*.gmo,*.pc,*.omf,*.aux,*.tmp,*.po,*.vm*,*.nvram,*.rcore,*.swp,*.swap,lzo,litmain.sh,*.orig,.histfile.*,.xsession-errors*,*.map,*.so,*.a,*.db,*.qrc,*.ini,*.init,*.img,*.vdi,*.vbox*,vbox.log,*.qcow2,*.vmdk,*.vhd,*.vhdx,*.sql,*.sql.gz,*.ytdl,*.class,*.pyc,*.pyo,*.elc,*.qmlc,*.jsc,*.fastq,*.fq,*.gb,*.fasta,*.fna,*.gbff,*.faa,po,CVS,.svn,.git,_darcs,.bzr,.hg,CMakeFiles,CMakeTmp,CMakeTmpQmake,.moc,.obj,.pch,.uic,.npm,.yarn,.yarn-cache,__pycache__,node_modules,node_packages,nbproject,core-dumps,lost+found
      only basic indexing=true
    '';
    "${configDir}/dolphinrc".source = ./kde-static/dolphinrc;
    "${configDir}/jamesdsp/irs/game.irs".source = game;
    "${configDir}/jamesdsp/irs/movie.irs".source = movie;
    "${configDir}/jamesdsp/irs/music.irs".source = music;
    "${configDir}/jamesdsp/irs/voice.irs".source = voice;
    "${configDir}/gtk-3.0/colors.css".source = ./kde-static/gtk-3.0/colors.css;
    "${configDir}/gtk-3.0/gtk.css".text = ''
      @import 'colors.css';
    '';
    "${configDir}/gtk-3.0/settings.ini".source = ./kde-static/gtk-3.0/settings.ini;
    "${configDir}/gtk-4.0/colors.css".source = ./kde-static/gtk-4.0/colors.css;
    "${configDir}/gtk-4.0/gtk.css".text = ''
      @import 'colors.css';
    '';
    "${configDir}/gtk-4.0/settings.ini".source = ./kde-static/gtk-4.0/settings.ini;
    "${configDir}/kactivitymanagerdrc".text = ''
      [activities]
      a73843f1-cb8a-4315-9fc2-4990d798e827=Default

      [main]
      currentActivity=a73843f1-cb8a-4315-9fc2-4990d798e827
    '';
    "${configDir}/kcminputrc".text = ''
      [Keyboard]
      KeyRepeat=repeat
      NumLock=0
      RepeatDelay=600
      RepeatRate=25

      [Mouse]
      X11LibInputXAccelProfileFlat=false
      cursorTheme=Sweet-cursors
    '';
    "${configDir}/kded5rc".source = ./kde-static/kded5rc;
    "${configDir}/kdeglobals".source = ./kde-static/kdeglobals;
    "${configDir}/kgammarc".text = ''
      [ConfigFile]
      use=kgammarc
    '';
    "${configDir}/kiorc".text = ''
      [Confirmations]
      ConfirmEmptyTrash=false
    '';
    "${configDir}/kleopatrarc".text = ''
      [MainWindow]
      MenuBar=Disabled
      RestorePositionForNextInstance=false
      State=AAAA/wAAAAD9AAAAAAAABAAAAAGwAAAABAAAAAQAAAAIAAAACPwAAAABAAAAAgAAAAEAAAAWAG0AYQBpAG4AVABvAG8AbABCAGEAcgEAAAAA/////wAAAAAAAAAA
      ToolBarsMovable=Disabled
    '';
    "${configDir}/konsolerc".text = ''
      [Desktop Entry]
      DefaultProfile=Dr460nized.profile

      [General]
      ConfigVersion=1

      [KonsoleWindow]
      RememberWindowSize=false
      ShowMenuBarByDefault=false

      [MainWindow]
      MenuBar=Disabled
      State=AAAA/wAAAAD9AAAAAQAAAAAAAAAAAAAAAPwCAAAAAvsAAAAiAFEAdQBpAGMAawBDAG8AbQBtAGEAbgBkAHMARABvAGMAawAAAAAA/////wAAAWMA////+wAAABwAUwBTAEgATQBhAG4AYQBnAGUAcgBEAG8AYwBrAAAAAAD/////AAABAQD///8AAASkAAADCwAAAAQAAAAEAAAACAAAAAj8AAAAAQAAAAIAAAACAAAAFgBtAGEAaQBuAFQAbwBvAGwAQgBhAHIAAAAAAP////8AAAAAAAAAAAAAABwAcwBlAHMAcwBpAG8AbgBUAG8AbwBsAGIAYQByAAAAAAD/////AAAAAAAAAAA=
      StatusBar=Disabled
      ToolBarsMovable=Disabled

      [Notification Messages]
      ShowPasteHugeTextWarning=false
    '';
    "${configDir}/ktimezonedrc".text = ''
      [TimeZones]
      LocalZone=Europe/Berlin
      ZoneinfoDir=/etc/zoneinfo
      Zonetab=/etc/zoneinfo/zone.tab
    '';
    "${configDir}/kwalletrc".text = ''
      [Wallet]
      First Use=false
    '';
    "${configDir}/kwinrc".text = ''
      [Desktops]
      Id_1=3fc51d4c-1b38-4ddb-86b8-1811d01b9dbf
      Id_2=f1fd248b-991d-40c1-97f3-9a3cd41c0333
      Name_1=Desktop
      Name_2=Offscreen
      Number=2
      Rows=1

      [Effect-blur]
      NoiseStrength=0

      [Effect-wobblywindows]
      Drag=85
      Stiffness=10
      WobblynessLevel=1

      [NightColor]
      Active=true

      [Plugins]
      blurEnabled=true
      forceblurEnabled=true
      kwin4_effect_dimscreenEnabled=true
      kwin4_effect_eyeonscreenEnabled=true
      kwin4_effect_squashEnabled=false
      magiclampEnabled=true
      overviewEnabled=true
      wobblywindowsEnabled=true

      [Script-forceblur]
      blurExceptMatching=true
      blurMatching=false
      patterns=Peek

      [Windows]
      BorderlessMaximizedWindows=true

      [org.kde.kdecoration2]
      ButtonsOnLeft=XAI
      ButtonsOnRight=
      library=org.kde.kwin.aurorae
      theme=__aurorae__svg__Sweet-Dark
    '';
    "${configDir}/plasma-localerc".text = ''
      [Formats]
      LANG=en_US.UTF-8
    '';
    "${configDir}/plasmarc".text = ''
      [Theme]
      name=Dr460nized

      [Wallpapers]
      usersWallpapers=/usr/share/wallpapers/
    '';
    "${configDir}/spectaclerc".text = ''
      [General]
      autoSaveImage=true
      clipboardGroup=PostScreenshotCopyImage
      onLaunchAction=DoNotTakeScreenshot
      useReleaseToCapture=true

      [Save]
      defaultSaveLocation=file:///home/nico/Pictures/Screenshots/
    '';
    "${configDir}/startkderc".text = ''
      [General]
      systemdBoot=true
    '';
    "${configDir}/touchpadrc".text = ''
      [parameters]
      InvertHorizScroll=LeftButton
      InvertVertScroll=false
      OneFingerTapButton=true
      Tapping=true
      ThreeFingerTapButton=MiddleButton
      TwoFingerTapButton=RightButton
      VertEdgeScroll=true
    '';
    "${configDir}/touchpadxlibinputrc".text = ''
      [ELAN0634:00 04F3:3124 Touchpad]
      tapToClick=true

      [SynPS/2 Synaptics TouchPad]
      tapToClick=true
    '';
    "${kvantumDir}/kvantum.kvconfig".text = ''
      [General]
      theme=Sweet-transparent-toolbar
    '';
    "${localDir}/konsole/Dr460nized.profile".source = ./kde-static/Dr460nized.profile;
    "${localDir}/user-places.xbel".source = ./kde-static/user-places.xbel;
    ".gtkrc-2.0".source = ./kde-static/gtkrc-2.0;
  };
}
