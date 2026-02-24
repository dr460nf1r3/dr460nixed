{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfgLanza = config.dr460nixed.lanzaboote;
in
{
  imports = [
    ./common.nix
    ./grub.nix
    ./lanzaboote.nix
    ./systemd-boot.nix
  ];

  options.dr460nixed = with lib; {
    grub = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = mdDoc "Configures the system to install GRUB to a particular device.";
      };
      enableCryptodisk = mkOption {
        default = false;
        type = types.bool;
        description = mdDoc "Whether to enable GRUB cryptodisk support.";
      };
      device = mkOption {
        default = "nodev";
        type = types.str;
        description = mdDoc "Defines which device to install GRUB to.";
      };
    };
    systemd-boot = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = mdDoc "Configures common options for a quiet systemd-boot.";
      };
    };
    lanzaboote = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = mdDoc "Configures common options using Lanzaboote as secure boot manager.";
      };
    };
  };

  config = {
    environment.systemPackages = lib.mkIf cfgLanza.enable [ pkgs.sbctl ];
  };
}
