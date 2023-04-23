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

  # To make chaotic-nyx happy
  home.file.".local/share/nix/trusted-settings.json".text = ''
    {"extra-substituters":{"https://nyx.chaotic.cx":true},"extra-trusted-public-keys":{"nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8= chaotic-nyx.cachix.org-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8=":true}}
  '';

  # Needed to allow VSCode storing secrets in Kwallet apparently
  home.file.".local/share/dbus-1/services/org.freedesktop.secrets".text = ''
    [D-BUS Service]
    Name=org.freedesktop.secrets
    Exec=/usr/bin/kwalletd5
  '';
}
