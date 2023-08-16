{ config
, lib
, pkgs
, modulesPath
, ...
}:
{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usb_storage" "usbhid" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "zroot/ROOT/empty";
      fsType = "zfs";
      neededForBoot = true;
    };

  fileSystems."/nix" =
    {
      device = "zroot/ROOT/nix";
      fsType = "zfs";
      neededForBoot = true;
    };

  fileSystems."/home/nico/Games" =
    {
      device = "zroot/games/home";
      fsType = "zfs";
      options = [ "x-gvfs-hide" ];
    };

  fileSystems."/var/persistent" =
    {
      device = "zroot/data/persistent";
      fsType = "zfs";
      neededForBoot = true;
    };

  fileSystems."/var/residues" =
    {
      device = "zroot/ROOT/residues";
      fsType = "zfs";
      neededForBoot = true;
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/BCF1-1863";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/23aa6b8f-3161-410d-869d-0ffa80e07a79"; }];

  networking.useDHCP = lib.mkDefault true;
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
