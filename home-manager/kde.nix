{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
let
  cfg = config.dr460nixed.hm.kde;
  configDir = ".config";
  localDir = ".local/share";
  jamesdsp = inputs.self.dragonLib.jamesdsp pkgs;
in
{
  options.dr460nixed.hm.kde = {
    enable = lib.mkEnableOption "KDE Plasma Home Manager configuration";
  };

  config = lib.mkIf cfg.enable {
    dconf.enable = true;

    qt.kde.settings = {
      kdeglobals = {
        General = {
          BrowserApplication = "brave-browser.desktop";
          XftAntialias = true;
          XftHintStyle = "hintslight";
          XftSubPixel = "none";
          fixed = "JetBrainsMonoNL Nerd Font,10,-1,5,400,0,0,0,0,0,0,0,0,0,0,1";
          font = "Inter,10,-1,5,700,0,0,0,0,0,0,0,0,0,0,1,Bold";
          menuFont = "Inter,10,-1,5,700,0,0,0,0,0,0,0,0,0,0,1,Bold";
          smallestReadableFont = "Inter,8,-1,5,700,0,0,0,0,0,0,0,0,0,0,1,Bold";
          toolBarFont = "Inter,10,-1,5,700,0,0,0,0,0,0,0,0,0,0,1,Bold";
        };
        Icons = {
          Theme = "Papirus-Dark";
        };
        KDE = {
          LookAndFeelPackage = "Catppuccin-Mocha-Mauve";
          SingleClick = true;
          widgetStyle = "Breeze";
        };
        "KFileDialog Settings" = {
          "Allow Expansion" = false;
          "Automatically select filename extension" = true;
          "Breadcrumb Navigation" = true;
          "Decoration position" = 2;
          "Show Full Path" = false;
          "Show Inline Previews" = true;
          "Show Preview" = false;
          "Show Speedbar" = true;
          "Show hidden files" = false;
          "Sort by" = "Name";
          "Sort directories first" = true;
          "Sort hidden files last" = false;
          "Sort reversed" = false;
          "Speedbar Width" = 115;
          "View Style" = "DetailTree";
        };
        WM = {
          activeBackground = "30,30,46";
          activeBlend = "205,214,244";
          activeFont = "Inter,10,-1,5,800,0,0,0,0,0,0,0,0,0,0,1,ExtraBold";
          activeForeground = "205,214,244";
          inactiveBackground = "17,17,27";
          inactiveBlend = "166,173,200";
          inactiveForeground = "166,173,200";
        };
      };
      katerc = {
        General = {
          "Allow Tab Scrolling" = true;
          "Auto Hide Tabs" = false;
          "Close After Last" = false;
          "Close documents with window" = true;
          "Open New Tab To The Right Of Current" = false;
          "Restore Window Configuration" = true;
          "Save Meta Infos" = true;
          "Show Menu Bar" = true;
          "Show Status Bar" = true;
          "Show Symbol In Navigation Bar" = true;
          "Show Tab Bar" = true;
          "Show Tabs Close Button" = true;
          "Show Url Nav Bar" = true;
          "Tab Double Click New Document" = true;
          "Tab Middle Click Close Document" = true;
        };
        "KTextEditor Renderer" = {
          "Animate Bracket Matching" = false;
          "Auto Color Theme Selection" = true;
          "Color Theme" = "Catppuccin Mocha";
          "Text Font" = "Jetbrains Mono NF,10,-1,7,400,0,0,0,0,0,0,0,0,0,0,1";
        };
        lspclient = {
          AutoHover = true;
          AutoImport = true;
          Diagnostics = true;
          Messages = true;
          SignatureHelp = true;
          SymbolTree = true;
        };
      };
      konsolerc = {
        "Desktop Entry" = {
          DefaultProfile = "Catppuccin.profile";
        };
        KonsoleWindow = {
          ShowMenuBarByDefault = false;
        };
        MainWindow = {
          MenuBar = "Disabled";
          StatusBar = "Disabled";
        };
      };
      "plasma-localerc" = {
        Formats = {
          LANG = "en_GB.UTF-8";
        };
      };
      kded5rc = {
        "Module-device_automounter" = {
          autoload = false;
        };
        "Module-freespacenotifier" = {
          autoload = false;
        };
        "Module-printmanager" = {
          autoload = false;
        };
        "Module-remotenotifier" = {
          autoload = false;
        };
        "Module-smbwatcher" = {
          autoload = false;
        };
      };
      spectaclerc = {
        ImageSave = {
          translatedScreenshotsFolder = "Screenshots";
        };
        VideoSave = {
          translatedScreencastsFolder = "Screencasts";
        };
      };
      breezerc = {
        Common = {
          OutlineIntensity = "OutlineMedium";
          RoundedCorners = true;
        };
      };
      kxkbrc = {
        Layout = {
          LayoutList = "de";
          Use = true;
        };
      };
      kscreenlockerrc = {
        Daemon = {
          Autolock = true;
          LockGrace = 60;
          Timeout = 20;
        };
        "Greeter" = {
          "Wallpaper" = {
            "org.kde.image" = {
              "General" = {
                Image = "/run/current-system/sw/share/wallpapers/Tree/contents/images/Tree.jpg";
                PreviewImage = "/run/current-system/sw/share/wallpapers/Tree/contents/images/Tree.jpg";
              };
            };
          };
        };
      };
      kwinrc = {
        Desktops = {
          Number = 4;
          Rows = 1;
        };
        "Effect-blur" = {
          NoiseStrength = 0;
        };
        "Effect-wobblywindows" = {
          Drag = 85;
          Stiffness = 10;
          WobblynessLevel = 1;
        };
        NightColor = {
          Active = true;
        };
        Plugins = {
          blurEnabled = true;
          cubeEnabled = true;
          dimscreenEnabled = true;
          glideEnabled = true;
          kwin4_effect_shapecornersEnabled = false;
          magiclampEnabled = true;
          scaleEnabled = false;
          squashEnabled = false;
          thumbnailasideEnabled = true;
          translucencyEnabled = true;
          wobblywindowsEnabled = true;
        };
        TabBox = {
          LayoutName = "coverswitch";
        };
        Windows = {
          BorderlessMaximizedWindows = true;
        };
        Xwayland = {
          Scale = 1.00;
        };
        "org.kde.kdecoration2" = {
          BorderSizeAuto = false;
          ButtonsOnLeft = "XAI";
          ButtonsOnRight = "";
          library = "org.kde.kwin.aurorae.v2";
        };
      };
      powerdevilrc = {
        "AC" = {
          "Display" = {
            DisplayBrightness = 100;
            UseProfileSpecificDisplayBrightness = true;
          };
          "Performance" = {
            PowerProfile = "balanced";
          };
          "SuspendAndShutdown" = {
            AutoSuspendAction = 0;
          };
        };
        "Battery" = {
          "Display" = {
            UseProfileSpecificDisplayBrightness = true;
          };
          "Performance" = {
            PowerProfile = "power-saver";
          };
        };
        "LowBattery" = {
          "Performance" = {
            PowerProfile = "power-saver";
          };
        };
      };
    };

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

    home.file = {
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
      "${localDir}/user-places.xbel".source = ./misc/user-places.xbel;
    };

    home.sessionVariables = {
      QML_FORCE_DISK_CACHE = "1";
    };
  };
}
