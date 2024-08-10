{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dr460nixed.syncthing;
  settingsFormat = pkgs.formats.json {};
in {
  options.dr460nixed.syncthing = {
    enable =
      lib.mkOption
      {
        default = false;
        type = lib.types.bool;
        description = lib.mdDoc ''
          Enable common file synchronisation between devices.
        '';
      };
    key =
      lib.mkOption
      {
        default = "";
        type = lib.types.str;
        description = lib.mdDoc ''
          The key to use for Syncthing.
        '';
      };
    cert =
      lib.mkOption
      {
        default = "";
        type = lib.types.str;
        description = lib.mdDoc ''
          The cert to use for Syncthing.
        '';
      };
    devices =
      lib.mkOption
      {
        default = [];
        type = lib.types.attrsOf (lib.types.submodule ({name, ...}: {
          freeformType = settingsFormat.type;
          options = {
            name = lib.mkOption {
              type = lib.types.str;
              default = name;
              description = lib.mdDoc ''
                The name of the device.
              '';
            };
            id = lib.mkOption {
              type = lib.types.str;
              description = lib.mdDoc ''
                The device ID. See <https://docs.syncthing.net/dev/device-ids.html>.
              '';
            };
            autoAcceptFolders = lib.mkOption {
              type = lib.types.bool;
              default = false;
              description = lib.mdDoc ''
                Automatically create or share folders that this device advertises at the default path.
                See <https://docs.syncthing.net/users/config.html?highlight=autoaccept#config-file-format>.
              '';
            };
          };
        }));
        description = lib.mdDoc ''
          The devices to sync with.
        '';
      };
    devicesNames =
      lib.mkOption
      {
        default = [];
        type = lib.types.listOf lib.types.str;
        description = lib.mdDoc ''
          The names of the devices to sync with.
        '';
      };
    user =
      lib.mkOption
      {
        default = "";
        type = lib.types.str;
        description = lib.mdDoc ''
          The user to run syncthing as.
        '';
      };
  };

  config = lib.mkIf cfg.enable {
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
