{
  config,
  lib,
  ...
}:
let
  cfg = config.dr460nixed.oci;
in
{
  options.dr460nixed.oci = with lib; {
    enable = mkEnableOption "Enable common options for Oracle cloud instances.";
  };

  config = lib.mkIf cfg.enable {
    boot = {
      kernelParams = [
        "nvme.shutdown_timeout=10"
        "nvme_core.shutdown_timeout=10"
        "libiscsi.debug_libiscsi_eh=1"
        "crash_kexec_post_notifiers"
        "console=tty1"
        "console=ttyS0"
        "console=ttyAMA0,115200"
      ];
      loader.grub = {
        device = "nodev";
        efiInstallAsRemovable = true;
        efiSupport = true;
        enable = lib.mkForce true;
        extraConfig = ''
          serial --unit=0 --speed=115200 --word=8 --parity=no --stop=1
          terminal_input --append serial
          terminal_output --append serial
        '';
        splashImage = null;
      };
    };

    # https://docs.oracle.com/en-us/iaas/Content/Compute/Tasks/configuringntpservice.htm#Configuring_the_Oracle_Cloud_Infrastructure_NTP_Service_for_an_Instance
    networking.timeServers = [ "169.254.169.254" ];

    nix.settings.auto-optimise-store = lib.mkForce false;

    hardware.cpu = {
      amd.updateMicrocode = lib.mkForce false;
      intel.updateMicrocode = lib.mkForce false;
    };
  };
}
