{
  # Virt-manager settings
  dconf.settings = {
    "org/virt-manager/virt-manager" = {
      manager-window-height = 550;
      manager-window-width = 550;
      system-tray = true;
      xmleditor-enabled = true;
    };
    "org/virt-manager/virt-manager/confirm" = {
      forcepoweroff = false;
      removedev = false;
      unapplied-dev = true;
    };
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
    "org/virt-manager/virt-manager/details" = {
      show-toolbar = true;
    };
    "org/virt-manager/virt-manager/vmlist-fields" = {
      disk-usage = true;
      network-traffic = true;
    };
    "org/virt-manager/virt-manager/stats" = {
      enable-disk-poll = true;
      enable-memory-poll = true;
      enable-net-poll = true;
    };
  };

  # VSCode settings
  programs.vscode.userSettings = {
    "editor.fontFamily" = "'Jetbrains Mono Nerd Font'; 'monospace'; monospace";
    "editor.formatOnSave" = true;
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
      "oh-my-posh"
      "starship"
      "tmux"
      "zsh"
    ];
    "terminal.integrated.persistentSessionScrollback" = 10000;
    "terminal.integrated.profiles.linux" = {
      "bash" = {
        "icon" = "terminal-bash";
        "path" = "bash";
      };
      "zsh" = {
        "path" = "zsh";
      };
      "fish" = {
        "path" = "fish";
      };
      "tmux" = {
        "icon" = "terminal-tmux";
        "path" = "tmux";
      };
      "pwsh" = {
        "icon" = "terminal-powershell";
        "path" = "pwsh";
      };
    };
    "terminal.integrated.sendKeybindingsToShell" = true;
    "terminal.integrated.shellIntegration.history" = 10000;
    "terminal.integrated.shellIntegration.suggestEnabled" = true;
    "terminal.integrated.smoothScrolling" = true;
    "workbench.iconTheme" = "material-icon-theme";
    "workbench.colorTheme" = "Sweet vscode";
    "[nix]" = {
      "editor.defaultFormatter" = "jnoortheen.nix-ide";
    };
  };
}
