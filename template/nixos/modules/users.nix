{ config, ... }:
let
  # Add groups to user only if they exist
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  users.users = {
    example-user = {
      extraGroups = [
        "audio"
        "video"
        "wheel"
      ]
      ++ ifTheyExist [
        "adbusers"
        "disk"
        "docker"
        "flatpak"
        "kvm"
        "libvirtd"
        "network"
        "networkmanager"
        "systemd-journal"
      ];
      home = "/home/example-user";
      initialPassword = "dr460nixed";
      isNormalUser = true;
    };
    # Lock root password
    root.initialPassword = "dr460nixed";
  };
}
