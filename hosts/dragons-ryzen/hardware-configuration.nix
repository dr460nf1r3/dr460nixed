{ config
, lib
, modulesPath
, ...
}: {
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.extraModulePackages = [ ];
  boot.initrd.availableKernelModules = [ "nvme" "xhci_pci" "usbhid" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/7e2d88b3-7268-4c25-9a7d-af700c07d96d";
      fsType = "btrfs";
      options = [ "subvol=@nixos" "compress=zstd" "noatime" ];
    };
  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/7e2d88b3-7268-4c25-9a7d-af700c07d96d";
      fsType = "btrfs";
      options = [ "subvol=@home" "compress=zstd" "noatime" ];
    };
  fileSystems."/nix" =
    {
      device = "/dev/disk/by-uuid/7e2d88b3-7268-4c25-9a7d-af700c07d96d";
      fsType = "btrfs";
      options = [ "subvol=@nix" "compress=zstd" "noatime" ];
    };
  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/5772-1FF9";
      fsType = "vfat";
    };

  swapDevices = [ ];

  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
