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
        motd = "Welcome to Utopia <3";
        server-port = 25565;
        online-mode = true;
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
        "plugins/ViaVersion.jar" = pkgs.fetchurl rec {
          pname = "ViaVersion";
          version = "4.9.2";
          url = "https://github.com/ViaVersion/${pname}/releases/download/${version}/${pname}-${version}.jar";
          hash = "sha256-jVBjs4hEV464xM0Edp1nGCefyIePG5/H7aavP/+9/o0=";
        };
        "plugins/ViaBackwards.jar" = pkgs.fetchurl rec {
          pname = "ViaBackwards";
          version = "4.9.1";
          url = "https://github.com/ViaVersion/${pname}/releases/download/${version}/${pname}-${version}.jar";
          hash = "sha256-j/mjgQwOn6C8VKtVcc/9gFSWzWLevaUwZDOZl7vXqGs=";
        };
        "plugins/BlueMap.jar" = pkgs.fetchurl rec {
          pname = "BlueMap";
          version = "3.20";
          url = "https://hangarcdn.papermc.io/plugins/Blue/${pname}/versions/${version}/PAPER/${pname}-${version}-paper.jar";
          hash = "sha256-DXqxpYy6w/oYyBDmmky0ilbKFYzvkNmSv9B2tkCwFgU=";
        };
        "plugins/Floodgate.jar" = let
          build = "87";
        in
          pkgs.fetchurl rec {
            pname = "Floodgate";
            version = "2.2.2";
            url = "https://download.geysermc.org/v2/projects/floodgate/versions/${version}/builds/${build}/downloads/spigot";
            hash = "sha256-IBNCI0aot8tQo+RuNrvxCETVDVCKR70RXdb9mg9KXLM=";
          };
        "plugins/Geyser.jar" = let
          build = "410";
        in
          pkgs.fetchurl rec {
            pname = "Geyser";
            version = "2.2.0";
            url = "https://download.geysermc.org/v2/projects/geyser/versions/${version}/builds/${build}/downloads/spigot";
            hash = "sha256-bh2nKl/b+8JkNuoYvFPCuuVGH8JfSZD/ryI1h/aEUOM=";
          };
        "plugins/GeyserHacks.jar" = pkgs.fetchurl rec {
          pname = "GeyserHacks";
          version = "1.2-SNAPSHOT-4";
          url = "https://github.com/GeyserMC/Hurricane/releases/download/${version}/${pname}.jar";
          hash = "sha256-fDb+D94XLtSCcDM0DBQ6hDNhE+YVLti9Wo5sX1fkKk4=";
        };
        "plugins/EssentialsX.jar" = pkgs.fetchurl rec {
          pname = "EssentialsX";
          version = "2.20.1";
          url = "https://github.com/EssentialsX/Essentials/releases/download/${version}/${pname}-${version}.jar";
          hash = "sha256-gC6jC9pGDKRZfoGJJYFpM8EjsI2BJqgU+sKNA6Yb9UI=";
        };
        "plugins/Chunky.jar" = pkgs.fetchurl rec {
          pname = "Chunky";
          version = "1.3.92";
          url = "https://hangarcdn.papermc.io/plugins/pop4959/${pname}/versions/${version}/PAPER/${pname}-${version}.jar";
          hash = "sha256-ABHfKJK0LQI2ZLt1D83897RAnE9xWu6+34IOlwTh17w=";
        };
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [25565];
    allowedUDPPorts = [25565 19132];
  };
}
