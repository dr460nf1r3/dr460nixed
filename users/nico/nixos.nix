{
  keys,
  ...
}:
let
  hetznerStorageBox = "your-storagebox.de";
in
{
  dr460nixed.users.nico = {
    uid = 1000;
    gid = 1000;
    authorizedKeyFiles = [ keys.nico ];
    shellGroups = [
      "adbusers"
      "disk"
      "docker"
      "flatpak"
      "git"
      "kvm"
      "libvirtd"
      "minecraft"
      "network"
      "networkmanager"
      "systemd-journal"
      "vboxusers"
      "wireshark"
    ];
    homeManager = {
      enable = true;
      git = {
        userName = "Nico Jensch";
        userEmail = "root@dr460nf1r3.org";
        signingKey = "D245D484F3578CB17FD6DA6B67DB29BFF3C96757";
      };
      shellAliases = {
        "b1" = "ssh -p23 u342919@u342919.${hetznerStorageBox}";
        "b2" = "ssh -p23 u358867@u358867.${hetznerStorageBox}";
        "c" = "ssh -p666 nico@cup-dragon";
        "g1" = "ssh -p666 nico@aerialis.garudalinux.org";
        "g2" = "ssh -p666 nico@stormwing.garudalinux.org";
      };
      fishAbbreviations = {
        "b1" = "ssh -p23 u342919@u342919.${hetznerStorageBox}";
        "b2" = "ssh -p23 u358867@u358867.${hetznerStorageBox}";
        "c" = "ssh -p666 nico@cup-dragon";
        "g1" = "ssh -p666 nico@aerialis.garudalinux.org";
        "g2" = "ssh -p666 nico@stormwing.garudalinux.org";
      };
      stateVersion = "26.05";
    };
  };

  sops.secrets."passwords/nico".neededForUsers = true;
}
