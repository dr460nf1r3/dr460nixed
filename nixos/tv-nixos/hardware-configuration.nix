{ lib
, modulesPath
, ...
}: {
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot = {
    extraModulePackages = [ ];
    initrd.availableKernelModules = [ "xhci_pci" "ahci" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [ ];
    kernelModules = [ "kvm-intel" ];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/41d83137-e90c-4eca-9c3a-cf4b814022c1";
      fsType = "ext4";
    };
    "/boot/efi" = {
      device = "/dev/disk/by-uuid/27D1-94B1";
      fsType = "vfat";
    };
  };
  swapDevices = [ ];

  hardware.cpu.intel.updateMicrocode = true;
  nixpkgs.hostPlatform = "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
