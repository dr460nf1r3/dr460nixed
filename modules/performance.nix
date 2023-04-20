{ config
, lib
, pkgs
, ...
}:
with lib;
let
  cfg = config.dr460nixed.performance-tweaks;
in
{
  options.dr460nixed.performance-tweaks = {
    enable = mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
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
      ananicy-cpp-rules
    ];

    # Get notifications about earlyoom actions
    services.systembus-notify.enable = true;

    # 90% ZRAM as swap
    zramSwap = {
      algorithm = "zstd";
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

    ## A few other kernel tweaks
    boot.kernel.sysctl = {
      "kernel.nmi_watchdog" = 0;
      "kernel.sched_cfs_bandwidth_slice_us" = 3000;
      "net.core.rmem_max" = 2500000;
      "vm.max_map_count" = 16777216;
      "vm.swappiness" = 60;
    };
  };
}
