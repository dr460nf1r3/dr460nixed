{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.dr460nixed.systemd-boot;
  cfgGrub = config.dr460nixed.grub;
  cfgLanza = config.dr460nixed.lanzaboote;
  inherit (pkgs) plymouth;
in {
  options.dr460nixed.grub = {
    enable =
      mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Configures the system to install GRUB to a particular device, which enables booting
          on non-UEFI systems.
        '';
      };
    enableCryptodisk =
      mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Whether to enable GRUB cryptodisk support.
        '';
      };
    device =
      mkOption
      {
        default = null;
        type = types.str;
        description = mdDoc ''
          Defines which device to install GRUB to.
        '';
      };
  };
  options.dr460nixed.systemd-boot = {
    enable =
      mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Configures common options for a quiet systemd-boot.
        '';
      };
  };
  options.dr460nixed.lanzaboote = {
    enable =
      mkOption
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
        "quiet"
        "rd.systemd.show_status=auto"
        "rd.udev.log_level=3"
        "rootflags=noatime"
        "usbcore.autosuspend=-1"
        "vt.global_cursor_default=0"
      ];
      lanzaboote = mkIf cfgLanza.enable {
        enable = true;
        pkiBundle = "/etc/secureboot";
      };
      loader = {
        grub = {
          device = mkIf cfgGrub.enable cfgGrub.device;
          enable =
            if cfgGrub.enable
            then true
            else false;
          enableCryptodisk = true;
          useOSProber = false;
        };
        generationsDir.copyKernels = mkIf cfg.enable true;
        timeout = 1;
        systemd-boot = mkIf cfg.enable {
          consoleMode = "max";
          editor = false;
          enable = true;
        };
      };
    };

    # Make plymouth work with sleep
    powerManagement = {
      powerDownCommands = ''
        ${plymouth} --show-splash
      '';
      resumeCommands = ''
        ${plymouth} --quit
      '';
    };

    environment.systemPackages = mkIf cfgLanza.enable [pkgs.sbctl];
  };
}
