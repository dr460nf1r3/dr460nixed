{...}: {
  # Individual configuration snippets
  imports = [./hardware-configuration.nix];

  # Hostname & hostId for ZFS
  networking.hostName = "example-hostname";

  # Enable a few selected custom settings
  dr460nixed = {
    chromium = true;
    desktops.enable = true;
    nix-super.enable = true;
    performance = true;
    systemd-boot.enable = true;
  };

  # NixOS stuff
  system.stateVersion = "23.11";
}
