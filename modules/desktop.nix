{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.dr460nixed.desktop;
in
{
  options.dr460nixed.theming = lib.mkOption
    {
      default = false;
      type = types.bool;
      internal = true;
      description = lib.mdDoc ''
        Whether to enable basic system theming.
      '';
    };

  config = mkIf cfg {
    services.xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];
      desktopManager.plasma5 = { enable = true; };
      displayManager = {
        sddm = {
          autoNumlock = true;
          enable = true;
          settings = {
            Autologin = {
              Session = "plasma.desktop";
              User = "nico";
            };
            General = { Font = "Fira Sans"; };
          };
          theme = "Sweet";
        };
      };
    };

    # Remove a few applications that aren't needed
    environment.plasma5.excludePackages = with pkgs; with libsForQt5; [
      oxygen
      plasma-browser-integration
    ];

    # Additional KDE packages not included by default
    environment.systemPackages = with pkgs; [
      applet-window-appmenu
      applet-window-title
      beautyline-icons
      dr460nized-kde-theme
      firedragon
      jamesdsp
      libinput-gestures
      libsForQt5.applet-window-buttons
      libsForQt5.kdegraphics-thumbnailers
      libsForQt5.kimageformats
      libsForQt5.qtstyleplugin-kvantum
      resvg
      sshfs
      sweet
      sweet-nova
      vlc
      xdg-desktop-portal
    ];

    fonts = {
      enableDefaultFonts = true;
      fonts = with pkgs; [
        fira
        (nerdfonts.override {
          fonts = [
            "JetBrainsMono"
          ];
        })
        noto-fonts
        noto-fonts-cjk
      ];
      # My beloved Fira Sans & JetBrains Mono
      fontconfig = {
        cache32Bit = true;
        defaultFonts = {
          monospace = [ "JetBrains Mono Nerd Font" ];
          sansSerif = [ "Fira" ];
          serif = [ "Fira" ];
        };
      };
    };

    # KDE Connect to connect my phone & Partition Manager
    programs = {
      kdeconnect.enable = true;
      partition-manager.enable = true;
    };

    # Enable Kvantum for theming
    environment.variables = {
      ALSOFT_DRIVERS = "pipewire";
      MOZ_USE_XINPUT2 = "1";
      QT_STYLE_OVERRIDE = "kvantum";
      SDL_AUDIODRIVER = "pipewire";
    };

    # Power profiles daemon
    services.power-profiles-daemon.enable = true;

    # LAN discovery
    services.avahi = {
      enable = true;
      nssmdns = true;
    };

    # Bluetooth
    hardware.bluetooth.enable = true;

    # GPU acceleration
    hardware.opengl = {
      driSupport = true;
      driSupport32Bit = true;
      enable = true;
    };

    # Enable the sound in general
    sound.enable = true;

    # Disable PulseAudio
    hardware.pulseaudio.enable = false;

    # Enable the realtime kit
    security.rtkit.enable = true;

    # Pipewire & wireplumber configuration
    services.pipewire = {
      alsa.enable = true;
      alsa.support32Bit = true;
      enable = true;
      pulse.enable = true;
      systemWide = false;
      wireplumber.enable = true;
    };
  };
}
