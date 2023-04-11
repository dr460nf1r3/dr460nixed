{ ... }: {
  # We want to use NetworkManager
  networking = {
    # Pointing to our Adguard instance via Tailscale
    nameservers = [ "1.1.1.1" ];
    networkmanager = {
      dns = "none";
      enable = true;
      wifi.backend = "iwd";
    };
    # Disable non-NetworkManager
    useDHCP = false;
  };
}
