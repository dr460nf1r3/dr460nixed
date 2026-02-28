{
  config,
  lib,
  ...
}:
let
  cfg = config.dr460nixed.zfs;
in
{
  options.dr460nixed.zfs = with lib; {
    enable = mkEnableOption "Configures common options for using ZFS on NixOS.";
    sendMails = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc ''
        Enables sending status reports about ZFS maintenance via email.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    boot.supportedFilesystems = [ "zfs" ];

    boot.zfs.requestEncryptionCredentials = true;

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

    dr460nixed.smtp.enable = lib.mkIf cfg.sendMails true;

    services.zfs.zed.enableMail = lib.mkIf cfg.sendMails false;

    services.telegraf.extraConfig.inputs = lib.mkIf config.services.telegraf.enable {
      zfs.poolMetrics = true;
    };
  };
}
