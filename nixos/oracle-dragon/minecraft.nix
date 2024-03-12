{
  inputs,
  pkgs,
  ...
}: {
  services.minecraft-servers = {
    enable = true;
    eula = true;
    servers.survival = {
      enable = true;
      enableReload = true;
      package = inputs.nix-minecraft.legacyPackages.aarch64-linux.paperServers.paper-1_20_4;
      jvmOpts = ((import ./aikar-flags.nix) "8G") + "-Dpaper.disableChannelLimit=true";
      serverProperties = {
        default-player-permission-level = "visitor";
        difficulty = "normal";
        enforce-whitelist = true;
        motd = "Welcome to Utopia <3";
        online-mode = true;
        resource-pack = "https://cdn.modrinth.com/data/r4GILswZ/versions/gWTrUifI/Faithful%2064x.zip";
        resource-pack-sha1 = "88add430a01a1acb49a8e81bb96f7ba200bc80bf";
        server-port = 25565;
        snooper-enabled = false;
        white-list = true;
      };
      files = {
        "bukkit.yml".value = {
          settings.shutdown-message = "The server is restarting. Please reconnect in a few seconds.";
        };
        "plugins/BlueMap/core.yml".value = {
          accept-download = true;
        };
        "plugins/ViaVersion/config.yml".value = {
          checkforupdates = false;
        };
      };
      symlinks = {
        "plugins/BlueMap.jar" = pkgs.fetchurl rec {
          pname = "BlueMap";
          version = "3.20";
          url = "https://hangarcdn.papermc.io/plugins/Blue/${pname}/versions/${version}/PAPER/${pname}-${version}-paper.jar";
          hash = "sha256-DXqxpYy6w/oYyBDmmky0ilbKFYzvkNmSv9B2tkCwFgU=";
        };
        "plugins/Chunky.jar" = pkgs.fetchurl rec {
          pname = "Chunky";
          version = "1.3.136";
          url = "https://hangarcdn.papermc.io/plugins/pop4959/${pname}/versions/${version}/PAPER/${pname}-${version}.jar";
          hash = "sha256-rVLFb+CkP+rmZJ4kHgtpp1TeL7yn/kQOCnH/YFzxTdg=";
        };
        "plugins/EssentialsX.jar" = pkgs.fetchurl rec {
          pname = "EssentialsX";
          version = "2.20.1";
          url = "https://github.com/EssentialsX/Essentials/releases/download/${version}/${pname}-${version}.jar";
          hash = "sha256-gC6jC9pGDKRZfoGJJYFpM8EjsI2BJqgU+sKNA6Yb9UI=";
        };
        "plugins/Floodgate.jar" = let
          build = "96";
        in
          pkgs.fetchurl rec {
            pname = "Floodgate";
            version = "2.2.2";
            url = "https://download.geysermc.org/v2/projects/floodgate/versions/${version}/builds/${build}/downloads/spigot";
            hash = "sha256-IBNCI0aot8tQo+RuNrvxCETVDVCKR70RXdb9mg9KXLM=";
          };
        "plugins/Geyser.jar" = let
          build = "459";
        in
          pkgs.fetchurl rec {
            pname = "Geyser";
            version = "2.2.2";
            url = "https://download.geysermc.org/v2/projects/geyser/versions/${version}/builds/${build}/downloads/spigot";
            hash = "sha256-OZDt0eOcx+bbGbfRjjnkrEo+P7eREDt2VTmk3jHFPmo=";
          };
        "plugins/GeyserHacks.jar" = pkgs.fetchurl rec {
          pname = "GeyserHacks";
          version = "1.2-SNAPSHOT-4";
          url = "https://github.com/GeyserMC/Hurricane/releases/download/${version}/${pname}.jar";
          hash = "sha256-fDb+D94XLtSCcDM0DBQ6hDNhE+YVLti9Wo5sX1fkKk4=";
        };
        "plugins/Multiverse-Core.jar" = pkgs.fetchurl rec {
          pname = "Multiverse-Core";
          version = "4.3.12";
          url = "https://github.com/Multiverse/${pname}/releases/download/${version}/multiverse-core-${version}.jar";
          hash = "sha256-mCN6rzXG7nv9lft/OZ73A7PnK/+Oq0iKkEqtnUUwzRA=";
        };
        "plugins/Multiverse-NetherPortals.jar" = pkgs.fetchurl rec {
          pname = "Multiverse-NetherPortals";
          version = "4.2.3";
          url = "https://github.com/Multiverse/${pname}/releases/download/${version}/multiverse-netherportals-${version}.jar";
          hash = "sha256-lyg5Vak62oL15wk4gDhII+IkZxl4uOZ2njwnuhWxusM=";
        };
        "plugins/Multiverse-Portals.jar" = pkgs.fetchurl rec {
          pname = "Multiverse-Portals";
          version = "4.2.3";
          url = "https://github.com/Multiverse/${pname}/releases/download/${version}/multiverse-portals-${version}.jar";
          hash = "sha256-6m5Qx3HZeCAh4LxJuVpO2hT7wv8gUfIx/Gruxkvl+aA=";
        };
        "plugins/ViaBackwards.jar" = pkgs.fetchurl rec {
          pname = "ViaBackwards";
          version = "4.9.2";
          url = "https://github.com/ViaVersion/${pname}/releases/download/${version}/${pname}-${version}.jar";
          hash = "sha256-CWMpaHARNbkqnUaGT0JCjWrRYOjRHhWDqacUo/N+CH4=";
        };
        "plugins/ViaVersion.jar" = pkgs.fetchurl rec {
          pname = "ViaVersion";
          version = "4.9.3";
          url = "https://github.com/ViaVersion/${pname}/releases/download/${version}/${pname}-${version}.jar";
          hash = "sha256-cJCUUUIyYTas2eC5kK+zzod1YVTlWQ0ktvIG1pxHCrA=";
        };
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [25565];
    allowedUDPPorts = [25565 19132];
  };
}
