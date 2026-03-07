{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dr460nixed.development;
in
{
  options.virtualisation.quadlet.networks = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule (
        { name, ... }:
        {
          config.networkConfig.driver = lib.mkDefault "bridge";
          config.networkConfig.interfaceName = lib.mkDefault "br-${name}";
        }
      )
    );
  };

  config = lib.mkIf cfg.podman {
    environment.systemPackages = with pkgs; [
      conmon
      docker-compose
      fuse-overlayfs
      podman
      runc
      skopeo
      slirp4netns
    ];

    virtualisation = {
      containers.registries.search = [
        "docker.io"
        "ghcr.io"
        "quay.io"
      ];

      podman = {
        enable = true;
        dockerCompat = true;
        defaultNetwork.settings.dns_enabled = true;
      };
    };

    networking.firewall.interfaces = lib.mapAttrs' (name: _: {
      name = "br-${name}";
      value.allowedUDPPorts = [ 53 ];
    }) config.virtualisation.quadlet.networks;

    users.users = lib.mkIf (cfg.user != null) {
      "${cfg.user}" = {
        extraGroups = [ "podman" ];
      };
    };

    boot.binfmt = {
      emulatedSystems = [ "aarch64-linux" ];
      preferStaticEmulators = true;
    };

    boot.kernel.sysctl."net.ipv4.ip_unprivileged_port_start" = 80;
  };
}
