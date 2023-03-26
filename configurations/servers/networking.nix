{...}: {
  # Disable NetworkManager, we assign statically mostly
  networking.networkmanager.enable = false;

  # Use Systemd-resolved
  networking.nameservers = ["10.241.1.3"];
}
