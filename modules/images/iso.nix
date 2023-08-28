{ pkgs
, ...
}:
with pkgs;
{
  # All of the needed services
  services = {
    acpid.enable = true;
    avahi = {
      enable = true;
      nssmdns = true;
    };
    pipewire = {
      alsa.enable = true;
      alsa.support32Bit = true;
      enable = true;
      pulse.enable = true;
      systemWide = false;
      wireplumber.enable = true;
    };
    xserver = {
      desktopManager.plasma5.enable = true;
      displayManager = {
        sddm = {
          autoNumlock = true;
          enable = true;
          settings = {
            General = {
              Font = "Fira Sans";
            };
          };
        };
      };
      enable = true;
      excludePackages = [ xterm ];
      layout = "de";
      xkbVariant = "";
    };
  };

  # Commonly used programs
  programs = {
    adb.enable = true;
    chromium = {
      defaultSearchProviderEnabled = true;
      defaultSearchProviderSearchURL = "https://searx.dr460nf1r3.org/search?q=%s";
      defaultSearchProviderSuggestURL = "https://searx.dr460nf1r3.org/autocomplete?q=%s";
      enable = true;
      extensions = [
        "ajhmfdgkijocedmfjonnpjfojldioehi" # Privacy Pass
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock origin
        "doojmbjmlfjjnbmnoijecmcbfeoakpjm" # NoScript
        "edibdbjcniadpccecjdfdjjppcpchdlm" # I Still Don't Care About Cookies
        "fhnegjjodccfaliddboelcleikbmapik" # Tab Counter
        "hipekcciheckooncpjeljhnekcoolahp" # Tabliss
        "kbfnbcaeplbcioakkpcpgfkobkghlhen" # Grammarly
        "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock
        "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
        "oladmjdebphlnjjcnomfhhbfdldiimaf;https://raw.githubusercontent.com/libredirect/libredirect/master/src/updates/updates.xml" # Libredirect
      ];
      extraOpts = {
        "HomepageLocation" = "https://searx.dr460nf1r3.org";
        "QuicAllowed" = true;
        "RestoreOnStartup" = true;
        "ShowHomeButton" = true;
      };
    };
    kdeconnect.enable = true;
    partition-manager.enable = true;
    wireshark.enable = true;
  };

  # Enable the realtime kit
  security.rtkit.enable = true;

  # Disable PulseAudio
  hardware = {
    pulseaudio.enable = false;
    bluetooth.enable = true;
  };

  # Define the default fonts Fira Sans & Jetbrains Mono Nerd Fonts
  fonts = {
    enableDefaultPackages = false;
    packages = [
      fira
      (nerdfonts.override { fonts = [ "JetBrainsMono" ]; })
      noto-fonts
      noto-fonts-emoji
    ];
    fontconfig = {
      cache32Bit = true;
      defaultFonts = {
        monospace =
          [ "JetBrains Mono Nerd Font" "Noto Fonts Emoji" ];
        sansSerif = [ "Fira" "Noto Fonts Emoji" ];
        serif = [ "Fira" "Noto Fonts Emoji" ];
        emoji = [ "Noto Fonts Emoji" ];
      };
      enable = true;
    };
    fontDir = {
      enable = true;
      decompressFonts = true;
    };
  };

  # Less Plasma apps, our apps & common variables
  environment = {
    plasma5.excludePackages = [
      okular
      oxygen
      plasma-browser-integration
    ];
    systemPackages = [
      chromium
      ffmpegthumbnailer
      gparted
      hexedit
      libinput-gestures
      libsForQt5.kdegraphics-thumbnailers
      libsForQt5.kimageformats
      libsForQt5.qtstyleplugin-kvantum
      resvg
      speedcrunch
      sshfs
      tdesktop
      tor-browser-bundle-bin
      vlc
      xdg-desktop-portal
      yubikey-manager-qt
      yubioath-flutter
    ];
    variables = {
      ALSOFT_DRIVERS = "pipewire";
      MOZ_USE_XINPUT2 = "1";
      QT_STYLE_OVERRIDE = "kvantum";
      SDL_AUDIODRIVER = "pipewire";
    };
  };
}
