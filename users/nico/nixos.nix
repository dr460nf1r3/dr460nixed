{ keys, ... }:
{
  dr460nixed.users.nico = {
    authorizedKeyFiles = [ keys.nico ];
    shellGroups = [
      "adbusers"
      "chaotic_op"
      "deluge"
      "disk"
      "docker"
      "flatpak"
      "git"
      "kvm"
      "libvirtd"
      "minecraft"
      "mysql"
      "network"
      "networkmanager"
      "podman"
      "systemd-journal"
      "wireshark"
    ];
  };

  # Home-manager configuration for nico
  home-manager.users.nico = import ./nico.nix;

  # Ensure the user gets the right home-manager modules
  # (This can be further automated if needed)
}
