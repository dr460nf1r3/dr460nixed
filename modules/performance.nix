{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.dr460nixed.performance-tweaks;
in
{
  options.dr460nixed.performance-tweaks = {
    enable = mkEnableOption "Enables a few performance tweaks";
  };

  config = mkIf cfg.enable {
    # Automatically tune nice levels
    services.ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
    };

    # Supply fitting rules for ananicy-cpp 
    environment.systemPackages = with pkgs; [
      ananicy-cpp-rules
    ];

    # Get notifications about earlyoom actions
    services.systembus-notify.enable = true;

    # 90% ZRAM as swap
    zramSwap = {
      enable = true;
      memoryPercent = 90;
    };

    # Earlyoom to prevent OOM situations
    services.earlyoom = {
      enable = true;
      enableNotifications = true;
      freeMemThreshold = 5;
    };

    # Tune the Zen kernel
    programs.cfs-zen-tweaks.enable = true;
  };
}
