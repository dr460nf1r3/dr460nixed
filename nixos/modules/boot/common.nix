{
  config,
  lib,
  pkgs,
  ...
}:
let
  inherit (pkgs) plymouth;
in
{
  config = {
    boot = {
      kernelParams = [
        "acpi_backlight=native"
        "iommu=full"
        "page_alloc.shuffle=1"
        "processor.max_cstate=5"
        "quiet"
        "rd.systemd.show_status=auto"
        "rd.udev.log_level=3"
        "rootflags=noatime"
        "usbcore.autosuspend=-1"
        "vt.global_cursor_default=0"
      ];
      loader.timeout = lib.mkDefault 1;
    };

    # Make plymouth work with sleep
    powerManagement = lib.mkIf (config.boot.plymouth.enable or false) {
      powerDownCommands = ''
        ${plymouth} --show-splash
      '';
      resumeCommands = ''
        ${plymouth} --quit
      '';
    };
  };
}
