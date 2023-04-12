{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.dr460nixed;
in
{
  options.dr460nixed = {
    desktop = lib.mkOption
      {
        default = true;
        type = types.bool;
        internal = true;
        description = lib.mdDoc ''
          Whether this is a desktop device.
        '';
      };
    rpi = lib.mkOption
      {
        default = true;
        type = types.bool;
        internal = true;
        description = lib.mdDoc ''
          Whether this is a Raspberry Pi.
        '';
      };
    nodocs = lib.mkOption
      {
        default = true;
        type = types.bool;
        internal = true;
        description = lib.mdDoc ''
          Whether to disable the documentation.
        '';
      };
    common = {
      enable = lib.mkOption
        {
          default = true;
          type = types.bool;
          internal = true;
          description = lib.mdDoc ''
            Whether to enable common system configurations.
          '';
        };
    };
  };

  config = mkIf cfg.common.enable
    {
      # We want to use NetworkManager
      networking = {
        # Pointing to our Adguard instance via Tailscale
        nameservers = [ "1.1.1.1" ];
        networkmanager = lib.mkIf config.dr460nixed.desktop or config.dr460nixed.rpi {
          dns = "none";
          enable = true;
          wifi.backend = "iwd";
        };
        # Disable non-NetworkManager
        useDHCP = lib.mkDefault false;
      };
      ## Enable BBR & cake
      boot.kernelModules = [ "tcp_bbr" ];
      boot.kernel.sysctl = {
        "kernel.nmi_watchdog" = 0;
        "kernel.printks" = "3 3 3 3";
        "kernel.sched_cfs_bandwidth_slice_us" = 3000;
        "kernel.sysrq" = 1;
        "kernel.unprivileged_userns_clone" = 1;
        "net.core.default_qdisc" = "cake";
        "net.core.rmem_max" = 2500000;
        "net.ipv4.tcp_congestion_control" = "bbr";
        "net.ipv4.tcp_fin_timeout" = 5;
        "vm.max_map_count" = 16777216; # helps with Wine ESYNC/FSYNC
        "vm.swappiness" = 60;
      };

      # Microcode and firmware updates
      hardware = {
        cpu = {
          amd.updateMicrocode = true;
          intel.updateMicrocode = true;
        };
        enableRedistributableFirmware = true;
      };
      services.fwupd.enable = true;

      # # Kernel paramters & settings
      # boot = lib.mkIf config.dr460nixed.desktop {
      #   kernelParams = [
      #     # Disable all mitigations
      #     "mitigations=off"
      #     "nopti"
      #     "tsx=on"
      #     # Laptops and desktops don't need watchdog
      #     "nowatchdog"
      #     # https://github.com/NixOS/nixpkgs/issues/35681#issuecomment-370202008
      #     "systemd.gpt_auto=0"
      #     # https://www.phoronix.com/news/Linux-Splitlock-Hurts-Gaming
      #     "split_lock_detect=off"
      #   ];
      # };

      # We want to be insulted on wrong passwords
      security.sudo = {
        execWheelOnly = true;
        extraConfig = ''
          Defaults pwfeedback
          deploy ALL=(ALL) NOPASSWD:ALL
        '';
        package = pkgs.sudo.override { withInsults = true; };
      };

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

      # Programs I always need
      programs = {
        git = {
          enable = true;
          lfs.enable = true;
        };
        # The GnuPG agent
        gnupg.agent.enable = true;
        # Use the performant openssh
        ssh.package = pkgs.openssh_hpn;
      };

      # Always needed services
      services = {
        locate = {
          enable = true;
          localuser = null;
          locate = pkgs.plocate;
        };
        openssh = {
          enable = true;
          startWhenNeeded = true;
        };
        vnstat.enable = true;
      };

      # Better for mobile device SSH
      programs.mosh.enable = true;
      environment.variables = { MOSH_SERVER_NETWORK_TMOUT = "604800"; };

      # Who needs documentation when there is the internet? #bl04t3d
      documentation = lib.mkIf config.dr460nixed.nodocs {
        doc.enable = false;
        enable = false;
        info.enable = false;
        man.enable = false;
        nixos.enable = false;
      };

      # Zerotier network to connect the devices
      networking.firewall.trustedInterfaces = [ "tailscale0" ];
      services.tailscale = {
        enable = true;
        permitCertUid = "nico";
      };

      # Automatic system upgrades
      system.autoUpgrade = {
        enable = true;
        dates = "hourly";
        flags = [ "--refresh" ];
        flake = "github:dr460nf1r3/device-configurations";
      };
    };
}
