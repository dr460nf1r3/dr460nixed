{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dr460nixed.nvidia;
in
{
  options.dr460nixed.nvidia = with lib; {
    enable = mkEnableOption "Whether to enable NVIDIA GPU support with proprietary drivers.";
    open = lib.mkEnableOption "Whether to use the open-source NVIDIA kernel module (Turing+)." // {
      default = true;
    };
    prime = {
      enable = mkEnableOption "Whether to enable PRIME offload for hybrid graphics.";
      nvidiaBusId = mkOption {
        default = "";
        type = types.str;
        description = mdDoc ''
          Bus ID of the NVIDIA GPU, e.g. "PCI:1:0:0".
        '';
      };
      amdgpuBusId = mkOption {
        default = null;
        type = types.nullOr types.str;
        description = mdDoc ''
          Bus ID of the AMD iGPU for AMD+NVIDIA hybrid setups.
        '';
      };
      intelBusId = mkOption {
        default = null;
        type = types.nullOr types.str;
        description = mdDoc ''
          Bus ID of the Intel iGPU for Intel+NVIDIA hybrid setups.
        '';
      };
    };
  };

  config = lib.mkIf cfg.enable (
    lib.mkMerge [
      {
        boot = {
          initrd.kernelModules = [
            "nvidia"
            "nvidia_drm"
            "nvidia_modeset"
            "nvidia_uvm"
          ];
          blacklistedKernelModules = [ "nouveau" ];
        };

        services.xserver.videoDrivers = [ "nvidia" ];

        hardware.nvidia = {
          modesetting.enable = true;
          inherit (cfg) open;
          nvidiaSettings = true;
          package = config.boot.kernelPackages.nvidiaPackages.beta;
          powerManagement.enable = true;
        };

        hardware.graphics = {
          extraPackages = with pkgs; [
            nvidia-vaapi-driver
          ];
        };
      }

      (lib.mkIf cfg.prime.enable {
        hardware.nvidia.prime = {
          offload = {
            enable = true;
            enableOffloadCmd = true;
          };
          inherit (cfg.prime) nvidiaBusId;
          amdgpuBusId = lib.mkIf (cfg.prime.amdgpuBusId != null) cfg.prime.amdgpuBusId;
          intelBusId = lib.mkIf (cfg.prime.intelBusId != null) cfg.prime.intelBusId;
        };

        hardware.nvidia.powerManagement.finegrained = true;
      })
    ]
  );
}
