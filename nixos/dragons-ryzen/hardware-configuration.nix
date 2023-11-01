{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot = {
    extraModulePackages = [];
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = [];
    };
    kernelModules = ["kvm-amd"];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/f5a3d78a-2f7f-4d17-919a-76aad9399bc9";
      fsType = "btrfs";
      options = ["subvol=root"];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/f5a3d78a-2f7f-4d17-919a-76aad9399bc9";
      fsType = "btrfs";
      options = ["subvol=nix"];
    };
    "/persist" = {
      device = "/dev/disk/by-uuid/f5a3d78a-2f7f-4d17-919a-76aad9399bc9";
      fsType = "btrfs";
      options = ["subvol=persist"];
    };
    "/swap" = {
      device = "/dev/disk/by-uuid/f5a3d78a-2f7f-4d17-919a-76aad9399bc9";
      fsType = "btrfs";
      options = ["subvol=swap"];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/08A6-A477";
      fsType = "vfat";
    };
  };

  swapDevices = [];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
