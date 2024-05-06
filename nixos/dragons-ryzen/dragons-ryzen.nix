{
  lib,
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
    initrd.kernelModules = ["amdgpu"];
    supportedFilesystems = ["btrfs"];
  };

  # Hostname of this machine
  networking.hostName = "dragons-ryzen";

  # The services to use on this machine
  services = {
    # This is going to be a device with autologin
    # straight to desktop. No display manager needed.
    displayManager = {
      enable = lib.mkForce false;
      sddm.enable = false;
    };
    getty.autologinUser = "nico";
    hardware.bolt.enable = false;
    pipewire.lowLatency = {
      enable = true;
      quantum = 64;
      rate = 48000;
    };
    xserver.enable = false;
  };

  # Needed for autologin in TTY to start the desktop session
  programs.bash.loginShellInit = ''
    if [[ -z $DISPLAY ]] && [[ $(tty) = /dev/tty1 ]]; then
        exec startplasma-wayland
    fi
  '';

  # Enable a few selected custom settings
  dr460nixed = {
    chromium = true;
    desktops.enable = true;
    development.enable = true;
    gaming.enable = true;
    lanzaboote.enable = true;
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
    yubikey = true;
  };

  # Garuda Nix subsystem modules
  garuda.btrfs-maintenance = {
    deduplication = false;
    enable = true;
    uuid = "7f894697-a4e9-43a7-bdd8-00c0376ce1f9";
  };

  # Override GNS defaults
  environment.variables = {
    QT_STYLE_OVERRIDE = lib.mkForce "";
    GTK_THEME = lib.mkForce "";
  };

  # Chaotic Nyx stuff
  chaotic = {
    mesa-git.enable = true;
    scx = {
      enable = true;
      scheduler = "scx_rustland";
    };
  };

  # RADV video decode & general usage
  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
    RADV_VIDEO_DECODE = "1";
  };

  # Enable the touchpad & secure boot, as well as add the ipman script
  environment.systemPackages = with pkgs; [libinput radeontop scx];

  # Home-manager individual settings
  home-manager.users."nico" = import ../../home-manager/nico/nico.nix;

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
