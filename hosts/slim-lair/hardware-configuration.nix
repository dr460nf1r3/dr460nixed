{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  # Boot konfiguration
  boot.initrd.availableKernelModules = ["nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod"];
  boot.initrd.kernelModules = [];
  boot.kernelModules = ["kvm-amd"];
  boot.extraModulePackages = [];

  # Our ZFS pools
  fileSystems."/" = {
    device = "zroot/ROOT/empty";
    fsType = "zfs";
    neededForBoot = true;
  };
  fileSystems."/nix" = {
    device = "zroot/ROOT/nix";
    fsType = "zfs";
  };
  fileSystems."/home/nico/Games" = {
    device = "zroot/games/home";
    fsType = "zfs";
  };
  fileSystems."/var/persistent" = {
    device = "zroot/data/persistent";
    fsType = "zfs";
    neededForBoot = true;
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/0012-B6FF";
    fsType = "vfat";
  };

  # ZFS doesn't support SWAP
  swapDevices = [];

  # Generic stuff
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode =
    lib.mkDefault config.hardware.enableRedistributableFirmware;
}
