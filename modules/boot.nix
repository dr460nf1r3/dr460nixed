{ config
, lib
, ...
}:
with lib;
let
  cfg = config.dr460nixed.boot;
in
{
  options.dr460nixed.boot = {
    enable = mkOption
      {
        default = true;
        type = types.bool;
        description = mdDoc ''
          Configures common options for a quiet systemd-boot.
        '';
      };
  };

  config = mkIf cfg.enable {
    boot = {
      kernelParams = [
        # https://en.wikipedia.org/wiki/Kernel_page-table_isolation
        "pti=on"

        # make stack-based attacks on the kernel harder
        "randomize_kstack_offset=on"

        # this has been defaulted to none back in 2016 - break really old binaries for security
        "vsyscall=none"

        # https://tails.boum.org/contribute/design/kernel_hardening/
        "slab_nomerge"

        # enable buddy allocator free poisoning
        "page_poison=1"

        # performance improvement for direct-mapped memory-side-cache utilization, reduces the predictability of page allocations
        "page_alloc.shuffle=1"

        # save power on idle by limiting c-states
        # https://gist.github.com/wmealing/2dd2b543c4d3cff6cab7
        "processor.max_cstate=5"

        # disable the intel_idle driver and use acpi_idle instead
        "idle=nomwait"

        # ignore access time (atime) updates on files, except when they coincide with updates to the ctime or mtime
        "rootflags=noatime"

        # enable IOMMU for devices used in passthrough and provide better host performance
        "iommu=pt"

        # disable usb autosuspend
        "usbcore.autosuspend=-1"

        # allows systemd to set and save the backlight state
        "acpi_backlight=native"

        # disable systemd status messages
        # rd prefix means systemd-udev will be used instead of initrd
        "rd.systemd.show_status=auto"

        # lower the udev log level to show only errors or worse
        "rd.udev.log_level=3"

        # disable the cursor in vt to get a black screen during intermissions
        "vt.global_cursor_default=0"
      ];
      loader = {
        # Fix a security hole in place for backwards compatibility. See desc in
        # nixpkgs/nixos/modules/system/boot/loader/systemd-boot/systemd-boot.nix
        systemd-boot.editor = false;

        generationsDir.copyKernels = true;
        timeout = 1;
      };
    };
  };
}
