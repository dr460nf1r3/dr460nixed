{
  config,
  lib,
  ...
}: let
  cfg = config.dr460nixed.zfs;
in {
  options.dr460nixed.zfs = with lib; {
    enable =
      mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Configures common options for using ZFS on NixOS.
        '';
      };
    sendMails =
      mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Enables sending status reports about ZFS maintenance via email.
        '';
      };
  };

  config = lib.mkIf cfg.enable {
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

    # Enable configuration of msmtp
    dr460nixed.smtp.enable = lib.mkIf cfg.sendMails true;

    # Configure ZFS Event Daemon to use msmtp
    # commented until python2.7-oildev is fixed
    # services.zfs.zed.settings = mkIf cfg.sendMails {
    #   ZED_DEBUG_LOG = "/tmp/zed.debug.log";
    #   ZED_EMAIL_ADDR = ["root"];
    #   ZED_EMAIL_OPTS = "@ADDRESS@";
    #   ZED_EMAIL_PROG = "${pkgs.msmtp}/bin/msmtp";

    #   ZED_NOTIFY_INTERVAL_SECS = 3600;
    #   ZED_NOTIFY_VERBOSE = true;

    #   ZED_SCRUB_AFTER_RESILVER = true;
    #   ZED_USE_ENCLOSURE_LEDS = true;
    # };

    # This option does not work; will return error
    services.zfs.zed.enableMail = lib.mkIf cfg.sendMails false;

    # Metrics
    services.telegraf.extraConfig.inputs = lib.mkIf config.services.telegraf.enable {
      zfs.poolMetrics = true;
    };
  };
}
