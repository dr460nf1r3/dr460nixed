{
  lib,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/profiles/qemu-guest.nix")];

  boot = {
    extraModulePackages = [];
    initrd = {
      availableKernelModules = [
        "ata_piix"
        "sd_mod"
        "sr_mod"
        "uhci_hcd"
        "virtio_pci"
        "virtio_scsi"
      ];
      kernelModules = [];
    };
    kernelModules = [];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/2684489d-5e17-455d-8da4-011b80e77624";
      fsType = "btrfs";
      options = ["compress=zstd"];
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/F128-4571";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
  };

  swapDevices = [];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
