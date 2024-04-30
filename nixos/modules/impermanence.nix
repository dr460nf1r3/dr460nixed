{
  lib,
  config,
  ...
}: {
  # Rollback function for BTRFS rootfs
  # This assumes we have a LUKS volume named "crypted"
  # https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
  boot.initrd = {
    enable = true;
    supportedFilesystems = ["btrfs"];
    systemd.services.restore-root = {
      description = "Rollback BTRFS rootfs";
      wantedBy = ["initrd.target"];
      after = ["systemd-cryptsetup@crypted.service"];
      before = ["sysroot.mount"];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p /mnt

        # We first mount the btrfs root to /mnt
        # so we can manipulate btrfs subvolumes.
        mount -o subvol=/ /dev/mapper/crypted /mnt

        # While we're tempted to just delete /root and create
        # a new snapshot from /root-blank, /root is already
        # populated at this point with a number of subvolumes,
        # which makes `btrfs subvolume delete` fail.
        # So, we remove them first.
        btrfs subvolume list -o /mnt/root |
        cut -f9 -d' ' |
        while read subvolume; do
          echo "deleting /$subvolume subvolume..."
          btrfs subvolume delete "/mnt/$subvolume"
        done &&
        echo "deleting /root subvolume..." &&
        btrfs subvolume delete /mnt/root

        echo "restoring blank /root subvolume..."
        btrfs subvolume snapshot /mnt/root-blank /mnt/root

        # Once we're done rolling back to a blank snapshot,
        # we can unmount /mnt and continue on the boot process.
        umount /mnt
      '';
    };
  };

  # Rollback results in sudo lectures after each reboot
  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

  # Persistent files
  environment.persistence."/persist" = {
    hideMounts = true;
    directories =
      [
        "/etc/NetworkManager/system-connections"
        "/etc/nixos"
        "/etc/secureboot"
        "/var/cache/tailscale"
        "/var/lib/AccountsService/icons"
        "/var/lib/bluetooth"
        "/var/lib/containers"
        "/var/lib/flatpak"
        "/var/lib/libvirt"
        "/var/lib/machines"
        "/var/lib/sddm"
        "/var/lib/systemd"
        "/var/lib/tailscale"
        "/var/lib/nixos"
        "/var/lib/upower"
        "/var/lib/vnstat"
        "/var/cache"
        {
          directory = "/var/lib/iwd";
          mode = "u=rwx,g=,o=";
        }
      ]
      ++ lib.optionals config.security.acme.acceptTerms [
        {
          directory = "/var/lib/acme";
          user = "acme";
          group = "acme";
          mode = "0755";
        }
      ]
      ++ lib.optionals config.services.printing.enable [
        {
          directory = "/var/lib/cups";
          user = "root";
          group = "root";
          mode = "0700";
        }
      ]
      ++ lib.optionals config.services.fail2ban.enable [
        {
          directory = "/var/lib/fail2ban";
          user = "fail2ban";
          group = "fail2ban";
          mode = "0750";
        }
      ]
      ++ lib.optionals config.services.postgresql.enable [
        {
          directory = "/var/lib/postgresql";
          user = "postgres";
          group = "postgres";
          mode = "0700";
        }
      ]
      ++ lib.optionals config.services.loki.enable [
        {
          directory = "/var/lib/loki";
          user = "loki";
          group = "loki";
          mode = "0700";
        }
      ]
      ++ lib.optionals config.services.grafana.enable [
        {
          directory = config.services.grafana.dataDir;
          user = "grafana";
          group = "grafana";
          mode = "0700";
        }
      ]
      ++ lib.optionals config.services.vaultwarden.enable [
        {
          directory = "/var/lib/vaultwarden";
          user = "vaultwarden";
          group = "vaultwarden";
          mode = "0700";
        }
      ]
      ++ lib.optionals config.services.influxdb2.enable [
        {
          directory = "/var/lib/influxdb2";
          user = "influxdb2";
          group = "influxdb2";
          mode = "0700";
        }
      ]
      ++ lib.optionals config.services.telegraf.enable [
        {
          directory = "/var/lib/telegraf";
          user = "telegraf";
          group = "telegraf";
          mode = "0700";
        }
      ]
      ++ lib.optionals config.services.adguardhome.enable [
        {
          directory = "/var/lib/private/AdGuardHome";
          user = "root";
          group = "root";
          mode = "0700";
        }
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
        # Important user data
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
        ".local/share/direnv"
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
        ".steam"
        ".thunderbird"
        ".tldrc"
        ".var"
        ".yubico"
        "Documents"
        "Downloads"
        "Games"
        "Music"
        "Nextcloud"
        "Pictures"
        "School"
        "Sync"
        "Videos"
        "VirtualBox VMs"
        # Cache stuff, not actual user data
        ".cache/bookmarksrunner"
        ".cache/chromium"
        ".cache/firedragon"
        ".cache/konsole"
        ".cache/lutris"
        ".cache/mesa_shader_cache"
        ".cache/mozilla"
        ".cache/nix"
        ".cache/nix-index"
        ".cache/plasmashell"
        ".cache/spotify"
        ".cache/starship"
        ".cache/thunderbird"
        ".cache/virt-manager"
        ".local/share/Trash"
        ".local/state/wireplumber"
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
}
