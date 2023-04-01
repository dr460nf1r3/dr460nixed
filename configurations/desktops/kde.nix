{pkgs, ...}: {
  # Import custom packages
  # imports = [
  #   ../../pkgs/sweet-kde/default.nix
  # ];

  # Enable KDE Plasma desktop environment
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
        theme = "sweet";
      };
    };
  };

  # KDE Master branch overlay - needs patches fixed
  # nixpkgs.overlays = import ../../overlays/kde-nix-overlay/overlays.nix;

  # Remove a few applications that I don't like
  environment.plasma5.excludePackages = with pkgs; [
    hicolor-icon-theme
    libsForQt5.breeze-gtk
    libsForQt5.breeze-icons
    libsForQt5.plasma-workspace-wallpapers
    libsForQt5.sddm-kcm
  ];

  # Additional KDE packages not included by default
  environment.systemPackages = with pkgs; [
    jamesdsp
    libinput-gestures
    libsForQt5.applet-window-buttons
    libsForQt5.kdegraphics-thumbnailers
    libsForQt5.kimageformats
    libsForQt5.qtstyleplugin-kvantum
    resvg
    sshfs
    sweet-nova
    xdg-desktop-portal
  ];

  # KDE Connect to connect my phone
  programs.kdeconnect.enable = true;
  programs.partition-manager.enable = true;

  # Enable Kvantum for theming
  environment.variables = {
    "QT_STYLE_OVERRIDE" = "kvantum";
  };
}
