{pkgs, ...}:
with builtins; let
  configDir = ".config";
  kvantumDir = ".config/Kvantum";
  localDir = ".local/share";

  # The Sweet Kvantum theme
  sweet-kvantum-theme = pkgs.stdenv.mkDerivation {
    name = "sweet-kvantum-theme";
    src = pkgs.fetchFromGitHub {
      owner = "EliverLara";
      repo = "Sweet";
      rev = "6cf0966616c20a877a3d3422ea4c482cc1fd9246";
      sha256 = "EXTz268tmtBcO47oxshOU9Vj3+JfSzbq4twJOMm5iH4=";
    };
    installPhase = ''
      mkdir $out
      cp kde/kvantum/Sweet-transparent-toolbar.kvconfig $out
      cp kde/kvantum/Sweet.svg $out/Sweet-transparent-toolbar.svg
    '';
  };

  wallpaper = builtins.fetchurl {
    url = "https://gitlab.com/garuda-linux/themes-and-settings/artwork/garuda-wallpapers/-/raw/master/src/garuda-wallpapers/Malefor.jpg";
    sha256 = "0r6b33k24kq4i3vzp41bxx7gqmw20klakcmw4qy7zana4f3pfnw6";
  };
in {
  # Compatibility for GNOME apps
  dconf.enable = true;

  # Enable Kvantum theme and GTK & place a few bigger files
  home.file = {
    "${configDir}/gtk-3.0/colors.css".source = ./kde-static/gtk-3.0/colors.css;
    "${configDir}/gtk-3.0/gtk.css".source = ./kde-static/gtk-3.0/gtk.css;
    "${configDir}/gtk-3.0/settings.ini".source = ./kde-static/gtk-3.0/settings.ini;
    "${configDir}/gtk-4.0/colors.css".source = ./kde-static/gtk-4.0/colors.css;
    "${configDir}/gtk-4.0/gtk.css".source = ./kde-static/gtk-4.0/gtk.css;
    "${configDir}/gtk-4.0/settings.ini".source = ./kde-static/gtk-4.0/settings.ini;
    "${configDir}/powermanagementprofilesrc".source = ./kde-static/powermanagementprofilesrc;
    "${configDir}/plasma-org.kde.plasma.desktop-appletsrc".source = ./kde-static/plasma-org.kde.plasma.desktop-appletsrc;
    "${kvantumDir}/Sweet-transparent-toolbar".source = sweet-kvantum-theme;
    "${kvantumDir}/kvantum.kvconfig".text = ''
      [General]
      theme=Sweet-transparent-toolbar
    '';
    "${localDir}/konsole/Dr460nized.profile".source = ./kde-static/Dr460nized.profile;
    "${localDir}/user-places.xbel".source = ./kde-static/user-places.xbel;
    "${localDir}/wallpapers/Malefor.jpg".source = wallpaper;
    ".gtkrc-2.0".source = ./kde-static/gtkrc-2.0;
  };

  # Plasma-manager configuration (most KDE -rc files)
  programs.plasma = {
    enable = true;
    shortcuts = {
      "KDE Keyboard Layout Switcher"."Switch to Next Keyboard Layout" = "Meta+Alt+K";
      "kaccess"."Toggle Screen Reader On and Off" = "Meta+Alt+S";
      "kcm_touchpad"."Disable Touchpad" = "Touchpad Off";
      "kcm_touchpad"."Enable Touchpad" = "Touchpad On";
      "kcm_touchpad"."Toggle Touchpad" = "Touchpad Toggle";
      "kded5"."Show System Activity" = "Ctrl+Esc";
      "kded5"."display" = ["Display" "Meta+P"];
      "kmix"."decrease_microphone_volume" = "Microphone Volume Down";
      "kmix"."decrease_volume" = "Volume Down";
      "kmix"."increase_microphone_volume" = "Microphone Volume Up";
      "kmix"."increase_volume" = "Volume Up";
      "kmix"."mic_mute" = ["Microphone Mute" "Meta+Volume Mute"];
      "kmix"."mute" = "Volume Mute";
      "ksmserver"."Lock Session" = ["Meta+L" "Screensaver"];
      "ksmserver"."Log Out" = "Ctrl+Alt+Del";
      "kwin"."Activate Window Demanding Attention" = "Meta+Ctrl+A";
      "kwin"."Edit Tiles" = "Meta+T";
      "kwin"."Expose" = "Ctrl+F9";
      "kwin"."ExposeAll" = ["Ctrl+F10" "Launch (C)"];
      "kwin"."ExposeClass" = "Ctrl+F7";
      "kwin"."Kill Window" = "Meta+Ctrl+Esc";
      "kwin"."MoveMouseToCenter" = "Meta+F6";
      "kwin"."MoveMouseToFocus" = "Meta+F5";
      "kwin"."Overview" = "Meta+W";
      "kwin"."Show Desktop" = "Meta+D";
      "kwin"."ShowDesktopGrid" = "Meta+F8";
      "kwin"."Suspend Compositing" = "Alt+Shift+F12";
      "kwin"."Switch Window Down" = "Meta+Alt+Down";
      "kwin"."Switch Window Left" = "Meta+Alt+Left";
      "kwin"."Switch Window Right" = "Meta+Alt+Right";
      "kwin"."Switch Window Up" = "Meta+Alt+Up";
      "kwin"."Switch to Desktop 1" = "Ctrl+F1";
      "kwin"."Walk Through Windows" = "Alt+Tab";
      "kwin"."Walk Through Windows of Current Application" = "Alt+`";
      "kwin"."Walk Through Windows of Current Application (Reverse)" = "Alt+~";
      "kwin"."Window One Desktop Down" = "Meta+Ctrl+Shift+Down";
      "kwin"."Window One Desktop Up" = "Meta+Ctrl+Shift+Up";
      "kwin"."Window One Desktop to the Left" = "Meta+Ctrl+Shift+Left";
      "kwin"."Window One Desktop to the Right" = "Meta+Ctrl+Shift+Right";
      "kwin"."Window to Next Screen" = "Meta+Shift+Right";
      "kwin"."Window to Previous Desktop" = [];
      "kwin"."Window to Previous Screen" = "Meta+Shift+Left";
      "kwin"."view_actual_size" = "Meta+0";
      "kwin"."view_zoom_in" = ["Meta++" "Meta+="];
      "kwin"."view_zoom_out" = "Meta+-";
      "mediacontrol"."mediavolumedown" = [];
      "mediacontrol"."mediavolumeup" = [];
      "mediacontrol"."nextmedia" = "Media Next";
      "mediacontrol"."pausemedia" = "Media Pause";
      "mediacontrol"."playmedia" = [];
      "mediacontrol"."playpausemedia" = "Media Play";
      "mediacontrol"."previousmedia" = "Media Previous";
      "mediacontrol"."stopmedia" = "Media Stop";
      "org.kde.dolphin.desktop"."_launch" = "Meta+E";
      "org.kde.krunner.desktop"."RunClipboard" = "Alt+Shift+F2";
      "org.kde.krunner.desktop"."_launch" = ["Alt+Space" "Alt+F2" "Search"];
      "org.kde.plasma.emojier.desktop"."_launch" = "Meta+.";
      "org.kde.spectacle.desktop"."ActiveWindowScreenShot" = "Meta+Print";
      "org.kde.spectacle.desktop"."CurrentMonitorScreenShot" = [];
      "org.kde.spectacle.desktop"."FullScreenScreenShot" = "Shift+Print";
      "org.kde.spectacle.desktop"."OpenWithoutScreenshot" = [];
      "org.kde.spectacle.desktop"."RectangularRegionScreenShot" = "Meta+Shift+Print";
      "org.kde.spectacle.desktop"."WindowUnderCursorScreenShot" = "Meta+Ctrl+Print";
      "org.kde.spectacle.desktop"."_launch" = "Print";
      "org_kde_powerdevil"."Decrease Keyboard Brightness" = "Keyboard Brightness Down";
      "org_kde_powerdevil"."Decrease Screen Brightness" = "Monitor Brightness Down";
      "org_kde_powerdevil"."Hibernate" = "Hibernate";
      "org_kde_powerdevil"."Increase Keyboard Brightness" = "Keyboard Brightness Up";
      "org_kde_powerdevil"."Increase Screen Brightness" = "Monitor Brightness Up";
      "org_kde_powerdevil"."PowerDown" = "Power Down";
      "org_kde_powerdevil"."PowerOff" = "Power Off";
      "org_kde_powerdevil"."Sleep" = "Sleep";
      "org_kde_powerdevil"."Toggle Keyboard Backlight" = "Keyboard Light On/Off";
      "org_kde_powerdevil"."Turn Off Screen" = [];
      "plasmashell"."activate task manager entry 1" = "Meta+1";
      "plasmashell"."activate task manager entry 10" = [];
      "plasmashell"."activate task manager entry 2" = "Meta+2";
      "plasmashell"."activate task manager entry 3" = "Meta+3";
      "plasmashell"."activate task manager entry 4" = "Meta+4";
      "plasmashell"."activate task manager entry 5" = "Meta+5";
      "plasmashell"."activate task manager entry 6" = "Meta+6";
      "plasmashell"."activate task manager entry 7" = "Meta+7";
      "plasmashell"."activate task manager entry 8" = "Meta+8";
      "plasmashell"."activate task manager entry 9" = "Meta+9";
      "plasmashell"."clear-history" = [];
      "plasmashell"."clipboard_action" = "Meta+Ctrl+X";
      "plasmashell"."cycle-panels" = "Meta+Alt+P";
      "plasmashell"."cycleNextAction" = [];
      "plasmashell"."cyclePrevAction" = [];
      "plasmashell"."edit_clipboard" = [];
      "plasmashell"."manage activities" = "Meta+Q";
      "plasmashell"."next activity" = "Meta+Tab";
      "plasmashell"."previous activity" = "Meta+Shift+Tab";
      "plasmashell"."repeat_action" = "Meta+Ctrl+R";
      "plasmashell"."show dashboard" = "Ctrl+F12";
      "plasmashell"."show-barcode" = [];
      "plasmashell"."show-on-mouse-pos" = "Meta+V";
      "plasmashell"."stop current activity" = "Meta+S";
      "plasmashell"."switch to next activity" = [];
      "plasmashell"."switch to previous activity" = [];
      "plasmashell"."toggle do not disturb" = [];
      "systemsettings.desktop"."_launch" = "Tools";
      "systemsettings.desktop"."kcm-kscreen" = [];
      "systemsettings.desktop"."kcm-lookandfeel" = [];
      "systemsettings.desktop"."kcm-users" = [];
      "systemsettings.desktop"."powerdevilprofilesconfig" = [];
      "systemsettings.desktop"."screenlocker" = [];
    };
    files = {
      "baloofilerc"."General"."exclude filters" = "*~,*.part,*.o,*.la,*.lo,*.loT,*.moc,moc_*.cpp,qrc_*.cpp,ui_*.h,cmake_install.cmake,CMakeCache.txt,CTestTestfile.cmake,libtool,config.status,confdefs.h,autom4te,conftest,confstat,Makefile.am,*.gcode,.ninja_deps,.ninja_log,build.ninja,*.csproj,*.m4,*.rej,*.gmo,*.pc,*.omf,*.aux,*.tmp,*.po,*.vm*,*.nvram,*.rcore,*.swp,*.swap,lzo,litmain.sh,*.orig,.histfile.*,.xsession-errors*,*.map,*.so,*.a,*.db,*.qrc,*.ini,*.init,*.img,*.vdi,*.vbox*,vbox.log,*.qcow2,*.vmdk,*.vhd,*.vhdx,*.sql,*.sql.gz,*.ytdl,*.class,*.pyc,*.pyo,*.elc,*.qmlc,*.jsc,*.fastq,*.fq,*.gb,*.fasta,*.fna,*.gbff,*.faa,po,CVS,.svn,.git,_darcs,.bzr,.hg,CMakeFiles,CMakeTmp,CMakeTmpQmake,.moc,.obj,.pch,.uic,.npm,.yarn,.yarn-cache,__pycache__,node_modules,node_packages,nbproject,core-dumps,lost+found";
      "baloofilerc"."General"."only basic indexing" = true;
      "dolphinrc"."ContextMenu"."ShowCopyMoveMenu" = true;
      "dolphinrc"."General"."AutoExpandFolders" = true;
      "dolphinrc"."General"."BrowseThroughArchives" = true;
      "dolphinrc"."General"."ShowFullPath" = true;
      "dolphinrc"."General"."ShowFullPathInTitlebar" = true;
      "dolphinrc"."General"."ShowToolTips" = true;
      "dolphinrc"."General"."ShowZoomSlider" = false;
      "dolphinrc"."KFileDialog Settings"."Places Icons Auto-resize" = false;
      "dolphinrc"."KFileDialog Settings"."Places Icons Static Size" = 22;
      "dolphinrc"."Notification Messages"."ConfirmEmptyTrash" = true;
      "dolphinrc"."PreviewSettings"."Plugins" = "audiothumbnail,blenderthumbnail,comicbookthumbnail,djvuthumbnail,ebookthumbnail,exrthumbnail,directorythumbnail,fontthumbnail,imagethumbnail,jpegthumbnail,kraorathumbnail,windowsexethumbnail,windowsimagethumbnail,mobithumbnail,opendocumentthumbnail,gsthumbnail,rawthumbnail,svgthumbnail,ffmpegthumbs";
      "dolphinrc"."VersionControl"."enabledPlugins" = "Git";
      "kactivitymanagerdrc"."activities"."a73843f1-cb8a-4315-9fc2-4990d798e827" = "Default";
      "kactivitymanagerdrc"."main"."currentActivity" = "a73843f1-cb8a-4315-9fc2-4990d798e827";
      "kcminputrc"."Keyboard"."KeyRepeat" = "repeat";
      "kcminputrc"."Keyboard"."NumLock" = 0;
      "kcminputrc"."Keyboard"."RepeatDelay" = 600;
      "kcminputrc"."Keyboard"."RepeatRate" = 25;
      "kcminputrc"."Mouse"."X11LibInputXAccelProfileFlat" = false;
      "kcminputrc"."Mouse"."cursorTheme" = "Sweet-cursors";
      "kded5rc"."Module-device_automounter"."autoload" = true;
      "kdeglobals"."General"."BrowserApplication" = "firefox.desktop";
      "kdeglobals"."General"."XftHintStyle" = "hintslight";
      "kdeglobals"."General"."XftSubPixel" = "none";
      "kdeglobals"."General"."fixed" = "FiraCode Nerd Font Mono,10,-1,5,50,0,0,0,0,0";
      "kdeglobals"."General"."font" = "Fira Sans,10,-1,5,50,0,0,0,0,0";
      "kdeglobals"."General"."menuFont" = "Fira Sans,10,-1,5,50,0,0,0,0,0";
      "kdeglobals"."General"."smallestReadableFont" = "Fira Sans,10,-1,5,50,0,0,0,0,0";
      "kdeglobals"."General"."toolBarFont" = "Fira Sans,10,-1,5,50,0,0,0,0,0";
      "kdeglobals"."KDE"."SingleClick" = true;
      "kdeglobals"."KDE"."widgetStyle" = "kvantum-dark";
      "kdeglobals"."KFileDialog Settings"."Allow Expansion" = false;
      "kdeglobals"."KFileDialog Settings"."Automatically select filename extension" = true;
      "kdeglobals"."KFileDialog Settings"."Breadcrumb Navigation" = true;
      "kdeglobals"."KFileDialog Settings"."Decoration position" = 2;
      "kdeglobals"."KFileDialog Settings"."LocationCombo Completionmode" = 5;
      "kdeglobals"."KFileDialog Settings"."PathCombo Completionmode" = 5;
      "kdeglobals"."KFileDialog Settings"."Show Bookmarks" = true;
      "kdeglobals"."KFileDialog Settings"."Show Full Path" = true;
      "kdeglobals"."KFileDialog Settings"."Show Inline Previews" = true;
      "kdeglobals"."KFileDialog Settings"."Show Speedbar" = true;
      "kdeglobals"."KFileDialog Settings"."Show hidden files" = true;
      "kdeglobals"."KFileDialog Settings"."Sort by" = "Name";
      "kdeglobals"."KFileDialog Settings"."Sort directories first" = true;
      "kdeglobals"."KFileDialog Settings"."Sort hidden files last" = false;
      "kdeglobals"."KFileDialog Settings"."Sort reversed" = false;
      "kdeglobals"."KFileDialog Settings"."View Style" = "DetailTree";
      "kdeglobals"."WM"."activeBackground" = "47,52,63";
      "kdeglobals"."WM"."activeBlend" = "47,52,63";
      "kdeglobals"."WM"."activeFont" = "Fira Sans,10,-1,5,75,0,0,0,0,0,Bold";
      "kdeglobals"."WM"."activeForeground" = "211,218,227";
      "kdeglobals"."WM"."inactiveBackground" = "47,52,63";
      "kdeglobals"."WM"."inactiveBlend" = "47,52,63";
      "kdeglobals"."WM"."inactiveForeground" = "102,106,115";
      "kgammarc"."ConfigFile"."use" = "kgammarc";
      "konsolerc"."Desktop Entry"."DefaultProfile" = "Dr460nized.profile";
      "konsolerc"."General"."ConfigVersion" = 1;
      "konsolerc"."KonsoleWindow"."RememberWindowSize" = false;
      "konsolerc"."KonsoleWindow"."ShowMenuBarByDefault" = false;
      "konsolerc"."MainWindow"."MenuBar" = "Disabled";
      "konsolerc"."MainWindow"."State" = "AAAA/wAAAAD9AAAAAQAAAAAAAAAAAAAAAPwCAAAAAvsAAAAiAFEAdQBpAGMAawBDAG8AbQBtAGEAbgBkAHMARABvAGMAawAAAAAA/////wAAAWMA////+wAAABwAUwBTAEgATQBhAG4AYQBnAGUAcgBEAG8AYwBrAAAAAAD/////AAABAQD///8AAASkAAADCwAAAAQAAAAEAAAACAAAAAj8AAAAAQAAAAIAAAACAAAAFgBtAGEAaQBuAFQAbwBvAGwAQgBhAHIAAAAAAP////8AAAAAAAAAAAAAABwAcwBlAHMAcwBpAG8AbgBUAG8AbwBsAGIAYQByAAAAAAD/////AAAAAAAAAAA=";
      "konsolerc"."MainWindow"."StatusBar" = "Disabled";
      "konsolerc"."Notification Messages"."ShowPasteHugeTextWarning" = false;
      "kscreenlockerrc"."Daemon"."LockGrace" = 60;
      "kscreenlockerrc"."Daemon"."Timeout" = 20;
      "kscreenlockerrc"."Greeter"."WallpaperPlugin" = "org.kde.image";
      "kscreenlockerrc"."Greeter.Wallpaper.org.kde.image.General"."Image" = "${localDir} /wallpapers/Malefor.jpg";
      "kwalletrc"."Wallet"."First Use" = false;
      "kwinrc"."Desktops"."Id_1" = "3fc51d4c-1b38-4ddb-86b8-1811d01b9dbf";
      "kwinrc"."Desktops"."Id_2" = "f1fd248b-991d-40c1-97f3-9a3cd41c0333";
      "kwinrc"."Desktops"."Name_1" = "Desktop";
      "kwinrc"."Desktops"."Name_2" = "Offscreen";
      "kwinrc"."Desktops"."Number" = 2;
      "kwinrc"."Desktops"."Rows" = 1;
      "kwinrc"."Effect-blur"."NoiseStrength" = 0;
      "kwinrc"."Effect-wobblywindows"."Drag" = 85;
      "kwinrc"."Effect-wobblywindows"."Stiffness" = 10;
      "kwinrc"."Effect-wobblywindows"."WobblynessLevel" = 1;
      "kwinrc"."NightColor"."Active" = true;
      "kwinrc"."Plugins"."blurEnabled" = true;
      "kwinrc"."Plugins"."forceblurEnabled" = true;
      "kwinrc"."Plugins"."kwin4_effect_dimscreenEnabled" = true;
      "kwinrc"."Plugins"."kwin4_effect_eyeonscreenEnabled" = true;
      "kwinrc"."Plugins"."kwin4_effect_squashEnabled" = false;
      "kwinrc"."Plugins"."magiclampEnabled" = true;
      "kwinrc"."Plugins"."overviewEnabled" = true;
      "kwinrc"."Plugins"."wobblywindowsEnabled" = true;
      "kwinrc"."Script-forceblur"."blurExceptMatching" = true;
      "kwinrc"."Script-forceblur"."blurMatching" = false;
      "kwinrc"."Script-forceblur"."patterns" = "Peek";
      "kwinrc"."Windows"."BorderlessMaximizedWindows" = true;
      "kwinrc"."org.kde.kdecoration2"."ButtonsOnLeft" = "XAI";
      "kwinrc"."org.kde.kdecoration2"."ButtonsOnRight" = "";
      "kwinrc"."Tiling"."padding" = 4;
      "plasma-localerc"."Formats"."LANG" = "en_US.UTF-8";
      "plasmarc"."Theme"."name" = "Dr460nized";
      "plasmarc"."Wallpapers"."usersWallpapers" = "/usr/share/wallpapers/";
      "spectaclerc"."General"."autoSaveImage" = true;
      "spectaclerc"."General"."clipboardGroup" = "PostScreenshotCopyImage";
      "spectaclerc"."General"."onLaunchAction" = "UseLastUsedCapturemode";
      "spectaclerc"."General"."useReleaseToCapture" = true;
      "spectaclerc"."Save"."defaultSaveLocation" = "file:///home/nico/Pictures/Screenshots/";
      "startkderc"."General"."systemdBoot" = true;
      "touchpadrc"."parameters"."InvertHorizScroll" = "LeftButton";
      "touchpadrc"."parameters"."InvertVertScroll" = true;
      "touchpadrc"."parameters"."OneFingerTapButton" = true;
      "touchpadrc"."parameters"."Tapping" = true;
      "touchpadrc"."parameters"."ThreeFingerTapButton" = "MiddleButton";
      "touchpadrc"."parameters"."TwoFingerTapButton" = "RightButton";
      "touchpadrc"."parameters"."VertEdgeScroll" = true;
      "touchpadxlibinputrc"."ELAN0634:00 04F3:3124 Touchpad"."tapToClick" = true;
    };
  };

  # KDE Portal for GTK apps
  home.sessionVariables = {
    GTK_USE_PORTAL = "1";
  };
}
