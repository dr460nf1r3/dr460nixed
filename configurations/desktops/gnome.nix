{pkgs, ...}: let
  monitorsXmlContent = builtins.readFile ../../hosts/slim-lair/monitors.xml;
  monitorsConfig = pkgs.writeText "gdm_monitors.xml" monitorsXmlContent;
in {
  # Enable GNOME desktop environment
  services.xserver = {
    enable = true;
    excludePackages = [pkgs.xterm];
    desktopManager.gnome.enable = true;
    displayManager = {
      gdm = {
        autoSuspend = false;
        enable = true;
      };
    };
  };

  # Enable Wayland for a lot of apps
  environment.sessionVariables = {
    BEMENU_BACKEND = "wayland";
    CLUTTER_BACKEND = "wayland";
    ECORE_EVAS_ENGINE = "wayland_egl";
    ELM_ENGINE = "wayland_egl";
    GDK_BACKEND = "wayland";
    MOZ_ENABLE_WAYLAND = "1";
    NIXOS_OZONE_WL = "1";
    QT_AUTO_SCREEN_SCALE_FACTOR = "0";
    QT_QPA_PLATFORM = "wayland-egl";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    SAL_USE_VCLPLUGIN = "gtk3";
    SDL_VIDEODRIVER = "wayland";
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  # For some reason not set by GNOME itself, make SSH work with keyring
  environment.sessionVariables = {
    SSH_AUTH_SOCK = "/run/user/1000/keyring/ssh";
  };

  # Remove a few applications that I don't like
  environment.gnome.excludePackages =
    (with pkgs; [
      gnome-console
      gnome-photos
      gnome-tour
    ])
    ++ (with pkgs.gnome; [
      atomix
      cheese
      epiphany
      geary
      gedit
      gnome-calendar
      gnome-characters
      gnome-contacts
      gnome-music
      hitori
      iagno
      pkgs.gnome-text-editor
      simple-scan
      tali
      totem
      yelp
    ]);

  # Additional GNOME packages not included by default
  environment.systemPackages = with pkgs; [
    bubblemail
    dconf2nix
    evince
    gnome.gnome-tweaks
    gnomeExtensions.bubblemail
    gnomeExtensions.expandable-notifications
    gnomeExtensions.gsconnect
    gnomeExtensions.unite
    librsvg
    tilix
  ];
  services.dbus.packages = [pkgs.dconf pkgs.gnomeExtensions.pano];
  services.geoclue2.enable = true;
  services.udev.packages = with pkgs; [gnome.gnome-settings-daemon];

  # Allow using online accounts
  services.gnome.glib-networking.enable = true;
  services.gnome.gnome-online-accounts.enable = true;

  # Support Firefox if enabled
  programs.firefox.nativeMessagingHosts.gsconnect = true;

  # GSConnect to connect my phone
  programs.kdeconnect = {
    enable = true;
    package = pkgs.gnomeExtensions.gsconnect;
  };

  # Evolution for mail
  programs.evolution = {
    enable = true;
    plugins = [pkgs.evolution-ews];
  };

  # Enable the GNOME keyring
  services.gnome.gnome-keyring.enable = true;
  security.pam.services.nico.enableGnomeKeyring = true;

  # GNOME pinentry for gpg
  programs.gnupg.agent.pinentryFlavor = "gnome3";

  # Activate typing booster
  i18n.inputMethod = {
    enabled = "ibus";
    ibus.engines = with pkgs.ibus-engines; [typing-booster];
  };

  # Corrently enable the bubblemail daemon
  systemd.user.services.bubblemaild = {
    description = "The bubblemail service";
    enable = true;
    path = with pkgs; [bubblemail];
    script = "bubblemaild";
    serviceConfig.PassEnvironment = "DISPLAY";
    wantedBy = ["default.target"];
  };

  # Apply monitor config on GDM
  systemd.tmpfiles.rules = [
    "L+ /run/gdm/.config/monitors.xml - - - - ${monitorsConfig}"
  ];

  # Fix the monitor setup on GNOME
  home-manager.users.nico.home.file.".config/monitors.xml".source = ./monitors.xml;
}
