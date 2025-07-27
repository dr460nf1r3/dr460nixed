{pkgs, ...}: {
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
    ".local/share/applications/jetbrains-rider.desktop".source = let
      desktopFile = pkgs.makeDesktopItem {
        name = "jetbrains-rider";
        desktopName = "Rider";
        exec = "rider";
        icon = "rider";
        type = "Application";
        extraConfig.NoDisplay = "true";
      };
    in "${desktopFile}/share/applications/jetbrains-rider.desktop";
  };

  # GitHub CLI
  programs.gh.settings.git_protocol = "ssh";
}
