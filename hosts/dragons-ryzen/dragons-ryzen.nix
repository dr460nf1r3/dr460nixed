{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
    ../../nixos/modules/impermanence
    ../../users/nico/nixos.nix
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];

  sops.secrets."api_keys/sops" = lib.mkIf config.dr460nixed.development.enable {
    mode = "0600";
    owner = "nico";
    path = "/home/nico/.config/sops/age/keys.txt";
  };
  sops.secrets."api_keys/heroku" = lib.mkIf config.dr460nixed.development.enable {
    mode = "0600";
    owner = "nico";
    path = "/home/nico/.netrc";
  };
  sops.secrets."api_keys/cloudflared" = lib.mkIf config.dr460nixed.development.enable {
    mode = "0600";
    owner = "nico";
    path = "/home/nico/.cloudflared/cert.pem";
  };

  dr460nixed.impermanence.persistentUsers = [ "nico" ];

  dr460nixed.smtp = {
    from = "nico@dr460nf1r3.org";
    passwordeval = "cat /run/secrets/passwords/nico@dr460nf1r3.org";
    user = "nico@dr460nf1r3.org";
  };

  dr460nixed.syncthing = {
    user = "nico";
    folders = {
      "Music" = {
        id = "ybqqh-as53c";
        path = "/home/nico/Music";
        devices = config.dr460nixed.syncthing.devicesNames;
      };
      "Pictures" = {
        id = "9gj2u-j3m9s";
        path = "/home/nico/Pictures";
        devices = config.dr460nixed.syncthing.devicesNames;
      };
      "School" = {
        id = "g5jha-cnrr4";
        path = "/home/nico/School";
        devices = config.dr460nixed.syncthing.devicesNames;
      };
      "Sync" = {
        id = "u62ge-wzsau";
        path = "/home/nico/Sync";
        devices = config.dr460nixed.syncthing.devicesNames;
      };
      "Videos" = {
        id = "nxhpo-c2j5b";
        path = "/home/nico/Videos";
        devices = config.dr460nixed.syncthing.devicesNames;
      };
    };
  };

  boot = {
    blacklistedKernelModules = [ "elan_i2c" ];
    initrd.kernelModules = [ "amdgpu" ];
    kernelParams = [
      "amd_pstate=active"
      "microcode.amd_sha_check=off"
    ];
    supportedFilesystems = [ "btrfs" ];
  };

  networking.hostName = "dragons-ryzen";

  nix.settings.system-features = [
    "big-parallel"
    "kvm"
  ];

  services.ucodenix = {
    enable = true;
    cpuModelId = "00860F01";
  };

  services = {
    hardware.bolt.enable = false;
    pipewire.lowLatency = {
      enable = true;
      quantum = 64;
      rate = 48000;
    };
  };

  dr460nixed = {
    chromium.enable = true;
    desktops.enable = true;
    development.enable = true;
    gaming.enable = true;
    impermanence.enable = true;
    lanzaboote.enable = true;
    performance.enable = true;
    tailscale.enable = true;
    yubikey.enable = true;
  };

  services.tailscale.extraUpFlags = [
    "--accept-dns"
    "--accept-risk=lose-ssh"
    "--accept-routes"
    "--ssh"
  ];

  garuda = {
    btrfs-maintenance = {
      deduplication = true;
      enable = true;
      uuid = "7f894697-a4e9-43a7-bdd8-00c0376ce1f9";
    };
  };

  services.displayManager.autoLogin = {
    enable = true;
    user = "nico";
  };

  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
    RADV_VIDEO_DECODE = "1";
  };

  environment.systemPackages = with pkgs; [
    libinput
    radeontop
  ];

  services.openssh.ports = [ 666 ];

  systemd.services.setmacaddr = {
    script = ''
      /run/current-system/sw/bin/ip link set dev wlan0 address 86:83:A9:94:5A:D6
    '';
    wantedBy = [ "basic.target" ];
  };

  systemd.services.fix-bluetooth = {
    wantedBy = [ "multi-user.target" ];
    description = "Fix bluetooth connection";
    path = with pkgs; [ kmod ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = pkgs.writeShellScript "execstart" ''
        modprobe -r btusb
        sleep 1
        modprobe btusb
      '';
    };
  };

  system.stateVersion = "23.11";
}
