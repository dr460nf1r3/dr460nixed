{
  # Virt-manager settings
  dconf.settings = {
    "org/virt-manager/virt-manager" = {
      manager-window-height = 550;
      manager-window-width = 550;
    };
    "org/virt-manager/virt-manager/confirm" = {
      unapplied-dev = true;
    };
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = [ "qemu:///system" ];
      uris = [ "qemu:///system" ];
    };
    "org/virt-manager/virt-manager/details" = {
      show-toolbar = true;
    };
    "org/virt-manager/virt-manager/vmlist-fields" = {
      disk-usage = true;
      network-traffic = true;
    };
  };
}
