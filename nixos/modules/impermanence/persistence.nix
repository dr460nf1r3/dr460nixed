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

  systemVarCacheDirs = [ ];

  systemVarLibDirs = [
    "AccountsService/icons"
    "machines"
    "NetworkManager"
    "sbctl"
    "plasmalogin"
    "systemd"
    "nixos"
    "upower"
  ];

  systemVarLibDirsWithPerms = [
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
    ".cargo"
    ".claude"
    ".config"
    ".java"
    ".local/share/direnv"
    ".local/share/fish"
    ".local/state"
    ".pki"
    ".tldrc"
    ".wakatime"
    "Documents"
    "Downloads"
    "Music"
    "Pictures"
    "Projects"
    "Sync"
    "Videos"
  ];

  # User cache directories to persist (important for IDE caches, etc.)
  userCacheDirs = [
    ".cache/bat"
    ".cache/.bun"
    ".cache/bookmarksrunner"
    ".cache/electron"
    ".cache/fastfetch"
    ".cache/github-copilot"
    ".cache/mesa_shader_cache"
    ".cache/nix"
    ".cache/pnpm"
    ".cache/systemsettings"
    ".cache/tldr"
  ];

  # User state directories
  userStateDirs = [
    ".local/share/icons/distrobox"
    ".local/state/syncthing"
    ".local/state/wireplumber"
  ];

  # User files to persist
  userFiles = [
    ".bash_history"
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
    {
      condition = config.virtualisation.docker.enable;
      dirs = [
        {
          directory = "/var/lib/docker";
          user = "root";
          group = "root";
          mode = "0700";
        }
      ];
    }
    {
      condition = config.virtualisation.podman.enable;
      dirs = [ "/var/lib/containers" ];
    }
    {
      condition = config.services.flatpak.enable;
      dirs = [ "/var/lib/flatpak" ];
    }
    {
      condition = config.services.fwupd.enable;
      dirs = [ "/var/lib/fwupd" ];
    }
    {
      condition = config.virtualisation.libvirtd.enable;
      dirs = [ "/var/lib/libvirt" ];
    }
    {
      condition = config.services.tailscale.enable;
      dirs = [ "/var/lib/tailscale" ];
    }
    {
      condition = config.services.tailscale.enable;
      dirs = [ "/var/cache/tailscale" ];
    }
    {
      condition = config.hardware.bluetooth.enable;
      dirs = [ "/var/lib/bluetooth" ];
    }
    {
      condition = config.services.vnstat.enable;
      dirs = [ "/var/lib/vnstat" ];
    }
  ];

  # Optional user data directories (gated by config)
  optionalUserDataDirs = [
    {
      condition = config.virtualisation.podman.enable;
      dirs = [ ".local/share/containers" ];
    }
    {
      condition = config.dr460nixed.development.jetbrains or false;
      dirs = [
        ".local/share/DBeaverData"
        ".local/share/JetBrains"
        ".eclipse"
      ];
    }
    {
      condition = config.dr460nixed.gaming.enable or false;
      dirs = [
        ".local/share/PrismLauncher"
        ".local/share/Steam"
        ".local/share/lutris"
        ".steam"
        "Games"
      ];
    }
    {
      condition = config.dr460nixed.desktops.kde or false;
      dirs = [
        ".local/share/baloo"
        ".local/share/dolphin"
        ".local/share/kactivitymanagerd"
        ".local/share/klipper"
        ".local/share/knewstuff3"
        ".local/share/konsole"
        ".local/share/kpeoplevcard"
        ".local/share/kscreen"
        ".local/share/kwalletd"
        ".local/share/plasma"
        ".local/share/plasma-systemmonitor"
      ];
    }
    {
      condition = config.dr460nixed.development.tools or false;
      dirs = [
        ".ansible"
        ".gemini"
        ".local/share/heroku"
        ".local/share/opencode"
        ".local/share/pnpm"
        ".local/share/yarn"
        ".local/share/zed"
        ".vscode"
      ];
    }
    {
      condition = config.dr460nixed.development.vms or false;
      dirs = [ "VirtualBox VMs" ];
    }
    {
      condition = config.dr460nixed.desktops.enable or false;
      dirs = [
        ".firedragon"
        ".gitkraken"
        ".local/share/AyuGramDesktop"
        ".local/share/Vorta"
        ".local/share/krita"
        ".mozilla"
        ".thunderbird"
      ];
    }
    {
      condition = config.dr460nixed.sync.nextcloud or config.dr460nixed.misc.nextcloud or false;
      dirs = [
        ".local/share/Nextcloud"
        "Nextcloud"
      ];
    }
    {
      condition = config.dr460nixed.development.enable or false;
      dirs = [
        ".android"
      ];
    }
    {
      condition = config.dr460nixed.yubikey.enable or false;
      dirs = [
        ".yubico"
      ];
    }
  ];

  # Optional user cache directories (gated by config)
  optionalUserCacheDirs = [
    {
      condition = config.dr460nixed.gaming.enable or false;
      dirs = [ ".cache/lutris" ];
    }
    {
      condition = config.dr460nixed.desktops.kde or false;
      dirs = [ ".cache/konsole" ];
    }
    {
      condition = config.dr460nixed.development.tools or false;
      dirs = [ ".cache/distrobox" ];
    }
    {
      condition = config.dr460nixed.desktops.enable or false;
      dirs = [
        ".cache/BraveSoftware"
        ".cache/firedragon"
        ".cache/mozilla"
        ".cache/thunderbird"
      ];
    }
    {
      condition = config.dr460nixed.desktops.spicetify or false;
      dirs = [ ".cache/spotify" ];
    }
    {
      condition = config.dr460nixed.development.jetbrains or false;
      dirs = [ ".cache/JetBrains" ];
    }
  ];

  # Flatten optional dirs based on conditions
  optionalDirs = lib.concatMap (s: if s.condition then s.dirs else [ ]) optionalServiceDirs;
  optionalUserDirs = lib.concatMap (s: if s.condition then s.dirs else [ ]) optionalUserDataDirs;
  optionalUserCache = lib.concatMap (s: if s.condition then s.dirs else [ ]) optionalUserCacheDirs;

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
        users = {
          "root" = {
            directories = rootDirs;
          };
        }
        // (lib.genAttrs cfg.persistentUsers (_name: {
          directories =
            userDataDirs
            # Optional user data directories
            ++ optionalUserDirs
            # Cache directories to persist (IDE caches, etc.)
            ++ userCacheDirs
            # Optional user cache directories
            ++ optionalUserCache
            # State directories
            ++ userStateDirs
            # Directories with special permissions
            ++ userDirsWithPerms;
          files = userFiles;
        }));
      };
    }
  );
}
