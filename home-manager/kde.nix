{
  pkgs,
  inputs,
  ...
}:
let
  immutable = false;

  configDir = ".config";
  kvantumDir = ".config/Kvantum";
  localDir = ".local/share";

  # JamesDSP Dolby presets
  jamesdsp = inputs.self.drLib.jamesdsp pkgs;
in
{
  # Theme our desktop launchers
  imports = [ ./theme-launchers.nix ];

  # Compatibility for GNOME apps
  dconf.enable = true;

  # Auto-start a few tray apps
  systemd.user.services = {
    jamesdsp = {
      Unit = {
        Description = "JamesDSP daemon";
        Requires = [ "dbus.service" ];
        After = [ "graphical-session-pre.target" ];
        PartOf = [
          "graphical-session.target"
          "pipewire.service"
        ];
      };
      Install.WantedBy = [ "graphical-session.target" ];
      Service = {
        ExecStart = "${pkgs.jamesdsp}/bin/jamesdsp --tray";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };

  # Enable Kvantum theme and GTK & place a few bigger   files
  home.file =
    if immutable then
      {
        "${configDir}/autostart/org.telegram.desktop".text = ''
          [Desktop Entry]
          Exec=${pkgs.tdesktop}/bin/telegram-desktop -autostart
          Icon=telegram
          Name=Telegram Desktop
          SingleMainWindow=true
          StartupWMClass=TelegramDesktop
          Terminal=false
          Type=Application
        '';
        "${configDir}/baloofilerc".text = ''
          [General]
          exclude filters=*~,*.part,*.o,*.la,*.lo,*.loT,*.moc,moc_*.cpp,qrc_*.cpp,ui_*.h,cmake_install.cmake,CMakeCache.txt,CTestTestfile.cmake,libtool,config.status,confdefs.h,autom4te,conftest,confstat,Makefile.am,*.gcode,.ninja_deps,.ninja_log,build.ninja,*.csproj,*.m4,*.rej,*.gmo,*.pc,*.omf,*.aux,*.tmp,*.po,*.vm*,*.nvram,*.rcore,*.swp,*.swap,lzo,litmain.sh,*.orig,.histfile.*,.xsession-errors*,*.map,*.so,*.a,*.db,*.qrc,*.ini,*.init,*.img,*.vdi,*.vbox*,vbox.log,*.qcow2,*.vmdk,*.vhd,*.vhdx,*.sql,*.sql.gz,*.ytdl,*.class,*.pyc,*.pyo,*.elc,*.qmlc,*.jsc,*.fastq,*.fq,*.gb,*.fasta,*.fna,*.gbff,*.faa,po,CVS,.svn,.git,_darcs,.bzr,.hg,CMakeFiles,CMakeTmp,CMakeTmpQmake,.moc,.obj,.pch,.uic,.npm,.yarn,.yarn-cache,__pycache__,node_modules,node_packages,nbproject,core-dumps,lost+found
          only basic indexing=true
        '';
        "${configDir}/dolphinrc".source = ./kde-static/dolphinrc;
        "${configDir}/jamesdsp/irs/game.irs".source = jamesdsp.game;
        "${configDir}/jamesdsp/irs/movie.irs".source = jamesdsp.movie;
        "${configDir}/jamesdsp/irs/music.irs".source = jamesdsp.music;
        "${configDir}/jamesdsp/irs/voice.irs".source = jamesdsp.voice;
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

          [NightColor]
          Active=true

          [Effect-blur]
          NoiseStrength=0

          [Effect-wobblywindows]
          Drag=85
          Stiffness=10
          WobblynessLevel=1

          [Plugins]
          blurEnabled=true
          squashEnabled=false
          magiclampEnabled=true
          wobblywindowsEnabled=true

          [TabBox]
          LayoutName=coverswitch

          [Windows]
          BorderlessMaximizedWindows=true

          [Xwayland]
          Scale=1

          [org.kde.kdecoration2]
          BorderSizeAuto=false
          ButtonsOnLeft=XAI
          ButtonsOnRight=
        '';
        "${configDir}/plasma-localerc".text = ''
          [Formats]
          LANG=en_GB.UTF-8
        '';
        "${configDir}/plasmarc".text = ''
          [Theme]
          name=Sweet

          [Wallpapers]
          usersWallpapers=/usr/share/wallpapers/
        '';
        "${configDir}/spectaclerc".text = ''
          [General]
          autoSaveImage=true
          clipboardGroup=PostScreenshotCopyImage
          onLaunchAction=DoNotTakeScreenshot
          useReleaseToCapture=true
        '';
        "${configDir}/startkderc".text = ''
          [General]
          systemdBoot=true
        '';
        "${configDir}/touchpadrc".text = ''
          [parameters]
          InvertVertScroll=true
          InvertHorizScroll=true
          OneFingerTapButton=LeftButton
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
      }
    else
      {
        "${configDir}/jamesdsp/irs/game.irs".source = jamesdsp.game;
        "${configDir}/jamesdsp/irs/movie.irs".source = jamesdsp.movie;
        "${configDir}/jamesdsp/irs/music.irs".source = jamesdsp.music;
        "${configDir}/jamesdsp/irs/voice.irs".source = jamesdsp.voice;
        "${configDir}/plasma-workspace/env/10-env.sh".text = ''
          #!/run/current-system/sw/bin/dash
          export ENV_CLEANED=1
          QT_PLUGIN_PATH_MOD="$(echo $QT_PLUGIN_PATH | tr ':' '\n' | grep "/" | awk '!x[$0]++' | head -c -1 | tr '\n' ':')"
          XDG_DATA_DIRS_MOD="$(echo $XDG_DATA_DIRS | tr ':' '\n' | grep "/" | awk '!x[$0]++' | head -c -1 | tr '\n' ':')"
          XDG_CONFIG_DIRS_MOD="$(echo $XDG_CONFIG_DIRS | tr ':' '\n' | grep "/" | awk '!x[$0]++' | head -c -1 | tr '\n' ':')"
          export QT_PLUGIN_PATH=$QT_PLUGIN_PATH_MOD
          export XDG_DATA_DIRS=$XDG_DATA_DIRS_MOD
          export XDG_CONFIG_DIRS=$XDG_CONFIG_DIRS_MOD
        '';
        "${localDir}/user-places.xbel".source = ./kde-static/user-places.xbel;
      };

  home.sessionVariables = {
    QML_FORCE_DISK_CACHE = "1";
  };
}
