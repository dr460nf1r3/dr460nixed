{ config
, lib
, ...
}:
with lib;
let
  cfg = config.dr460nixed.systemd-boot;
in
{
  options.dr460nixed.systemd-boot = {
    enable = lib.mkOption
      {
        default = true;
        type = types.bool;
        internal = true;
        description = lib.mdDoc ''
          Configures common options for a quiet systemd-boot.
        '';
      };

    config = mkIf cfg.enable {
      boot = {
        consoleLogLevel = 0;
        initrd = {
          systemd.enable = true;
          verbose = false;
        };
        kernelParams = [
          "boot.shell_on_fail"
          "i915.fastboot=1"
          "quiet"
          "rd.udev.log_level=3"
          "splash"
          "udev.log_priority=3"
          "vt.global_cursor_default=0"
        ];
        # Enable memtest86+ on boot
        loader = {
          timeout = 1;
          systemd-boot.memtest86.enable = true;
        };
        # We need to override Stylix here to keep the splash
        plymouth = lib.mkForce {
          enable = false;
          theme = "bgrt";
        };
      };
    };
  };
}
