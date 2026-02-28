{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.dr460nixed.hm.development;
in
{
  options.dr460nixed.hm.development = {
    enable = lib.mkEnableOption "development Home Manager configuration";
  };

  config = lib.mkIf cfg.enable {
    home.file = {
      ".local/share/applications/Arch.desktop".text = ''
        [Desktop Entry]
        Version=1.0
        Type=Application
        Name=Arch (Distrobox)
        Comment=Open Arch Linux in Distrobox
        Exec=${pkgs.distrobox}/bin/distrobox-enter --name arch
        Icon=utilities-terminal
        Terminal=true
        Categories=System;Utility;TerminalEmulator;
        StartupNotify=true
      '';
      ".config/autostart/Arch.desktop".text = ''
        [Desktop Entry]
        Version=1.0
        Type=Application
        Name=Arch (Distrobox)
        Comment=Warm up Arch Distrobox session on login
        Exec=${pkgs.distrobox}/bin/distrobox-enter --name arch -- true
        Icon=utilities-terminal
        Terminal=false
        X-GNOME-Autostart-enabled=true
        X-KDE-autostart-after=panel
        X-KDE-autostart-phase=2
      '';
    };

    programs.gh = {
      enable = true;
      settings.git_protocol = "ssh";
    };
  };
}
