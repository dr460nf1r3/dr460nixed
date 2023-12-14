{
  lib,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  boot = {
    initrd = {
      availableKernelModules = ["xhci_pci" "virtio_pci" "virtio_scsi" "usbhid"];
      kernelModules = [];
    };
    kernelModules = [];
    extraModulePackages = [];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/84949c77-3d06-4498-959e-74831fcb3e39";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/34F2-E344";
      fsType = "vfat";
    };
  };

  swapDevices = [];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
