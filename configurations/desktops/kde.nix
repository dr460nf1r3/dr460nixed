{pkgs, ...}: {
  # Enable GNOME desktop environment
  services.xserver = {
    enable = true;
    excludePackages = [pkgs.xterm];
    desktopManager.plasma5 = {
      enable = true;
      notoPackage = pkgs.noto-fonts;
    };
    displayManager = {
      sddm = {
        autoNumlock = true;
        enable = true;
      };
    };
  };

  # Remove a few applications that I don't like
  environment.plasma5.excludePackages = with pkgs; [
    hicolor-icon-theme
    libsForQt5.breeze-gtk
    libsForQt5.breeze-icons
    libsForQt5.plasma-workspace-wallpapers
  ];

  # Additional KDE packages not included by default
  environment.systemPackages = with pkgs; [
    libsForQt5.applet-window-buttons
    libsForQt5.qtstyleplugin-kvantum
    xdg-desktop-portal
  ];

  environment.variables = {
    "QT_STYLE_OVERRIDE" = "kvantum";
  };
}
