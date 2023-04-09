{ pkgs, ... }: {
  # Enable KDE Plasma desktop environment
  services.xserver = {
    enable = true;
    excludePackages = [ pkgs.xterm ];
    desktopManager.plasma5 = {
      enable = true;
      notoPackage = pkgs.noto-fonts;
    };
    displayManager = {
      sddm = {
        autoNumlock = true;
        enable = true;
        settings = {
          Autologin = {
            Session = "plasma.desktop";
            User = "nico";
          };
          General = {
            Font = "Fira Sans";
          };
        };
        theme = "Sweet";
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
    libsForQt5.breeze-qt5
    libsForQt5.kcrash
    libsForQt5.oxygen
    libsForQt5.plasma-browser-integration
    libsForQt5.plasma-welcome
    libsForQt5.plasma-workspace-wallpapers
    libsForQt5.sddm-kcm
  ];

  # Additional KDE packages not included by default
  environment.systemPackages = with pkgs; [
    applets-window-appmenu
    applets-window-title
    beautyline-icons
    dr460nized-kde-theme
    firedragon
    jamesdsp
    krita
    libinput-gestures
    libsForQt5.applet-window-buttons
    libsForQt5.kdegraphics-thumbnailers
    libsForQt5.kdenlive
    libsForQt5.kimageformats
    libsForQt5.krdc
    libsForQt5.krfb
    libsForQt5.qtstyleplugin-kvantum
    movit
    qbittorrent
    resvg
    sshfs
    sweet
    sweet-nova
    vlc
    xdg-desktop-portal
  ];

  # KDE Connect to connect my phone & Partition Manager
  programs.kdeconnect.enable = true;
  programs.partition-manager.enable = true;

  # Enable Kvantum for theming
  environment.variables = {
    "QT_STYLE_OVERRIDE" = "kvantum";
  };
}
