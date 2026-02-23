{
  config,
  lib,
  ...
}:
let
  inherit (lib) mkOption types mdDoc;
  cfg = config.dr460nixed.users;

  # Add groups to user only if they exist
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  options.dr460nixed.users = mkOption {
    description = mdDoc "User accounts to configure.";
    default = { };
    type = types.attrsOf (
      types.submodule (_: {
        options = {
          isNormalUser = mkOption {
            type = types.bool;
            default = true;
            description = mdDoc "Whether the user is a normal user.";
          };
          extraGroups = mkOption {
            type = types.listOf types.str;
            default = [
              "audio"
              "video"
              "wheel"
            ];
            description = mdDoc "Extra groups for the user.";
          };
          shellGroups = mkOption {
            type = types.listOf types.str;
            default = [ ];
            description = mdDoc "Groups to add only if they exist on the system.";
          };
          authorizedKeyFiles = mkOption {
            type = types.listOf types.path;
            default = [ ]; # No keys by default
            description = mdDoc "SSH authorized key files.";
          };
        };
      })
    );
  };

  config = {
    # Use fixed UIDs/GIDs
    users.deterministicIds = {
      acme.uid = 999;
      acme.gid = 999;
      adbusers.uid = 998;
      adbusers.gid = 998;
      adguard.uid = 977;
      adguard.gid = 977;
      anubis.uid = 961;
      anubis.gid = 961;
      avahi.uid = 997;
      avahi.gid = 997;
      chaotic_op.uid = 996;
      chaotic_op.gid = 996;
      cloudflared.uid = 972;
      cloudflared.gid = 972;
      code-server.uid = 967;
      code-server.gid = 967;
      dhcpcd.uid = 976;
      dhcpcd.gid = 976;
      fwupd-refresh.uid = 975;
      fwupd-refresh.gid = 975;
      flatpak.uid = 974;
      flatpak.gid = 974;
      forgejo.uid = 963;
      forgejo.gid = 963;
      gamemode.uid = 969;
      gamemode.gid = 969;
      geoclue.uid = 959;
      geoclue.gid = 959;
      git.uid = 960;
      git.gid = 960;
      grafana.uid = 995;
      grafana.gid = 995;
      incus-admin.uid = 665;
      incus-admin.gid = 665;
      influxdb2.uid = 994;
      influxdb2.gid = 994;
      jellyfin.uid = 970;
      jellyfin.gid = 970;
      loki.uid = 993;
      loki.gid = 993;
      minecraft.uid = 973;
      minecraft.gid = 973;
      netdata.uid = 979;
      netdata.gid = 979;
      nico.uid = 1000;
      nico.gid = 1000;
      nixos.uid = 1001;
      nixos.gid = 1001;
      nm-iodine.uid = 992;
      nm-iodine.gid = 992;
      node-exporter.uid = 991;
      node-exporter.gid = 991;
      nscd.uid = 990;
      nscd.gid = 990;
      plocate.uid = 989;
      plocate.gid = 989;
      polkituser.uid = 988;
      polkituser.gid = 988;
      paperless.uid = 966;
      paperless.gid = 966;
      plasmalogin.uid = 958;
      plasmalogin.gid = 958;
      podman.uid = 968;
      podman.gid = 968;
      proc.uid = 971;
      proc.gid = 971;
      promtail.uid = 987;
      promtail.gid = 987;
      redis-paperless.uid = 965;
      redis-paperless.gid = 965;
      resolvconf.uid = 964;
      resolvconf.gid = 964;
      rtkit.uid = 986;
      rtkit.gid = 986;
      sshd.uid = 985;
      sshd.gid = 985;
      systemd-coredump.uid = 984;
      systemd-coredump.gid = 984;
      systemd-oom.uid = 983;
      systemd-oom.gid = 983;
      tailscale-tls.uid = 978;
      tailscale-tls.gid = 978;
      telegraf.uid = 982;
      telegraf.gid = 982;
      vnstatd.uid = 981;
      vnstatd.gid = 981;
      wakapi.uid = 962;
      wakapi.gid = 962;
      wireshark.uid = 957;
      wireshark.gid = 957;
      wpa_supplicant.uid = 956;
      wpa_supplicant.gid = 956;
      msr.gid = 955;
    };

    # This is needed for early set up of user accounts
    sops.secrets =
      (lib.mapAttrs' (
        name: _:
        lib.nameValuePair "passwords/${name}" {
          neededForUsers = true;
        }
      ) cfg)
      // {
        "passwords/root".neededForUsers = true;
      };

    users = {
      # All users are immuntable; if a password is required it needs to be set via passwordFile
      mutableUsers = false;
      users =
        (lib.mapAttrs (name: u: {
          inherit (u) isNormalUser;
          extraGroups = u.extraGroups ++ ifTheyExist u.shellGroups;
          hashedPasswordFile = config.sops.secrets."passwords/${name}".path;
          home = "/home/${name}";
          openssh.authorizedKeys.keyFiles = u.authorizedKeyFiles;
          autoSubUidGidRange = false;
          subGidRanges = lib.mkIf config.virtualisation.podman.enable [
            {
              count = 65536;
              startGid = if name == "nico" then 615536 else 715536; # Rough estimation for others
            }
          ];
          subUidRanges = [
            {
              count = 65536;
              startUid = if name == "nico" then 615536 else 715536;
            }
          ];
        }) cfg)
        // {
          # Lock root password
          root = {
            hashedPassword = null;
            hashedPasswordFile = lib.mkForce config.sops.secrets."passwords/root".path;
          };
        };
    };

    security.sudo.extraRules = [
      {
        # allow wheel group to run nixos-rebuild without password
        groups = [ "wheel" ];
        commands =
          let
            currentSystem = "/run/current-system/";
            storePath = "/nix/store/";
          in
          [
            {
              command = "${storePath}/*/bin/switch-to-configuration";
              options = [
                "SETENV"
                "NOPASSWD"
              ];
            }
            {
              command = "${currentSystem}/sw/bin/nix-store";
              options = [
                "SETENV"
                "NOPASSWD"
              ];
            }
            {
              command = "${currentSystem}/sw/bin/nixos-rebuild";
              options = [ "NOPASSWD" ];
            }
            {
              # let wheel group collect garbage without password
              command = "${currentSystem}/sw/bin/nix-collect-garbage";
              options = [
                "SETENV"
                "NOPASSWD"
              ];
            }
            {
              # let wheel group interact with systemd without password
              command = "${currentSystem}/sw/bin/systemctl";
              options = [ "NOPASSWD" ];
            }
          ];
      }
    ];
  };
}
