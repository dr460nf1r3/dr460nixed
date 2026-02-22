{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dr460nixed.systemd-boot;
  cfgGrub = config.dr460nixed.grub;
  cfgLanza = config.dr460nixed.lanzaboote;
  inherit (pkgs) plymouth;
in
{
  options.dr460nixed.grub = with lib; {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc ''
        Configures the system to install GRUB to a particular device, which enables booting
        on non-UEFI systems.
      '';
    };
    enableCryptodisk = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc ''
        Whether to enable GRUB cryptodisk support.
      '';
    };
    device = mkOption {
      default = null;
      type = types.str;
      description = mdDoc ''
        Defines which device to install GRUB to.
      '';
    };
  };
  options.dr460nixed.systemd-boot = with lib; {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc ''
        Configures common options for a quiet systemd-boot.
      '';
    };
  };
  options.dr460nixed.lanzaboote = with lib; {
    enable = mkOption {
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
        "quiet"
        "rd.systemd.show_status=auto"
        "rd.udev.log_level=3"
        "rootflags=noatime"
        "usbcore.autosuspend=-1"
        "vt.global_cursor_default=0"
      ];
      lanzaboote = lib.mkIf cfgLanza.enable {
        enable = true;
        pkiBundle = "/etc/secureboot";
      };
      loader = {
        grub = {
          device = lib.mkIf cfgGrub.enable cfgGrub.device;
          enable = if cfgGrub.enable then true else false;
          enableCryptodisk = true;
          useOSProber = false;
        };
        generationsDir.copyKernels = lib.mkIf cfg.enable true;
        timeout = 1;
        systemd-boot = lib.mkIf cfg.enable {
          consoleMode = "max";
          editor = false;
          enable = true;
        };
      };
    };

    # Make plymouth work with sleep
    powerManagement = lib.mkIf config.boot.plymouth.enable {
      powerDownCommands = ''
        ${plymouth} --show-splash
      '';
      resumeCommands = ''
        ${plymouth} --quit
      '';
    };

    environment.systemPackages = lib.mkIf cfgLanza.enable [ pkgs.sbctl ];
  };
}
