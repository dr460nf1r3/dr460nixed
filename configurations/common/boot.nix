{
  pkgs,
  lib,
  ...
}: {
  # Make the boot sequence quiet & enable the systemd initrd
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
}
