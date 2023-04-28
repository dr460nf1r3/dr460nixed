{ config
, lib
, pkgs
, ...
}:
with lib;
let
  cfg = config.dr460nixed.rpi;
in
{
  rpi = mkOption
    {
      default = false;
      type = types.bool;
      description = mdDoc ''
        Whether this is a Raspberry Pi.
      '';
    };
  boot = {
    kernelPackages = pkgs.linuxPackages_rpi4;
    tmp.useTmpfs = true;
    initrd.availableKernelModules = [ "usbhid" "usb_storage" ];
    # Fix https://github.com/NixOS/nixpkgs/pull/207969
    initrd.systemd.enable = lib.mkForce false;
    # ttyAMA0 is the serial console broken out to the GPIO
    kernelParams = [
      "8250.nr_uarts=1"
      "cma=128M"
      "console=tty1"
      "console=ttyAMA0,115200"
    ];
  };

  # Enable hardware acceleration
  # hardware.raspberry-pi."4".fkms-3d.enable = true;

  # This is needed as the packages are marked unsupported
  hardware.cpu = {
    amd.updateMicrocode = lib.mkForce false;
    intel.updateMicrocode = lib.mkForce false;
  };

  # Slows down write operations considerably
  nix.settings.auto-optimise-store = lib.mkForce false;

  # Custom garbage collection defaults
  nix = {
    # Free up to 1GiB whenever there is less than 100MiB left & allow remote-building
    extraOptions = lib.mkForce ''
      min-free = ${toString (100 * 1024 * 1024)}
      max-free = ${toString (1024 * 1024 * 1024)}
      builders-use-substitutes = true
    '';
  };
}
