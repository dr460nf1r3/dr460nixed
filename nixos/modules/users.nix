{
  keys,
  config,
  ...
}: let
  # Use fixed UIDs/GIDs
  deterministicIds = let
    uidGid = id: {
      gid = id;
      uid = id;
    };
  in {
    acme = uidGid 999;
    adbusers = uidGid 998;
    adguard = uidGid 977;
    avahi = uidGid 997;
    chaotic_op = uidGid 996;
    cloudflared = uidGid 972;
    dhcpcd = uidGid 976;
    fwupd-refresh = uidGid 975;
    flatpak = uidGid 974;
    grafana = uidGid 995;
    influxdb2 = uidGid 994;
    loki = uidGid 993;
    minecraft = uidGid 973;
    netdata = uidGid 979;
    nico = uidGid 1000;
    nm-iodine = uidGid 992;
    node-exporter = uidGid 991;
    nscd = uidGid 990;
    plocate = uidGid 989;
    polkituser = uidGid 988;
    promtail = uidGid 987;
    rtkit = uidGid 986;
    sshd = uidGid 985;
    systemd-coredump = uidGid 984;
    systemd-oom = uidGid 983;
    tailscale-tls = uidGid 978;
    telegraf = uidGid 982;
    vnstatd = uidGid 981;
    wireshark = uidGid 980;
  };

  # Add groups to user only if they exist
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in {
  # This is needed for early set up of user accounts
  sops.secrets = {
    "passwords/nico".neededForUsers = true;
    "passwords/root".neededForUsers = true;
  };

  users = {
    inherit deterministicIds;
    # All users are immuntable; if a password is required it needs to be set via passwordFile
    mutableUsers = false;
    users = {
      nico = {
        autoSubUidGidRange = false; # Use fixed UIDs/GIDs
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
        hashedPasswordFile = config.sops.secrets."passwords/nico".path;
        home = "/home/nico";
        isNormalUser = true;
        openssh.authorizedKeys.keyFiles = [keys.nico];
      };
      # Lock root password
      root.hashedPasswordFile = config.sops.secrets."passwords/root".path;
    };
  };

  # Allow pushing to Cachix
  # sops.secrets."api_keys/cachix" = {
  #   mode = "0600";
  #   owner = config.users.users.nico.name;
  #   path = "/home/nico/.config/cachix/cachix.dhall";
  # };
}
