{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd = {
      availableKernelModules = ["nvme" "xhci_pci" "usb_storage" "usbhid"];
      kernelModules = [];
    };
    kernelModules = ["kvm-amd"];
    extraModulePackages = [];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/9afd48aa-4ce2-4e68-b609-82bd80b812af";
    fsType = "btrfs";
    options = ["subvol=@nix-subsystem"];
  };

  boot.initrd.luks.devices."luks-c9a7631a-5a1f-4134-aee5-ace5cceec58f".device = "/dev/disk/by-uuid/c9a7631a-5a1f-4134-aee5-ace5cceec58f";

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/9afd48aa-4ce2-4e68-b609-82bd80b812af";
    fsType = "btrfs";
    options = ["subvol=@nix"];
  };

  swapDevices = [
    {device = "/dev/disk/by-uuid/1320865c-b201-415b-9f26-32d853117f65";}
  ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
