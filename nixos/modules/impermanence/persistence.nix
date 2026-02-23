{
  lib,
  config,
  options,
  ...
}:
let
  # System-level persistent directories
  systemEtcDirs = [
    "asusd"
    "NetworkManager/system-connections"
    "nixos"
    "pacman.d/gnupg"
  ];

  systemVarCacheDirs = [
    "tailscale"
  ];

  systemVarLibDirs = [
    "AccountsService/icons"
    "bluetooth"
    "containers"
    "flatpak"
    "fwupd"
    "libvirt"
    "machines"
    "NetworkManager"
    "sbctl"
    "plasmalogin"
    "systemd"
    "tailscale"
    "nixos"
    "upower"
    "vnstat"
  ];

  systemVarLibDirsWithPerms = [
    {
      directory = "docker";
      user = "root";
      group = "root";
      mode = "0700";
    }
    {
      directory = "iwd";
      mode = "u=rwx,g=,o=";
    }
  ];

  # Root user persistence
  rootDirs = [
    {
      directory = ".gnupg";
      mode = "0700";
    }
    {
      directory = ".ssh";
      mode = "0700";
    }
  ];

  # User important data directories
  userDataDirs = [
    ".android"
    ".ansible"
    ".config"
    ".firedragon"
    ".gemini"
    ".gitkraken"
    ".java"
    ".local/share/AyuGramDesktop"
    ".local/share/JetBrains"
    ".local/share/Nextcloud"
    ".local/share/PrismLauncher"
    ".local/share/Steam"
    ".local/share/Vorta"
    ".local/share/baloo"
    ".local/share/direnv"
    ".local/share/dolphin"
    ".local/share/fish"
    ".local/share/heroku"
    ".local/share/kactivitymanagerd"
    ".local/share/klipper"
    ".local/share/knewstuff3"
    ".local/share/konsole"
    ".local/share/kpeoplevcard"
    ".local/share/krita"
    ".local/share/kscreen"
    ".local/share/kwalletd"
    ".local/share/lutris"
    ".local/share/plasma"
    ".local/share/plasma-systemmonitor"
    ".local/share/zed"
    ".local/state"
    ".mozilla/native-messaging-hosts"
    ".pki"
    ".steam"
    ".thunderbird/default"
    ".tldrc"
    ".vscode"
    ".wakatime"
    ".yubico"
    "Documents"
    "Downloads"
    "Games"
    "Music"
    "Nextcloud"
    "Pictures"
    "Projects"
    "Sync"
    "Videos"
    "VirtualBox VMs"
  ];

  # User cache directories to persist (important for IDE caches, etc.)
  userCacheDirs = [
    ".cache/BraveSoftware"
    ".cache/JetBrains"
    ".cache/bookmarksrunner"
    ".cache/distrobox"
    ".cache/fastfetch"
    ".cache/firedragon"
    ".cache/github-copilot"
    ".cache/konsole"
    ".cache/lutris"
    ".cache/mesa_shader_cache"
    ".cache/mozilla"
    ".cache/nix"
    ".cache/spotify"
    ".cache/systemsettings"
    ".cache/tldr"
    ".cache/thunderbird"
  ];

  # User state directories
  userStateDirs = [
    ".local/share/icons/distrobox"
    ".local/share/Trash"
    ".local/state/syncthing"
    ".local/state/wireplumber"
  ];

  # User files to persist
  userFiles = [
    ".bash_history"
    ".claude.json"
    ".wakatime.bdb"
    ".wakatime.cfg"
  ];

  # User directories with special permissions
  userDirsWithPerms = [
    {
      directory = ".gnupg";
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

  # Optional service directories (gated by service config)
  optionalServiceDirs = [
    {
      condition = config.security.acme.acceptTerms;
      dirs = [
        {
          directory = "/var/lib/acme";
          user = "acme";
          group = "acme";
          mode = "0755";
        }
      ];
    }
    {
      condition = config.services.printing.enable;
      dirs = [
        {
          directory = "/var/lib/cups";
          user = "root";
          group = "root";
          mode = "0700";
        }
      ];
    }
    {
      condition = config.services.fail2ban.enable;
      dirs = [
        {
          directory = "/var/lib/fail2ban";
          user = "fail2ban";
          group = "fail2ban";
          mode = "0750";
        }
      ];
    }
    {
      condition = config.services.postgresql.enable;
      dirs = [
        {
          directory = "/var/lib/postgresql";
          user = "postgres";
          group = "postgres";
          mode = "0700";
        }
      ];
    }
    {
      condition = config.services.loki.enable;
      dirs = [
        {
          directory = "/var/lib/loki";
          user = "loki";
          group = "loki";
          mode = "0700";
        }
      ];
    }
    {
      condition = config.services.grafana.enable;
      dirs = [
        {
          directory = config.services.grafana.dataDir;
          user = "grafana";
          group = "grafana";
          mode = "0700";
        }
      ];
    }
    {
      condition = config.services.vaultwarden.enable;
      dirs = [
        {
          directory = "/var/lib/vaultwarden";
          user = "vaultwarden";
          group = "vaultwarden";
          mode = "0700";
        }
      ];
    }
    {
      condition = config.services.influxdb2.enable;
      dirs = [
        {
          directory = "/var/lib/influxdb2";
          user = "influxdb2";
          group = "influxdb2";
          mode = "0700";
        }
      ];
    }
    {
      condition = config.services.telegraf.enable;
      dirs = [
        {
          directory = "/var/lib/telegraf";
          user = "telegraf";
          group = "telegraf";
          mode = "0700";
        }
      ];
    }
    {
      condition = config.services.adguardhome.enable;
      dirs = [
        {
          directory = "/var/lib/private/AdGuardHome";
          user = "root";
          group = "root";
          mode = "0700";
        }
      ];
    }
  ];

  # Flatten optional service dirs based on conditions
  optionalDirs = lib.concatMap (s: if s.condition then s.dirs else [ ]) optionalServiceDirs;

  cfg = config.dr460nixed.impermanence;
in
{
  # Persistent files
  config = lib.mkIf cfg.enable (
    lib.optionalAttrs (options.environment ? persistence) {
      environment.persistence."/persist" = {
        hideMounts = true;
        directories =
          map (dir: "/etc/${dir}") systemEtcDirs
          # System /var/cache directories
          ++ map (dir: "/var/cache/${dir}") systemVarCacheDirs
          # System /var/lib directories
          ++ map (dir: "/var/lib/${dir}") systemVarLibDirs
          # System /var/lib directories with special permissions
          ++ (map (entry: {
            directory = "/var/lib/${entry.directory}";
            user = entry.user or "root";
            group = entry.group or "root";
            mode = entry.mode or "0755";
          }) systemVarLibDirsWithPerms)
          # Optional service directories based on enabled services
          ++ optionalDirs
          # Catch-all for /var/cache
          ++ [ "/var/cache" ];
        users."root" = {
          directories = rootDirs;
        };
        users."nico" = {
          directories =
            userDataDirs
            # Cache directories to persist (IDE caches, etc.)
            ++ userCacheDirs
            # State directories
            ++ userStateDirs
            # Directories with special permissions
            ++ userDirsWithPerms;
          files = userFiles;
        };
      };
    }
  );
}
