{ config
, pkgs
, lib
, ...
}: {
  # Individual settings
  imports = [
    ../../configurations/common.nix
    ../../configurations/desktops/connectivity.nix
    ../../configurations/desktops/networking.nix
    ../../configurations/desktops/performance.nix
    ../../configurations/servers.nix
    "${builtins.fetchGit {
      url = "https://github.com/NixOS/nixos-hardware.git";
      rev = "f38f9a4c9b2b6f89a5778465e0afd166a8300680";
    }}/raspberry-pi/4"
    ./hardware-configuration.nix
  ];

  # Our hostname
  networking.hostName = "rpi-dragon";

  # Kernel defaults
  boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;
    tmpOnTmpfs = true;
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
    # Fix https://github.com/NixOS/nixpkgs/pull/207969
    initrd.systemd.enable = lib.mkForce false;
    # ttyAMA0 is the serial console broken out to the GPIO
    kernelParams = [
      "8250.nr_uarts=1"
      "cma=128M"
      "console=tty1"
      "console=ttyAMA0,115200"
    ];
  };

  # Enable hardware acceleration
  hardware.raspberry-pi."4".fkms-3d.enable = true;

  # Custom garbage collection defaults
  nix = {
    # Free up to 1GiB whenever there is less than 100MiB left & allow remote-building
    extraOptions = lib.mkForce ''
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
      builders-use-substitutes = true
    '';
  };

  # Cloudflared tunnel configurations
  services.cloudflared = {
    enable = true;
    tunnels = {
      "a2da25c2-eaec-43a4-8a7e-d5c49f9ac6ae" = {
        credentialsFile = config.sops.secrets."cloudflared/rpi/cred".path;
        default = "http_status:404";
        #ingress = {
        #"code.dr460nf1r3.org" = {
        #  service = "http://localhost:4444";
        #};
        #};
      };
    };
  };
  sops.secrets."cloudflared/rpi/cred" = {
    mode = "0600";
    owner = config.users.users.cloudflared.name;
    path = "/run/secrets/cloudflared/rpi/cred";
  };

  # Add remote build machine
  nix.buildMachines = [
    {
      hostName = "oracle-dragon";
      system = "aarch64-linux";
      maxJobs = 4;
      speedFactor = 2;
      supportedFeatures = [ "nixos-test" "benchmark" "big-parallel" "kvm" ];
      mandatoryFeatures = [ ];
    }
  ];
  nix.distributedBuilds = true;

  # Supply needed SSH key for accessing oracle-dragon
  sops.secrets."ssh_keys/deploy_ed25519" = {
    mode = "0600";
    owner = config.users.users.root.name;
    path = "/root/.ssh/id_ed25519";
  };

  # The key needed for using oracle-dragon as remote builder
  # home-manager.users."root".programs.ssh.matchBlocks = {
  #   "oracle-dragon" = {
  #     HostName = "oracle-dragon";
  #     IdentityFile = config.sops.secrets."ssh_keys/deploy_ed25519".path;
  #     User = "deploy";
  #   };
  # };

  # NixOS stuff
  system.stateVersion = "22.11";
}
