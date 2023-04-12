{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.dr460nixed.performance-tweaks;
in
{
  options.dr460nixed.performance-tweaks = {
    enable = lib.mkOption
      {
        default = false;
        type = types.bool;
        internal = true;
        description = lib.mdDoc ''
          Enables performance tweaks like ananicy-cpp.
        '';
      };
  };

  config = mkIf cfg.enable {
    # Automatically tune nice levels
    services.ananicy = {
      enable = true;
      package = pkgs.ananicy-cpp;
    };

    # Supply fitting rules for ananicy-cpp 
    environment.systemPackages = with pkgs; [
      ananicy-cpp-rules-git
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
