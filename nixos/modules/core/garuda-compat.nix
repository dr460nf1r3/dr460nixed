{ config, lib, ... }:
let
  cfg = config.dr460nixed.garuda;
in
{
  options.dr460nixed.garuda = with lib; {
    catppuccin.enable = mkEnableOption "garuda catppuccin";
    garuda-nix-manager.enable = mkEnableOption "garuda-nix-manager";
    home-manager.modules = mkOption {
      type = types.listOf types.deferredModule;
      default = [ ];
      description = "Extra home-manager modules from garuda-nix";
    };
    audio.pipewire.enable = mkEnableOption "garuda pipewire";
    hardware.enable = mkEnableOption "garuda hardware";
    networking.enable = mkEnableOption "garuda networking";
    btrfs-maintenance = {
      enable = mkEnableOption "garuda btrfs maintenance";
      deduplication = mkEnableOption "garuda btrfs deduplication";
      uuid = mkOption {
        type = types.str;
        default = "";
      };
    };
    performance-tweaks.enable = mkEnableOption "garuda performance tweaks";
    noSddmAutologin = {
      enable = mkEnableOption "garuda no sddm autologin";
      startupCommand = mkOption {
        type = types.str;
        default = "";
      };
      user = mkOption {
        type = types.str;
        default = "";
      };
    };
  };

  config = {
    garuda = {
      catppuccin.enable = cfg.catppuccin.enable;
      garuda-nix-manager.enable = cfg.garuda-nix-manager.enable;
      home-manager.modules = cfg.home-manager.modules;
      audio.pipewire.enable = cfg.audio.pipewire.enable;
      hardware.enable = cfg.hardware.enable;
      networking.enable = cfg.networking.enable;
      btrfs-maintenance = {
        inherit (cfg.btrfs-maintenance) enable;
        inherit (cfg.btrfs-maintenance) deduplication;
        inherit (cfg.btrfs-maintenance) uuid;
      };
      performance-tweaks.enable = cfg.performance-tweaks.enable;
      noSddmAutologin = {
        inherit (cfg.noSddmAutologin) enable;
        inherit (cfg.noSddmAutologin) startupCommand;
        inherit (cfg.noSddmAutologin) user;
      };
    };
  };
}
