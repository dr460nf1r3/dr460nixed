{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.dr460nixed;
in {
  options.dr460nixed = {
    common = {
      enable =
        mkOption
        {
          default = true;
          type = types.bool;
          description = mdDoc ''
            Whether to enable common system configurations.
          '';
        };
    };
    rpi =
      mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Whether this is a Raspberry Pi.
        '';
      };
    nodocs =
      mkOption
      {
        default = true;
        type = types.bool;
        description = mdDoc ''
          Whether to disable the documentation.
        '';
      };
  };

  config = mkIf cfg.common.enable {
    ## A few kernel tweaks
    boot.kernel.sysctl = {"kernel.unprivileged_userns_clone" = 1;};

    # Allow wheel group users to use sudo
    security.sudo.execWheelOnly = true;

    # Increase open file limit for sudoers
    security.pam.loginLimits = [
      {
        domain = "@wheel";
        item = "nofile";
        type = "soft";
        value = "524288";
      }
      {
        domain = "@wheel";
        item = "nofile";
        type = "hard";
        value = "1048576";
      }
    ];

    # Always needed applications
    programs = {
      git = {
        enable = true;
        lfs.enable = true;
      };
      # The GnuPG agent
      gnupg.agent = {
        enable = true;
        pinentryPackage = lib.mkForce pkgs.pinentry-curses;
      };
    };

    # Who needs documentation when there is the internet? #bl04t3d
    documentation = mkIf cfg.nodocs {
      dev.enable = false;
      doc.enable = false;
      enable = true;
      info.enable = false;
      man.enable = false;
      nixos.enable = true;
    };

    # Enable all hardware drivers
    hardware.enableRedistributableFirmware = true;
  };
}
