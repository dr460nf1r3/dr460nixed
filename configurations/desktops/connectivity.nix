{ ... }: {
  # LAN discovery
  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  # Bluetooth
  hardware.bluetooth.enable = true;

  # In case I need to fix my phone & Waydroid
  programs.adb.enable = true;
}
