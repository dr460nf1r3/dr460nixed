{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.dr460nixed.zfs;
in {
  options.dr460nixed.zfs = {
    enable =
      mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Configures common options for using ZFS on NixOS.
        '';
      };
  };

  config = mkIf cfg.enable {
    # Support booting off ZFS
    boot.supportedFilesystems = ["zfs"];

    # Always request encryption credentials to open rootfs
    boot.zfs.requestEncryptionCredentials = true;

    # Useful ZFS maintenance
    services.zfs = {
      autoScrub = {
        enable = true;
        interval = "weekly";
      };
      trim = {
        enable = true;
        interval = "weekly";
      };
    };
  };
}
