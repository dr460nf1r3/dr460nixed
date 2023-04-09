{ lib
, pkgs
, ...
}:
with builtins; let
  configDir = ".config";
  kvantumDir = ".config/Kvantum";
  localDir = ".local/share";

  # JamesDSP Dolby presets
  game = builtins.fetchurl {
    url = https://cloud.garudalinux.org/s/eimgmWmN485tHGw/download/game.irs;
    sha256 = "0d1lfbzca6wqfqxd6knzshc00khhgfqmk36s5xf1wyh703sdxk79";
  };
  movie = builtins.fetchurl {
    url = https://cloud.garudalinux.org/s/K8CpHZYTiLyXLSd/download/movie.irs;
    sha256 = "1r3s8crbmvzm71yqrkp8d8x4xyd3najz82ck6vbh1v9kq6jclc0w";
  };
  music = builtins.fetchurl {
    url = https://cloud.garudalinux.org/s/cbPLFeAMeJazKxC/download/music-balanced.irs;
    sha256 = "1szssbqk3dnaqhg3syrzq9zqfb18phph5yy5m3xfnjgllj2yphy0";
  };
  voice = builtins.fetchurl {
    url = https://cloud.garudalinux.org/s/wJSs9gckrNidTBo/download/voice.irs;
    sha256 = "1b643m8v7j15ixi2g6r2909vwkq05wi74ybccbdnp4rkms640y4w";
  };

  # The allmighty Malefor wallpaper
  wallpaper = builtins.fetchurl {
    url = "https://gitlab.com/garuda-linux/themes-and-settings/artwork/garuda-wallpapers/-/raw/master/src/garuda-wallpapers/Malefor.jpg";
    sha256 = "0r6b33k24kq4i3vzp41bxx7gqmw20klakcmw4qy7zana4f3pfnw6";
  };
in
{
  # Compatibility for GNOME apps
  dconf.enable = true;

  # Disable GTK target for Stylix as we supply KDE built files
  stylix.targets.gtk.enable = false;

  # Enable Kvantum theme and GTK & place a few bigger files
  home.file = {
    "${configDir}/autostart/nextcloud-client.desktop".text = ''
      [Desktop Entry]
      Name=Nextcloud
      Exec=nextcloud --background
      Terminal=false
      Icon=Nextcloud
      StartupNotify=false
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
    "${configDir}/kded5rc".text = ''
      [Module-device_automounter]
      autoload=true
    '';
    "${configDir}/kdeglobals".source = ./kde-static/kdeglobals;
    "${configDir}/kgammarc".text = ''
      [ConfigFile]
      use=kgammarc
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
    "${configDir}/kscreenlockerrc".text = ''
      [Daemon]
      LockGrace=60
      Timeout=20

      [Greeter]
      WallpaperPlugin=org.kde.image

      [Greeter][Wallpaper][org][kde][image][General]
      Image=/home/nico/.local/share/wallpapers/Malefor.jpg
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
    "${configDir}/plasma-org.kde.plasma.desktop-appletsrc".source = ./kde-static/plasma-org.kde.plasma.desktop-appletsrc;
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
      onLaunchAction=UseLastUsedCapturemode
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
    "${localDir}/wallpapers/Malefor.jpg".source = wallpaper;
    ".gtkrc-2.0".source = ./kde-static/gtkrc-2.0;
  };

  # A systemd user unit for JamesDSP
  systemd.user.services.jamesdsp = {
    Unit = {
      Description = "JamesDSP daemon";
      Requires = [ "dbus.service" ];
      After = [ "graphical-session-pre.target" ];
      PartOf = [ "graphical-session.target" "pipewire.service" ];
    };

    Install.WantedBy = [ "graphical-session.target" ];

    Service = {
      ExecStart = "${pkgs.jamesdsp}/bin/jamesdsp --tray";
      ExecStop = "${pkgs.killall}/bin/killall jamesdsp";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };

  # KDE Portal for GTK apps
  home.sessionVariables = {
    GTK_USE_PORTAL = "1";
  };
}
