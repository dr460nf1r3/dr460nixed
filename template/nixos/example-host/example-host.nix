{ ... }:
{
  # Individual configuration snippets
  imports = [ ./hardware-configuration.nix ];

  # Hostname
  networking.hostName = "example-hostname";

  # Enable a few selected custom settings
  dr460nixed = {
    chromium = true;
    desktops.enable = true;
    example-boot.enable = true;
    performance = true;
  };

  # NixOS stuff
  system.stateVersion = "24.05";
}
