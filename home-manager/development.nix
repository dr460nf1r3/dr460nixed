{ pkgs, ... }:
{
  # VSCode settings
  programs.vscode.profiles.default.userSettings = {
    "editor.fontFamily" = "'Jetbrains Mono Nerd Font'; 'monospace'; monospace";
    "editor.formatOnSave" = false;
    "editor.inlineSuggest.enabled" = true;
    "explorer.confirmDelete" = false;
    "gitlens.telemetry.enabled" = false;
    "merge-conflict.autoNavigateNextConflict.enabled" = true;
    "nix.enableLanguageServer" = true;
    "nix.serverPath" = "nixd";
    "telemetry.telemetryLevel" = "off";
    "terminal.integrated.confirmOnExit" = "hasChildProcesses";
    "terminal.integrated.copyOnSelection" = true;
    "terminal.integrated.cursorBlinking" = true;
    "terminal.integrated.cursorStyle" = "line";
    "terminal.integrated.defaultProfile.linux" = "tmux";
    "terminal.integrated.enableBell" = true;
    "terminal.integrated.gpuAcceleration" = "on";
    "terminal.integrated.ignoreProcessNames" = [
      "bash"
      "fish"
      "starship"
      "tmux"
    ];
    "terminal.integrated.persistentSessionScrollback" = 10000;
    "terminal.integrated.profiles.linux" = {
      "bash" = {
        "icon" = "terminal-bash";
        "path" = "bash";
      };
      "fish" = {
        "path" = "fish";
      };
      "tmux" = {
        "icon" = "terminal-tmux";
        "path" = "tmux";
      };
    };
    "terminal.integrated.sendKeybindingsToShell" = true;
    "terminal.integrated.shellIntegration.history" = 10000;
    "terminal.integrated.shellIntegration.suggestEnabled" = true;
    "terminal.integrated.smoothScrolling" = true;
    "[nix]" = {
      "editor.defaultFormatter" = "jnoortheen.nix-ide";
    };
  };

  # Required for Godot to be able to find Rider
  home.file = {
    ".local/share/applications/jetbrains-rider.desktop".source =
      let
        desktopFile = pkgs.makeDesktopItem {
          name = "jetbrains-rider";
          desktopName = "Rider";
          exec = "rider";
          icon = "rider";
          type = "Application";
          extraConfig.NoDisplay = "true";
        };
      in
      "${desktopFile}/share/applications/jetbrains-rider.desktop";

    # Declarative Distrobox Arch launcher (instead of generated entry)
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

    # Declarative autostart for Arch container warm-up
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

  # GitHub CLI
  programs.gh.settings.git_protocol = "ssh";

  # Claude
  programs.claude-code = {
    enable = true;
    memory.text = ''
      This user has Nix installed, for simple things you can `nix run nixpkgs#pkgname -- args`.

      If new ad-hoc environments are interesting, check https://devenv.sh/ad-hoc-developer-environments/
    '';
    settings = {
      theme = "dark";
      includeCoAuthoredBy = true;
    };
  };
}
