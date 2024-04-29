{
  config,
  inputs,
  pkgs,
  ...
}: {
  # Individual settings + low-latency Pipewire
  imports = [
    ./hardware-configuration.nix
    ../modules/impermanence.nix
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];

  # Boot options
  boot = {
    # Needed to get the touchpad working
    blacklistedKernelModules = ["elan_i2c"];
    extraModulePackages = with config.boot.kernelPackages; [zenpower];
    supportedFilesystems = ["btrfs"];
  };

  # Hostname of this machine
  networking.hostName = "dragons-ryzen";

  # The services to use on this machine
  services = {
    hardware.bolt.enable = false;
    pipewire.lowLatency = {
      enable = true;
      quantum = 64;
      rate = 48000;
    };
    displayManager.sddm.settings = {
      Autologin = {
        Session = "plasma";
        User = "nico";
      };
    };
    xserver = {
      videoDrivers = ["amdgpu"];
    };
  };

  # Enable a few selected custom settings
  dr460nixed = {
    chromium = true;
    desktops.enable = true;
    development.enable = true;
    gaming.enable = false;
    performance = true;
    remote-build = {
      enable = true;
      host = "remote-build";
      port = 666;
      trustedPublicKey = "immortalis:8vrLBvFoMiKVKRYD//30bhUBTEEiuupfdQzl2UoMms4=";
      user = "nico";
    };
    school = true;
    tailscale = {
      enable = true;
      extraUpArgs = [
        "--accept-dns"
        "--accept-risk=lose-ssh"
        "--accept-routes"
        "--ssh"
      ];
    };
    systemd-boot.enable = true;
    yubikey = true;
  };

  # RADV video decode & general usage
  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
    RADV_VIDEO_DECODE = "1";
  };

  # Enable the touchpad & secure boot, as well as add the ipman script
  environment.systemPackages = with pkgs; [libinput radeontop zenmonitor];

  # Home-manager individual settings
  home-manager.users."nico" = import ../../home-manager/nico/nico.nix;

  # A few secrets
  sops.secrets = {
    # "ssh_keys/id_rsa" = {
    #   mode = "0600";
    #   owner = config.users.users.nico.name;
    #   path = "/home/nico/.ssh/id_rsa";
    # };
  };

  # For some reason Bluetooth only works after un-/reloading
  # the btusb kernel module
  systemd.services.fix-bluetooth = {
    wantedBy = ["multi-user.target"];
    description = "Fix bluetooth connection";
    path = with pkgs; [kmod];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "execstart" ''
        modprobe -r btusb
        sleep 1
        modprobe btusb
      '';
    };
  };

  # NixOS stuff
  system.stateVersion = "23.11";
}
