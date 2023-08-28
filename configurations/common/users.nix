{ keys
, config
, ...
}:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  # All users are immuntable; if a password is required it needs to be set via passwordFile
  users.mutableUsers = false;

  # This is needed for early set up of user accounts
  sops.secrets."passwords/nico" = {
    neededForUsers = true;
  };
  sops.secrets."passwords/root" = {
    neededForUsers = true;
  };

  # Lock root password
  users.users.root.passwordFile = config.sops.secrets."passwords/root".path;
  # My user
  users.users.nico = {
    extraGroups =
      [
        "audio"
        "video"
        "wheel"
      ]
      ++ ifTheyExist [
        "adbusers"
        "chaotic_op"
        "deluge"
        "disk"
        "docker"
        "flatpak"
        "git"
        "kvm"
        "libvirtd"
        "mysql"
        "network"
        "networkmanager"
        "podman"
        "systemd-journal"
        "wireshark"
      ];
    home = "/home/nico";
    isNormalUser = true;
    openssh.authorizedKeys.keyFiles = [ keys.nico ];
    passwordFile = config.sops.secrets."passwords/nico".path;
    uid = 1000;
  };

  # Load my home-manager configurations
  home-manager.users."nico" = import ../../home-manager/common.nix;

  # Allow pushing to Cachix
  sops.secrets."api_keys/cachix" = {
    mode = "0600";
    owner = config.users.users.nico.name;
    path = "/home/nico/.config/cachix/cachix.dhall";
  };
}
