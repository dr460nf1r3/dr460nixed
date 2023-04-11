{ ... }: {
  # We want to use NetworkManager
  networking = {
    # Point to our Adguard instance
    nameservers = [ "100.100.100.100" ];
    networkmanager = {
      dns = "none";
      enable = true;
      wifi.backend = "iwd";
    };
    # Disable non-NetworkManager
    useDHCP = false;
  };
}
