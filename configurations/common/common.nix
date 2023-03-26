{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./boot.nix
    ./hardening.nix
    ./locales.nix
    ./nix.nix
    ./shells.nix
    ./sops.nix
    ./theming.nix
    ./users.nix
    ../../overlays/default.nix
  ];

  ## Enable BBR & cake
  boot.kernelModules = ["tcp_bbr"];
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
    "vm.swappiness" = 60;
  };

  # We want to be insulted on wrong passwords
  security.sudo = {
    execWheelOnly = true;
    extraConfig = ''
      Defaults pwfeedback
      deploy ALL=(ALL) NOPASSWD:ALL
    '';
    package = pkgs.sudo.override {withInsults = true;};
  };

  # Programs I always need
  programs = {
    git = {
      enable = true;
      lfs.enable = true;
    };
    gnupg.agent.enable = true;
    # Better for mobile device SSH
    mosh.enable = true;
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

  # Earlyoom for oom situations
  services.earlyoom = {
    enable = true;
    enableNotifications = true;
    freeMemThreshold = 5;
  };

  # Get notifications about earlyoom actions
  services.systembus-notify.enable = true;

  # Environment
  environment.variables = {MOSH_SERVER_NETWORK_TMOUT = "604800";};

  # Enable all the firmwares
  hardware.enableRedistributableFirmware = true;

  # Who needs documentation when there is the internet? #bl04t3d
  documentation = {
    doc.enable = false;
    enable = false;
    info.enable = false;
    man.enable = false;
    nixos.enable = false;
  };

  # Zerotier network to connect the devices
  networking.firewall.trustedInterfaces = ["ztnfaljg5n"];
  services.zerotierone = {
    enable = true;
    joinNetworks = ["a84ac5c10a715aa7"];
  };

  # Zerotier hosts for easy access
  networking.hosts = {
    "10.241.1.1" = ["slim-lair"];
    "10.241.1.2" = ["tv-nixos"];
    "10.241.1.3" = [
      "adguard.dragons.lair"
      "code.dragons.lair"
      "dns.dragons.lair"
      "home.dragons.lair"
      "netdata.dragons.lair"
      "oracle-dragon"
    ];
    "10.241.1.4" = ["rpi-dragon"];
    "10.241.1.5" = ["pixel"];
  };

  # Trust our self signed certificate for local services
  sops.secrets."ssl/home-dragon-ca" = {
    mode = "0644";
    owner = config.users.users.root.name;
    path = "/run/secrets/ssl/home-dragon-ca";
  };

  # Override certificate store with my custom home-dragon certificate
  security.pki.certificateFiles = [
    config.sops.secrets."ssl/home-dragon-ca".path
  ];
}
