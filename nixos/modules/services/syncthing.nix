{
  config,
  dragonLib,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dr460nixed.syncthing;
  settingsFormat = pkgs.formats.json { };
in
{
  options.dr460nixed.syncthing = {
    enable = lib.mkEnableOption "Enable common file synchronisation between devices.";
    key = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.str;
      description = lib.mdDoc ''
        The key to use for Syncthing.
      '';
    };
    cert = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.str;
      description = lib.mdDoc ''
        The cert to use for Syncthing.
      '';
    };
    devices = lib.mkOption {
      default = dragonLib.syncthing.getDevicesFor config.networking.hostName;
      type = lib.types.attrsOf (
        lib.types.submodule (
          { name, ... }:
          {
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
          }
        )
      );
      description = lib.mdDoc ''
        The devices to sync with.
      '';
    };
    devicesNames = lib.mkOption {
      default = lib.attrNames cfg.devices;
      type = lib.types.listOf lib.types.str;
      description = lib.mdDoc ''
        The names of the devices to sync with.
      '';
    };
    user = lib.mkOption {
      default = null;
      type = lib.types.nullOr lib.types.str;
      description = lib.mdDoc ''
        The user to run syncthing as.
      '';
    };
    folders = lib.mkOption {
      default = { };
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            id = lib.mkOption { type = lib.types.str; };
            path = lib.mkOption { type = lib.types.str; };
            devices = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [ ];
            };
            ignorePatterns = lib.mkOption {
              type = lib.types.listOf lib.types.str;
              default = [
                ".directory"
                ".thumbnails"
              ];
            };
          };
        }
      );
      description = lib.mdDoc "Folders to sync.";
    };
  };

  config = lib.mkIf cfg.enable {
    services.syncthing = {
      inherit (cfg) cert;
      dataDir = lib.mkIf (cfg.user != null) "/home/${cfg.user}";
      enable = true;
      inherit (cfg) key;
      settings = {
        inherit (cfg) devices;
        folders = lib.mapAttrs (_name: folder: {
          inherit (folder)
            id
            path
            devices
            ignorePatterns
            ;
        }) cfg.folders;
        options = {
          localAnnounceEnabled = true;
          urAccepted = -1;
        };
      };
      user = lib.mkIf (cfg.user != null) cfg.user;
    };
  };
}
