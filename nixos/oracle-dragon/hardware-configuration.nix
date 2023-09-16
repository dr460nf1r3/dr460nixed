{modulesPath, ...}: {
  # This is a QEMU machine
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  # Our filesystems
  fileSystems = {
    "/" = {
      device = "/dev/sda1";
      fsType = "ext4";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/200C-2E9B";
      fsType = "vfat";
    };
  };

  # Early needed kernel modules
  boot.initrd.availableKernelModules = ["ata_piix" "uhci_hcd" "xen_blkfront"];
  boot.initrd.kernelModules = ["nvme"];
}
