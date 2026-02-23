{
  lib,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = [
    "ata_piix"
    "uhci_hcd"
    "virtio_pci"
    "sr_mod"
    "virtio_blk"
  ];
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/5cd30444-136d-4ae3-a147-1b0fbec1bcb7";
      fsType = "btrfs";
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/9AFB-DF75";
      fsType = "vfat";
      options = [
        "fmask=0022"
        "dmask=0022"
      ];
    };
  };
  swapDevices = [ ];
  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
