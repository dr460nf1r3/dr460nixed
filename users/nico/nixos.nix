{
  config,
  keys,
  lib,
  ...
}:
{
  dr460nixed.users.nico = {
    uid = 1000;
    gid = 1000;
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

  # Import secrets needed for development
  sops.secrets."api_keys/sops" = lib.mkIf config.dr460nixed.development.enable {
    mode = "0600";
    owner = "nico";
    path = "/home/nico/.config/sops/age/keys.txt";
  };
  sops.secrets."api_keys/heroku" = lib.mkIf config.dr460nixed.development.enable {
    mode = "0600";
    owner = "nico";
    path = "/home/nico/.netrc";
  };
  sops.secrets."api_keys/cloudflared" = lib.mkIf config.dr460nixed.development.enable {
    mode = "0600";
    owner = "nico";
    path = "/home/nico/.cloudflared/cert.pem";
  };

  # Impermanence configuration for nico
  dr460nixed.impermanence.persistentUsers = [ "nico" ];

  # SMTP configuration for nico
  dr460nixed.smtp = {
    from = "nico@dr460nf1r3.org";
    passwordeval = "cat /run/secrets/passwords/nico@dr460nf1r3.org";
    user = "nico@dr460nf1r3.org";
  };

  # Syncthing configuration for nico
  dr460nixed.syncthing = {
    user = "nico";
    folders = {
      "Music" = {
        id = "ybqqh-as53c";
        path = "/home/nico/Music";
        devices = config.dr460nixed.syncthing.devicesNames;
      };
      "Pictures" = {
        id = "9gj2u-j3m9s";
        path = "/home/nico/Pictures";
        devices = config.dr460nixed.syncthing.devicesNames;
      };
      "School" = {
        id = "g5jha-cnrr4";
        path = "/home/nico/School";
        devices = config.dr460nixed.syncthing.devicesNames;
      };
      "Sync" = {
        id = "u62ge-wzsau";
        path = "/home/nico/Sync";
        devices = config.dr460nixed.syncthing.devicesNames;
      };
      "Videos" = {
        id = "nxhpo-c2j5b";
        path = "/home/nico/Videos";
        devices = config.dr460nixed.syncthing.devicesNames;
      };
    };
  };

  # Home-manager configuration for nico
  home-manager.users.nico = import ./nico.nix;

  # Ensure the user gets the right home-manager modules
  # (This can be further automated if needed)
}
