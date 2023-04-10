{ ... }: {
  # We want to use NetworkManager
  networking = {
    # Point to our Adguard instance
    nameservers = [
      "100.86.102.115"
      "fd7a:115c:a1e0:ab12:4843:cd96:6256:6673"
    ];
    networkmanager = {
      dns = "none";
      enable = true;
      wifi.backend = "iwd";
    };
    # Disable non-NetworkManager
    useDHCP = false;
  };
}
