{ modulesPath, ... }: {
  # This is a QEMU machine
  imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

  # Bootloader
  boot.loader.grub = {
    device = "nodev";
    efiInstallAsRemovable = true;
    efiSupport = true;
  };

  # Our filesystems
  fileSystems."/" = {
    device = "/dev/sda1";
    fsType = "ext4";
  };
  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/200C-2E9B";
    fsType = "vfat";
  };

  # Early needed kernel modules
  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" ];
  boot.initrd.kernelModules = [ "nvme" ];
}
