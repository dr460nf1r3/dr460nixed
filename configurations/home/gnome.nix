{ lib
, pkgs
, ...
}:
let
  game = builtins.fetchurl {
    url = https://cloud.garudalinux.org/s/eimgmWmN485tHGw/download/game.irs;
    sha256 = "0d1lfbzca6wqfqxd6knzshc00khhgfqmk36s5xf1wyh703sdxk79";
  };
  movie = builtins.fetchurl {
    url = https://cloud.garudalinux.org/s/K8CpHZYTiLyXLSd/download/movie.irs;
    sha256 = "1r3s8crbmvzm71yqrkp8d8x4xyd3najz82ck6vbh1v9kq6jclc0w";
  };
  music = builtins.fetchurl {
    url = https://cloud.garudalinux.org/s/cbPLFeAMeJazKxC/download/music-balanced.irs;
    sha256 = "1szssbqk3dnaqhg3syrzq9zqfb18phph5yy5m3xfnjgllj2yphy0";
  };
  voice = builtins.fetchurl {
    url = https://cloud.garudalinux.org/s/wJSs9gckrNidTBo/download/voice.irs;
    sha256 = "1b643m8v7j15ixi2g6r2909vwkq05wi74ybccbdnp4rkms640y4w";
  };
in
{
  # Enable dconf
  dconf.enable = true;
  # Configure everything in dconf
  dconf.settings = {
    "com/gexperts/Tilix" = {
      always-use-regex-in-search = true;
      auto-hide-mouse = true;
      control-scroll-zoom = true;
      copy-on-select = true;
      enable-wide-handle = false;
      middle-click-close = true;
      paste-advanced-default = true;
      tab-position = "bottom";
      terminal-title-show-when-single = false;
      terminal-title-style = "normal";
      window-save-state = false;
      window-style = "normal";
    };
    "com/gexperts/Tilix/profiles/2b7c4080-0ddd-46c5-8f23-563fd3ba789d" = {
      background-color = "#1E1E1E";
      background-transparency-percent = 10;
      badge-color = "#AC7EA8";
      badge-color-set = false;
      badge-use-system-font = true;
      bold-color-set = true;
      cursor-blink-mode = "on";
      cursor-colors-set = false;
      cursor-shape = "ibeam";
      custom-command = "${pkgs.fish}/bin/fish";
      default-size-columns = 120;
      default-size-rows = 30;
      dim-transparency-percent = 0;
      font = "JetBrainsMono Nerd Font Mono 12";
      foreground-color = "#A7A7A7";
      highlight-colors-set = false;
      notify-silence-enabled = false;
      notify-silence-threshold = 60;
      terminal-bell = "icon-sound";
      use-custom-command = true;
      use-system-font = false;
      use-theme-colors = true;
      visible-name = "Nico";
    };
    "com/github/wwmm/easyeffects" = {
      use-dark-theme = true;
    };
    "com/github/wwmm/easyeffects/streamoutputs/convolver/0" = {
      bypass = false;
      kernel-path = "/home/nico/.config/easyeffects/irs/music.irs";
    };
    "com/github/wwmm/pulseeffects" = {
      use-dark-theme = true;
    };
    "org/freedesktop/ibus/engine/typing-booster" = {
      autocapitalize = true;
      dictionary = "en_US,de_DE";
      emojipredictions = true;
      flagdictionary = true;
      inlinecompletion = 0;
      inputmethod = "NoIME";
      labeldictionary = true;
      labelspellcheck = true;
      labeluserdb = true;
      shownumberofcandidates = true;
      showstatusinfoinaux = true;
      tabenable = true;
    };
    "org/gnome/calculator" = {
      accuracy = 5;
      angle-units = "degrees";
      base = 10;
      button-mode = "programming";
      number-format = "automatic";
      word-size = 64;
    };
    "org/gnome/calendar" = {
      active-view = "month";
      window-maximized = false;
      window-size = lib.hm.gvariant.mkTuple [ 768 600 ];
    };
    "org/gnome/Connections" = {
      first-run = false;
    };
    "org/gnome/desktop/app-folders" = {
      folder-children = [ "Utilities" ];
    };
    "org/gnome/desktop/input-sources" = {
      mru-sources = [ (lib.hm.gvariant.mkTuple [ "xkb" "de" ]) (lib.hm.gvariant.mkTuple [ "ibus" "typing-booster" ]) ];
      sources = [ (lib.hm.gvariant.mkTuple [ "ibus" "typing-booster" ]) (lib.hm.gvariant.mkTuple [ "xkb" "de" ]) ];
      xkb-options = [ "terminate:ctrl_alt_bksp" ];
    };
    "org/gnome/desktop/notifications" = {
      application-children = [
        "chromium-browser"
        "code-url-handler"
        "gnome-power-panel"
        "org-gnome-shell-extensions-gsconnect"
        "org-telegram-desktop"
      ];
    };
    "org/gnome/desktop/notifications/application/code-url-handler" = {
      application-id = "code-url-handler.desktop";
    };
    "org/gnome/desktop/notifications/application/org-telegram-desktop" = {
      application-id = "org.telegram.desktop.desktop";
    };
    "org/gnome/desktop/peripherals/touchpad" = {
      tap-to-click = true;
    };
    "org/gnome/desktop/privacy" = {
      recent-files-max-age = 30;
    };
    "org/gnome/desktop/screensaver" = {
      lock-delay = lib.hm.gvariant.mkUint32 120;
    };
    "org/gnome/desktop/wm/preferences" = {
      button-layout = "close,minimize:appmenu";
      titlebar-font = "Fira Sans Bold 11";
    };
    "org/gnome/desktop/interface" = {
      document-font-name = "Fira Sans 11";
      monospace-font-name = "JetBrainsMono Nerd Font 10";
    };
    "org/gnome/evolution-data-server" = {
      limit-operations-in-power-saver-mode = true;
      migrated = true;
    };
    "org/gnome/evolution-data-server/calendar" = {
      contacts-reminder-enabled = true;
      contacts-reminder-interval = 7;
      contacts-reminder-units = "days";
      notify-completed-tasks = false;
      notify-with-tray = true;
    };
    "org/gnome/evolution" = {
      default-address-book = "5b80234be51b082a92b984306120b45b4f359f55";
      disabled-eplugins = [
        "org.gnome.evolution.plugin.preferPlain"
        "org.gnome.evolution.calendar.publish"
      ];
    };
    "org/gnome/evolution/addressbook" = {
      completion-minimum-query-length = 3;
      completion-show-address = true;
      hpane-position = 305;
      layout = 1;
      primary-addressbook = "0772ec28184f36779256f3e5bad98219d712a149";
    };
    "org/gnome/evolution/calendar" = {
      day-end-hour = 18;
      day-end-minute = 0;
      default-reminder-interval = 1;
      default-reminder-units = "days";
      show-icons-month-view = true;
      show-week-numbers = false;
      use-24hour-format = true;
      use-default-reminder = true;
      use-markdown-editor = true;
      week-start-day-name = "monday";
      work-day-friday = true;
      work-day-monday = true;
      work-day-saturday = false;
      work-day-sunday = false;
      work-day-thursday = true;
      work-day-tuesday = true;
      work-day-wednesday = true;
    };
    "org/gnome/evolution/mail" = {
      browser-close-on-reply-policy = "ask";
      composer-inherit-theme-colors = true;
      composer-magic-smileys = true;
      composer-mode = "markdown";
      composer-request-receipt = true;
      composer-spell-languages = [ "de_DE" "en_US" ];
      composer-unicode-smileys = false;
      composer-use-outbox = false;
      composer-visually-wrap-long-lines = false;
      composer-word-wrap-length = 70;
      delete-selects-previous = true;
      forward-style = 1;
      forward-style-name = "inline";
      image-loading-policy = "sometimes";
      junk-check-custom-header = true;
      junk-default-plugin = "Bogofilter";
      junk-empty-date = 19431;
      junk-empty-on-exit = true;
      junk-empty-on-exit-days = 0;
      junk-lookup-addressbook = true;
      load-http-images = 1;
      preview-unset-html-colors = true;
      prompt-check-if-default-mailer = false;
      reply-style-name = "quoted";
      search-gravatar-for-photo = true;
      send-recv-all-on-start = true;
      show-animated-images = true;
      show-sender-photo = true;
      show-startup-wizard = false;
      thread-subject = true;
      to-do-bar-show-no-duedate-tasks = false;
      trash-empty-date = 19431;
      trash-empty-on-exit = true;
      trash-empty-on-exit-days = 0;
    };
    "org/gnome/evolution/mail/browser-window" = {
      height = 600;
      maximized = false;
      width = 1000;
    };
    "org/gnome/evolution/mail/composer-window" = {
      height = 600;
      maximized = false;
      width = 1000;
    };
    "org/gnome/evolution/plugin/autocontacts" = {
      enable = true;
      file-under-as-first-last = true;
    };
    "org/gnome/evolution/plugin/email-custom-header" = {
      custom-header = [ ];
    };
    "org/gnome/evolution/plugin/external-editor" = {
      command = "code";
    };
    "org/gnome/evolution/plugin/itip" = {
      delete-processed = true;
    };
    "org/gnome/evolution/shell" = {
      default-component-id = "mail";
      folder-bar-width = 226;
    };
    "org/gnome/evolution/shell/window" = {
      height = 950;
      maximized = false;
      width = 1680;
      x = 35;
      y = 32;
    };
    "org/gnome/gnome-system-monitor" = {
      graph-data-points = 140;
      maximized = false;
      network-total-in-bits = false;
      process-memory-in-iec = false;
      show-dependencies = true;
      show-whose-processes = "user";
      update-interval = 1000;
      window-state = lib.hm.gvariant.mkTuple [ 900 600 ];
    };
    "org/gnome/maps" = {
      last-viewed-location = [ 51.349622329439484 7.0764894345799405 ];
      map-type = "MapsStreetSource";
      osm-username-oauth2 = "dr460nf1r3";
      show-scale = false;
      transportation-type = "pedestrian";
      window-maximized = false;
      window-size = [ 1300 750 ];
      zoom-level = 8;
    };
    "org/gnome/mutter" = {
      attach-modal-dialogs = true;
      center-new-windows = true;
      dynamic-workspaces = true;
      edge-tiling = true;
      focus-change-on-pointer-rest = true;
      workspaces-only-on-primary = false;
    };
    "org/gnome/nautilus/preferences" = {
      default-folder-viewer = "icon-view";
      migrated-gtk-settings = true;
      search-filter-time-type = "last_modified";
      show-create-link = true;
      show-delete-permanently = true;
    };
    "org/gnome/nautilus/window-state" = {
      initial-size = lib.hm.gvariant.mkTuple [ 1300 750 ];
    };
    "org/gnome/settings-daemon/peripherals/keyboard" = {
      numlock-state = "true";
    };
    "org/gnome/settings-daemon/plugins/power" = {
      sleep-inactive-ac-type = "nothing";
    };
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "bubblemail@razer.framagit.org"
        "expandable-notifications@kaan.g.inam.org"
        "gsconnect@andyholmes.github.io"
        "unite@hardpixel.eu"
      ];
      favorite-apps = [
        "com.gexperts.Tilix.desktop"
        "org.gnome.Nautilus.desktop"
        "chromium-browser.desktop"
        "org.gnome.Evolution.desktop"
        "gitkraken.desktop"
        "spotify.desktop"
        "org.telegram.desktop.desktop"
        "code.desktop"
      ];
      last-selected-power-profile = "powersave";
    };
    "org/gnome/shell/extensions/dash-to-dock" = {
      autohide = true;
      dock-fixed = false;
      dock-position = "BOTTOM";
      pressure-threshold = 200.0;
      require-pressure-to-show = true;
      show-favorites = true;
      hot-keys = false;
    };
    "org/gnome/shell/extensions/gsconnect" = {
      enabled = true;
    };
    "org/gnome/shell/extensions/gsconnect/preferences" = {
      window-size = lib.hm.gvariant.mkTuple [ 640 440 ];
    };
    "org/gnome/shell/extensions/unite" = {
      desktop-name-text = "Nixed GNOME 🔥";
      greyscale-tray-icons = true;
      hideActivitiesButton = 1;
      notificationsPosition = 2;
      show-window-buttons = "never";
      window-buttons-theme = "adwaita";
      windowStates = 0;
    };
    "org/gnome/shell/weather" = {
      automatic-location = true;
      locations = "[<(uint32 2, <('Cologne / Bonn', 'EDDK', false, [(0.88779081866554632, 0.12508193554402447)], @a(dd) [])>)>]";
    };
    "org/gnome/software" = {
      first-run = false;
    };
    "org/gnome/system/location" = {
      enabled = true;
    };
    "org/gtk/gtk4/settings/file-chooser" = {
      show-hidden = true;
      sort-directories-first = true;
    };
    "system/locale" = {
      region = "de_DE.UTF-8";
    };
  };

  # Set Nautilus bookmarks & Easy Effects presets
  home.file = {
    ".config/gtk-3.0/bookmarks".text = ''
      file:///home/nico/Documents/browser FireDragon
      file:///home/nico/Documents/chaotic Chaotic-AUR
      file:///home/nico/Documents/garuda Garuda Linux
      file:///home/nico/Documents/misc Misc things
      file:///home/nico/Documents/school School stuff
      file:///home/nico/Documents/work Working area
    '';
    ".config/easyeffects/irs/game.irs".source = game;
    ".config/easyeffects/irs/movie.irs".source = movie;
    ".config/easyeffects/irs/music.irs".source = music;
    ".config/easyeffects/irs/voice.irs".source = voice;
  };

  # Icon themes & GTK
  gtk = {
    enable = true;
    iconTheme = {
      name = "oomox-gruvbox-dark";
      package = pkgs.gruvbox-dark-icons-gtk;
    };
  };

  # Configure Qt theming
  qt = {
    enable = true;
    platformTheme = "adwaita";
    style.name = "adwaita-dark";
  };

  # Our cursor theme
  home.pointerCursor = {
    name = "Capitaine-cursors";
    package = pkgs.capitaine-cursors;
    size = 32;
    gtk.enable = true;
  };

  # Enhance audio output
  services.easyeffects.enable = true;

  # Actually enable the gnome-keyring for ssh keys
  services.gnome-keyring = {
    enable = true;
    components = [ "secrets" "ssh" ];
  };
}
