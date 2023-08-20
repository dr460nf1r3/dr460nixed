{
  # Virt-manager settings
  dconf.settings = {
    "org/virt-manager/virt-manager" = {
      manager-window-height = 550;
      manager-window-width = 550;
    };
    "org/virt-manager/virt-manager/confirm" = {
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
  };

  # VSCode settings
  programs.vscode.userSettings = {
    "workbench.colorTheme" = "Sweet vscode";
    "editor.fontFamily" = "'Jetbrains Mono Nerd Font'; 'monospace'; monospace";
    "editor.formatOnSave" = true;
    "terminal.integrated.confirmOnExit" = "hasChildProcesses";
    "terminal.integrated.cursorStyle" = "line";
    "terminal.integrated.copyOnSelection" = true;
    "terminal.integrated.cursorBlinking" = true;
    "terminal.integrated.enableBell" = true;
    "terminal.integrated.gpuAcceleration" = "on";
    "terminal.integrated.ignoreProcessNames" = [
      "starship"
      "oh-my-posh"
      "bash"
      "zsh"
      "fish"
      "tmux"
    ];
    "terminal.integrated.persistentSessionScrollback" = 10000;
    "terminal.integrated.sendKeybindingsToShell" = true;
    "terminal.integrated.shellIntegration.suggestEnabled" = true;
    "terminal.integrated.smoothScrolling" = true;
    "terminal.integrated.shellIntegration.history" = 10000;
    "terminal.integrated.profiles.linux" = {
      "bash" = {
        "path" = "bash";
        "icon" = "terminal-bash";
      };
      "zsh" = {
        "path" = "zsh";
      };
      "fish" = {
        "path" = "fish";
      };
      "tmux" = {
        "path" = "tmux";
        "icon" = "terminal-tmux";
      };
      "pwsh" = {
        "path" = "pwsh";
        "icon" = "terminal-powershell";
      };
    };
    "terminal.integrated.defaultProfile.linux" = "tmux";
    "telemetry.telemetryLevel" = "off";
    "gitlens.telemetry.enabled" = false;
    "nix.serverPath" = "nixd";
    "nix.enableLanguageServer" = true;
    "merge-conflict.autoNavigateNextConflict.enabled" = true;
    "yaml.keyOrdering" = true;
    "workbench.iconTheme" = "material-icon-theme";
    "editor.inlineSuggest.enabled" = true;
    "[nix]" = {
      "editor.defaultFormatter" = "jnoortheen.nix-ide";
    };
    "explorer.confirmDelete" = false;
  };
}
