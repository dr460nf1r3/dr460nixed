{lib, ...}: {
  imports = [./hardware-configuration.nix];

  # Boot options
  boot = {
    # Required for using app connectors in Tailscale
    kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    };
    loader = {
      grub = {
        device = "nodev";
        efiInstallAsRemovable = true;
        efiSupport = true;
        enable = lib.mkForce true;
      };
      efi.efiSysMountPoint = "/boot";
    };
  };

  dr460nixed = {
    servers = {
      enable = true;
      monitoring = true;
    };
    smtp.enable = true;
    tailscale.enable = true;
    tailscale-tls.enable = true;
  };

  # Hostname of this machine
  networking.hostName = "pve-dragon-1";

  # NixOS stuff
  system.stateVersion = "23.11";
}
