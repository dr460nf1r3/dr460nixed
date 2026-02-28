{
  pkgs,
  inputs,
  lib,
  config,
  ...
}:
let
  cfg = config.dr460nixed.hm.desktop;
  configDir = ".config";
  jamesdsp = inputs.self.dragonLib.jamesdsp pkgs;
  appdir = ".local/share/applications";
in
{
  options.dr460nixed.hm.desktop = {
    enable = lib.mkEnableOption "Desktop environment configuration";
    jamesdsp = lib.mkEnableOption "JamesDSP audio processing";
    launchers = lib.mkEnableOption "Themed desktop launchers";
  };

  config = lib.mkIf cfg.enable {
    dconf.enable = lib.mkIf cfg.jamesdsp true;

    systemd.user.services = lib.mkIf cfg.jamesdsp {
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

      "${appdir}/btop.desktop".text = lib.mkIf cfg.launchers ''
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
    };

    home.sessionVariables = {
      QML_FORCE_DISK_CACHE = "1";
    };
  };
}
