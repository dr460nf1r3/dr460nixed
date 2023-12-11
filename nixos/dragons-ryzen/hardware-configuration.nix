{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [(modulesPath + "/installer/scan/not-detected.nix")];

  boot = {
    extraModulePackages = [];
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "usbhid" "usb_storage"];
      kernelModules = [];
      luks.devices."luks-3c463eaa-3e83-47c4-acbc-c483f2e63532".device = "/dev/disk/by-uuid/3c463eaa-3e83-47c4-acbc-c483f2e63532";
    };
    kernelModules = ["kvm-amd"];
  };

  fileSystems = {
    "/" = {
      device = "/dev/disk/by-uuid/1776871a-f356-4293-b025-19186473bff1";
      fsType = "btrfs";
      options = ["subvol=@nix-subsystem"];
    };
    "/nix" = {
      device = "/dev/disk/by-uuid/1776871a-f356-4293-b025-19186473bff1";
      fsType = "btrfs";
      options = ["subvol=@nix"];
    };
  };

  swapDevices = [];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
