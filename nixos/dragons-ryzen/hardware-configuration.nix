{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot = {
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "usbhid" "usb_storage" "sd_mod"];
      kernelModules = [];
      luks.devices."crypted".device = "/dev/disk/by-uuid/482c62f6-be95-419d-afb0-77f5940a4583";
    };
    kernelModules = ["kvm-amd"];
    extraModulePackages = [];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/7f894697-a4e9-43a7-bdd8-00c0376ce1f9";
      fsType = "btrfs";
      options = ["subvol=root" "compress=zstd" "noatime"];
    };
    "/home" = {
      device = "/dev/disk/by-uuid/7f894697-a4e9-43a7-bdd8-00c0376ce1f9";
      fsType = "btrfs";
      options = ["subvol=home" "compress=zstd" "noatime"];
      neededForBoot = true;
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/7f894697-a4e9-43a7-bdd8-00c0376ce1f9";
      fsType = "btrfs";
      options = ["subvol=nix" "compress=zstd" "noatime"];
    };
    "/persist" = {
      device = "/dev/disk/by-uuid/7f894697-a4e9-43a7-bdd8-00c0376ce1f9";
      fsType = "btrfs";
      options = ["subvol=persist" "compress=zstd" "noatime"];
      neededForBoot = true;
    };
    "/var/log" = {
      device = "/dev/disk/by-uuid/7f894697-a4e9-43a7-bdd8-00c0376ce1f9";
      fsType = "btrfs";
      options = ["subvol=log" "compress=zstd" "noatime"];
      neededForBoot = true;
    };
    "/boot" = {
      device = "/dev/disk/by-uuid/1E05-4C2D";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
  };

  swapDevices = [{device = "/persist/.swapfile";}];

  networking.useDHCP = lib.mkDefault true;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
