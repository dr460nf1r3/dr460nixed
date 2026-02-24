{
  inputs,
  pkgs,
  ...
}:
{
  # Individual settings + low-latency Pipewire
  imports = [
    ./hardware-configuration.nix
    ../../nixos/modules/impermanence
    ../../users/nico/nixos.nix
    inputs.nix-gaming.nixosModules.pipewireLowLatency
  ];

  # Boot options
  boot = {
    # Needed to get the touchpad working
    blacklistedKernelModules = [ "elan_i2c" ];
    initrd.kernelModules = [ "amdgpu" ];
    kernelParams = [
      "amd_pstate=active"
      "microcode.amd_sha_check=off"
    ];
    supportedFilesystems = [ "btrfs" ];
  };

  # Hostname of this machine
  networking.hostName = "dragons-ryzen";

  # Ucode updates for the CPU
  services.ucodenix = {
    enable = true;
    cpuModelId = "00860F01";
  };

  # The services to use on this machine
  services = {
    hardware.bolt.enable = false;
    pipewire.lowLatency = {
      enable = true;
      quantum = 64;
      rate = 48000;
    };
  };

  # Enable a few selected custom settings
  dr460nixed = {
    chromium = true;
    desktops.enable = true;
    development.enable = true;
    gaming.enable = true;
    impermanence.enable = true;
    lanzaboote.enable = true;
    performance = true;
    remote-build = {
      enable = true;
      host = "remote-build";
      port = 666;
      trustedPublicKey = "immortalis:8vrLBvFoMiKVKRYD//30bhUBTEEiuupfdQzl2UoMms4=";
      user = "nico";
    };
    tailscale.enable = true;
    yubikey = true;
  };

  # Tailscale auto-connect
  services.tailscale.extraUpFlags = [
    "--accept-dns"
    "--accept-risk=lose-ssh"
    "--accept-routes"
    "--ssh"
  ];

  # Garuda Nix subsystem modules
  dr460nixed.garuda = {
    btrfs-maintenance = {
      deduplication = true;
      enable = true;
      uuid = "7f894697-a4e9-43a7-bdd8-00c0376ce1f9";
    };
  };

  # Autologin due to FDE
  services.displayManager.autoLogin = {
    enable = true;
    user = "nico";
  };

  # RADV video decode & general usage
  environment.variables = {
    AMD_VULKAN_ICD = "RADV";
    RADV_VIDEO_DECODE = "1";
  };

  # Enable the touchpad & secure boot, as well as add the ipman script
  environment.systemPackages = with pkgs; [
    libinput
    radeontop
  ];

  # Allow SSH via ServerBox
  services.openssh.ports = [ 666 ];

  # Change the default MAC address, which seems to get shuffled every reboot for no reason
  systemd.services.setmacaddr = {
    script = ''
      /run/current-system/sw/bin/ip link set dev wlan0 address 86:83:A9:94:5A:D6
    '';
    wantedBy = [ "basic.target" ];
  };

  # For some reason Bluetooth only works after un-/reloading
  # the btusb kernel module
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

  # NixOS stuff
  system.stateVersion = "23.11";
}
