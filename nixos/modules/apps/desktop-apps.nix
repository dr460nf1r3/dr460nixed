{
  config,
  dragonLib,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dr460nixed.desktops;
in
{
  config = lib.mkIf cfg.enable {
    garuda.catppuccin.enable = true;

    environment.variables = {
      VISUAL = lib.mkForce "vscode";
    };

    services.syncthing.openDefaultPorts = true;

    environment.systemPackages = with pkgs; [
      appimage-run
      aspell
      aspellDicts.de
      aspellDicts.en
      ayugram-desktop
      boxbuddy
      brave
      gimp
      hunspell
      hunspellDicts.de_DE
      hunspellDicts.en_US
      inputs.kwin-effects-forceblur.packages.${pkgs.system}.default
      kdePackages.kdenlive
      kdePackages.kleopatra
      kdePackages.krdc
      kdePackages.krfb
      kdePackages.okular
      libreoffice-qt6-fresh
      libsecret
      libva-utils
      lm_sensors
      movit
      obs-studio-wrapped
      (dragonLib.GPUOffloadApp config pkgs obs-studio-wrapped "com.obsproject.Studio")
      plasmusic-toolbar
      signal-desktop
      thunderbird
      usbutils
      vesktop
      vorta
      vulkan-tools
      xdg-utils
    ];
  };
}
