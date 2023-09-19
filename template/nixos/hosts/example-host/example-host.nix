{...}: {
  # Individual configuration snippets
  imports = [./hardware-configuration.nix];

  # Hostname & hostId for ZFS
  networking.hostName = "example-hostname";

  # Enable a few selected custom settings
  dr460nixed = {
    desktops.enable = true;
    performance = true;
  };

  # NixOS stuff
  system.stateVersion = "23.11";
}
