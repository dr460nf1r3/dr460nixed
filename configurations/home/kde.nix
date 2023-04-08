{
  lib,
  pkgs,
  ...
}:
with builtins; let
  configDir = ".config";
  kvantumDir = ".config/Kvantum";
  localDir = ".local/share";

  wallpaper = builtins.fetchurl {
    url = "https://gitlab.com/garuda-linux/themes-and-settings/artwork/garuda-wallpapers/-/raw/master/src/garuda-wallpapers/Malefor.jpg";
    sha256 = "0r6b33k24kq4i3vzp41bxx7gqmw20klakcmw4qy7zana4f3pfnw6";
  };
in {
  # Compatibility for GNOME apps
  dconf.enable = true;

  # Disable GTK target for Stylix as we supply KDE built files
  stylix.targets.gtk.enable = false;

  # Enable Kvantum theme and GTK & place a few bigger files
  home.file = {
    "${configDir}/baloofilerc".source = ./kde-static/baloofilerc;
    "${configDir}/dolphinrc".source = ./kde-static/dolphinrc;
    "${configDir}/gtk-3.0/colors.css".source = ./kde-static/gtk-3.0/colors.css;
    "${configDir}/gtk-3.0/gtk.css".source = ./kde-static/gtk-3.0/gtk.css;
    "${configDir}/gtk-3.0/settings.ini".source = ./kde-static/gtk-3.0/settings.ini;
    "${configDir}/gtk-4.0/colors.css".source = ./kde-static/gtk-4.0/colors.css;
    "${configDir}/gtk-4.0/gtk.css".source = ./kde-static/gtk-4.0/gtk.css;
    "${configDir}/gtk-4.0/settings.ini".source = ./kde-static/gtk-4.0/settings.ini;
    "${configDir}/kactivitymanagerdrc".source = ./kde-static/kactivitymanagerdrc;
    "${configDir}/kcminputrc".source = ./kde-static/kcminputrc;
    "${configDir}/kded5rc".source = ./kde-static/kded5rc;
    "${configDir}/kdeglobals".source = ./kde-static/kdeglobals;
    "${configDir}/kgammarc".source = ./kde-static/kgammarc;
    "${configDir}/konsolerc".source = ./kde-static/konsolerc;
    "${configDir}/kscreenlockerrc".source = ./kde-static/kscreenlockerrc;
    "${configDir}/kwalletrc".source = ./kde-static/powermanagementprofilesrc;
    "${configDir}/kwinrc".source = ./kde-static/kwinrc;
    "${configDir}/plasma-localerc".source = ./kde-static/plasma-localerc;
    "${configDir}/plasma-org.kde.plasma.desktop-appletsrc".source = ./kde-static/plasma-org.kde.plasma.desktop-appletsrc;
    "${configDir}/plasmarc-localerc".source = ./kde-static/plasmarc;
    "${configDir}/spectaclerc".source = ./kde-static/spectaclerc;
    "${configDir}/startkderc".source = ./kde-static/startkderc;
    "${configDir}/touchpadrc".source = ./kde-static/touchpadrc;
    "${configDir}/touchpadxlibinputrc".source = ./kde-static/touchpadxlibinputrc;
    "${kvantumDir}/kvantum.kvconfig".text = ''
      [General]
      theme=Sweet-transparent-toolbar
    '';
    "${localDir}/konsole/Dr460nized.profile".source = ./kde-static/Dr460nized.profile;
    "${localDir}/user-places.xbel".source = ./kde-static/user-places.xbel;
    "${localDir}/wallpapers/Malefor.jpg".source = wallpaper;
    ".gtkrc-2.0".source = ./kde-static/gtkrc-2.0;
  };

  # KDE Portal for GTK apps
  home.sessionVariables = {
    GTK_USE_PORTAL = "1";
  };
}
