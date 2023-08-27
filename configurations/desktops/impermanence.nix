_: {
  # This was recently added to Chaotic Nyx
  chaotic.zfs-impermanence-on-shutdown = {
    enable = true;
    snapshot = "start";
    volume = "zroot/ROOT/empty";
  };

  # Persistent files
  environment.persistence."/var/persistent" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/etc/nixos"
      "/etc/secureboot"
      "/var/cache/chaotic"
      "/var/cache/tailscale"
      "/var/lib/AccountsService/icons"
      "/var/lib/bluetooth"
      "/var/lib/chaotic"
      "/var/lib/containers"
      "/var/lib/flatpak"
      "/var/lib/libvirt"
      "/var/lib/machines"
      "/var/lib/sddm"
      "/var/lib/systemd"
      "/var/lib/tailscale"
      "/var/lib/upower"
      "/var/lib/vnstat"
      {
        directory = "/var/lib/iwd";
        mode = "u=rwx,g=,o=";
      }
    ];
    files = [
      "/var/lib/dbus/machine-id"
    ];
    users."root" = {
      home = "/root";
      directories = [
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
      ];
    };
    users."nico" = {
      directories = [
        ".android"
        ".ansible"
        ".config"
        ".firedragon"
        ".gitkraken"
        ".java"
        ".local/share/JetBrains"
        ".local/share/Nextcloud"
        ".local/share/PrismLauncher"
        ".local/share/Steam"
        ".local/share/TelegramDesktop"
        ".local/share/Vorta"
        ".local/share/applications"
        ".local/share/baloo"
        ".local/share/containers"
        ".local/share/dolphin"
        ".local/share/fish"
        ".local/share/heroku"
        ".local/share/kactivitymanagerd"
        ".local/share/klipper"
        ".local/share/knewstuff3"
        ".local/share/konsole"
        ".local/share/krita"
        ".local/share/kscreen"
        ".local/share/kwalletd"
        ".local/share/lutris"
        ".local/share/plasma"
        ".local/share/tor-browser"
        ".mozilla"
        ".thunderbird"
        ".tldrc"
        ".var"
        ".yubico"
        "Documents"
        "Downloads"
        "Music"
        "Nextcloud"
        "Pictures"
        "School"
        "Sync"
        "Videos"
        {
          directory = ".gnupg";
          mode = "0700";
        }
        {
          directory = ".local/share/keybase";
          mode = "0700";
        }
        {
          directory = ".local/share/keyrings";
          mode = "0700";
        }
        {
          directory = ".ssh";
          mode = "0700";
        }
      ];
    };
  };

  # Not important but persistent files
  environment.persistence."/var/residues" = {
    hideMounts = true;
    directories = [
      "/var/cache"
      "/var/log"
    ];
    users.nico = {
      directories = [
        ".cache/bookmarksrunner"
        ".cache/chromium"
        ".cache/firedragon"
        ".cache/konsole"
        ".cache/lutris"
        ".cache/mesa_shader_cache"
        ".cache/mozilla"
        ".cache/nix-index"
        ".cache/spotify"
        ".cache/thunderbird"
        ".local/share/Trash"
        ".local/state/wireplumber"
        ".steam"
      ];
    };
  };
}
