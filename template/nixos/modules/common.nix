{
  config,
  lib,
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
    # Allow unprivileged users to create user namespaces
    boot.kernel.sysctl = {"kernel.unprivileged_userns_clone" = 1;};

    # Custom label for boot menu entries (mkForce to override GNS default)
    system.nixos.label = ["dr460nixed-"];

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
        pinentryFlavor = "curses";
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
