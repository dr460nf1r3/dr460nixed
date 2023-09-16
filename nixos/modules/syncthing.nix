{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.dr460nixed.syncthing;
  settingsFormat = pkgs.formats.json {};
in {
  options.dr460nixed.syncthing = {
    enable =
      mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Enable common file synchronisation between devices.
        '';
      };
    key =
      mkOption
      {
        default = "";
        type = types.str;
        description = mdDoc ''
          The key to use for Syncthing.
        '';
      };
    cert =
      mkOption
      {
        default = "";
        type = types.str;
        description = mdDoc ''
          The cert to use for Syncthing.
        '';
      };
    devices =
      mkOption
      {
        default = [];
        type = types.attrsOf (types.submodule ({name, ...}: {
          freeformType = settingsFormat.type;
          options = {
            name = mkOption {
              type = types.str;
              default = name;
              description = lib.mdDoc ''
                The name of the device.
              '';
            };
            id = mkOption {
              type = types.str;
              description = mdDoc ''
                The device ID. See <https://docs.syncthing.net/dev/device-ids.html>.
              '';
            };
            autoAcceptFolders = mkOption {
              type = types.bool;
              default = false;
              description = mdDoc ''
                Automatically create or share folders that this device advertises at the default path.
                See <https://docs.syncthing.net/users/config.html?highlight=autoaccept#config-file-format>.
              '';
            };
          };
        }));
        description = mdDoc ''
          The devices to sync with.
        '';
      };
    devicesNames =
      mkOption
      {
        default = [];
        type = types.listOf types.str;
        description = mdDoc ''
          The names of the devices to sync with.
        '';
      };
    user =
      mkOption
      {
        default = "";
        type = types.str;
        description = mdDoc ''
          The user to run syncthing as.
        '';
      };
  };

  config = mkIf cfg.enable {
    services.syncthing = {
      inherit (cfg) cert;
      dataDir = "/home/${cfg.user}";
      enable = true;
      inherit (cfg) key;
      settings = {
        inherit (cfg) devices;
        folders = {
          "/home/nico/Music" = {
            id = "ybqqh-as53c";
            devices = cfg.devicesNames;
          };
          "/home/nico/Pictures" = {
            id = "9gj2u-j3m9s";
            devices = cfg.devicesNames;
          };
          "/home/nico/School" = {
            id = "g5jha-cnrr4";
            devices = cfg.devicesNames;
          };
          "/home/nico/Sync" = {
            id = "u62ge-wzsau";
            devices = cfg.devicesNames;
          };
          "/home/nico/Videos" = {
            id = "nxhpo-c2j5b";
            devices = cfg.devicesNames;
          };
        };
        options = {
          localAnnounceEnabled = true;
          urAccepted = -1;
        };
      };
      inherit (cfg) user;
    };
  };
}
