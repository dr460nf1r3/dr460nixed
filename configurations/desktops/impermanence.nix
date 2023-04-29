# ZFS-based impermanence but instead of rolling back on every start, roll back on safe shutdown/halt/reboot
{ config
, lib
, pkgs
, ...
}:
let
  cfgZfs = config.boot.zfs;
in
{
  # Reset rootfs on shutdown - keeping the sops-nix keys available in rootfs
  systemd.shutdownRamfs.contents."/etc/systemd/system-shutdown/zpool".source =
    lib.mkForce
      (pkgs.writeShellScript "zpool-sync-shutdown" ''
        ${cfgZfs.package}/bin/zfs rollback -r zroot/ROOT/empty@keys
        exec ${cfgZfs.package}/bin/zpool sync
      '');

  # Declare permanent path's
  systemd.shutdownRamfs.storePaths = [ "${cfgZfs.package}/bin/zfs" ];

  # Persistent files
  environment.persistence."/var/persistent" = {
    hideMounts = true;
    directories = [
      "/etc/NetworkManager/system-connections"
      "/etc/nixos"
      "/etc/secureboot"
      "/etc/ssh"
      "/var/cache/chaotic"
      "/var/cache/tailscale"
      "/var/lib/AccountsService/icons"
      "/var/lib/bluetooth"
      "/var/lib/chaotic"
      "/var/lib/containers"
      "/var/lib/flatpak"
      "/var/lib/libvirt"
      "/var/lib/machines"
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
        ".config/Code"
        ".config/GitKraken"
        ".config/Google"
        ".config/JetBrains"
        ".config/Nextcloud"
        ".config/Termius"
        ".config/asciinema"
        ".config/chromium"
        ".config/jamesdsp"
        ".config/kdeconnect"
        ".config/libreoffice"
        ".config/lutris"
        ".config/nheko"
        ".config/obs-studio"
        ".config/session"
        ".config/sops/age"
        ".config/spotify"
        ".config/teams-for-linux"
        ".config/thefuck"
        ".config/vlc"
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
        ".local/share/nheko"
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
        "Sync"
        "Videos"
        {
          directory = ".config/Bitwarden CLI";
          mode = "0700";
        }
        {
          directory = ".config/Keybase";
          mode = "0700";
        }
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
      # These files are used by Plasma for saving state
      files = [
        ".config/gwenviewrc"
        ".config/kactivitymanagerd-statsrc"
        ".config/kateschemarc"
        ".config/kconf_updaterc"
        ".config/kglobalshortcutsrc"
        ".config/khotkeysrc"
        ".config/konsolesshconfig"
        ".config/ksmserverrc"
        ".config/ktimedrc"
        ".config/kwinrulesrc"
        ".config/kxkbrc"
        ".config/okularpartrc"
        ".config/plasmanotifyrc"
        ".config/plasmashellrc"
        ".local/share/krunnerstaterc"
        ".local/share/recently-used.xbel"
        ".opencommit"
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
