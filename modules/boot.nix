{ config
, lib
, pkgs
, ...
}:
with lib;
let
  cfg = config.dr460nixed.systemd-boot;
  cfgLanza = config.dr460nixed.lanzaboote;
in
{
  options.dr460nixed.systemd-boot = {
    enable = mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Configures common options for a quiet systemd-boot.
        '';
      };
  };
  options.dr460nixed.lanzaboote = {
    enable = mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Configures common options using Lanzaboote as secure boot manager.
        '';
      };
  };

  config = {
    boot = {
      kernelParams = [
        "acpi_backlight=native"
        "iommu=full"
        "page_alloc.shuffle=1"
        "processor.max_cstate=5"
        "rd.systemd.show_status=auto"
        "rd.udev.log_level=3"
        "rootflags=noatime"
        "usbcore.autosuspend=-1"
        "vt.global_cursor_default=0"
      ];
      loader = mkIf cfg.enable {
        generationsDir.copyKernels = true;
        timeout = 1;
        systemd-boot = {
          consoleMode = "max";
          editor = false;
          enable = true;
        };
      };
    };

    # Needed if using Lanzaboote
    boot.lanzaboote = mkIf cfgLanza.enable {
      enable = true;
      pkiBundle = "/etc/secureboot";
    };
    environment.systemPackages = mkIf cfgLanza.enable [ pkgs.sbctl ];
  };
}
