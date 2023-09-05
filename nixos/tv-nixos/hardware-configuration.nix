{ config
, lib
, modulesPath
, ...
}: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.extraModulePackages = [ ];
  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/41d83137-e90c-4eca-9c3a-cf4b814022c1";
      fsType = "ext4";
    };
  fileSystems."/boot/efi" =
    {
      device = "/dev/disk/by-uuid/27D1-94B1";
      fsType = "vfat";
    };
  swapDevices = [ ];

  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
