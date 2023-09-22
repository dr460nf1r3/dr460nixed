{...}: {
  # Individual configuration snippets
  imports = [./hardware-configuration.nix];

  # Hostname
  networking.hostName = "example-hostname";

  # Enable a few selected custom settings
  dr460nixed = {
    chromium = true;
    desktops.enable = true;
    example-boot.enable = true;
    performance = true;
    systemd-boot.enable = true;
  };

  # NixOS stuff
  system.stateVersion = "23.11";
}
