{...}: {
  # We want to use NetworkManager
  networking = {
    # Point to our Adguard instance
    nameservers = ["10.241.1.3"];
    networkmanager = {
      dns = "none";
      enable = true;
      wifi.backend = "iwd";
    };
    # Disable non-NetworkManager
    useDHCP = false;
  };
}
