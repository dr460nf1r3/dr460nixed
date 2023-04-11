{ ... }: {
  # Use Systemd-resolved
  networking.nameservers = [ "100.100.100.100" ];
}
