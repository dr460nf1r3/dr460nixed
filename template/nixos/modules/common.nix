{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dr460nixed;
in
{
  options.dr460nixed = with lib; {
    common = {
      enable = mkOption {
        default = true;
        type = types.bool;
        description = mdDoc ''
          Whether to enable common system configurations.
        '';
      };
    };
    rpi = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc ''
        Whether this is a Raspberry Pi.
      '';
    };
    nodocs = mkOption {
      default = true;
      type = types.bool;
      description = mdDoc ''
        Whether to disable the documentation.
      '';
    };
  };

  config = lib.mkIf cfg.common.enable {
    # A few kernel tweaks
    boot.kernelParams = [ "noresume" ];

    # Disable unprivileged user namespaces, unless containers are enabled
    security = {
      # User namespaces are required for sandboxing
      allowUserNamespaces = true;
      # This is only required for containers
      unprivilegedUsernsClone = config.virtualisation.containers.enable;
      # Force-enable the Page Table Isolation (PTI) Linux kernel feature
      forcePageTableIsolation = true;
    };

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
    documentation = lib.mkIf cfg.nodocs {
      dev.enable = false;
      doc.enable = false;
      enable = true;
      info.enable = false;
      man.enable = false;
      nixos.enable = true;
    };

    # Enable all hardware drivers
    hardware.enableRedistributableFirmware = true;

    # No need for that in real NixOS systems
    garuda.garuda-nix-manager.enable = false;

    # Custom label for boot menu entries (otherwise set to "garuda-nix-subsystem")
    system.nixos.label = lib.mkForce (
      builtins.concatStringsSep "-" [ "dr460nixed-" ] + config.system.nixos.version
    );
  };
}
