{
  config,
  lib,
  ...
}:
(
  let
    cfg = config.dr460nixed.wireguard;
    inherit (lib)
      mkOption
      mkEnableOption
      mkIf
      types
      mapAttrs'
      nameValuePair
      ;
  in
  {
    options.dr460nixed.wireguard = {
      enable = mkEnableOption "WireGuard connections via systemd-networkd";

      interfaces = mkOption {
        default = { };
        type = types.attrsOf (
          types.submodule {
            options = {
              address = mkOption {
                type = types.listOf types.str;
                description = "List of addresses to assign to the interface.";
              };
              listenPort = mkOption {
                type = types.int;
                default = 51820;
                description = "Port to listen on for incoming connections.";
              };
              privateKeySecretName = mkOption {
                type = types.str;
                description = "The name of the sops secret containing the private key.";
              };
              firewallMark = mkOption {
                type = types.nullOr types.int;
                default = null;
                description = "Firewall mark to set on packets.";
              };
              routeTable = mkOption {
                type = types.nullOr types.str;
                default = "main";
                description = "Routing table for the WireGuard interface.";
              };
              peers = mkOption {
                type = types.listOf (
                  types.submodule {
                    options = {
                      publicKey = mkOption {
                        type = types.str;
                        description = "Public key of the peer.";
                      };
                      allowedIPs = mkOption {
                        type = types.listOf types.str;
                        description = "List of IP ranges allowed from this peer.";
                      };
                      endpoint = mkOption {
                        type = types.nullOr types.str;
                        default = null;
                        description = "Endpoint address and port of the peer.";
                      };
                      persistentKeepalive = mkOption {
                        type = types.nullOr types.int;
                        default = null;
                        description = "Persistent keepalive interval in seconds.";
                      };
                    };
                  }
                );
                default = [ ];
                description = "List of WireGuard peers.";
              };
            };
          }
        );
        description = "WireGuard interface configurations.";
      };
    };

    config = mkIf cfg.enable {
      # Ensure systemd-networkd is used
      networking.useNetworkd = true;
      systemd.network.enable = true;

      # Open firewall ports
      networking.firewall.allowedUDPPorts = lib.mapAttrsToList (
        _name: value: value.listenPort
      ) cfg.interfaces;

      # systemd-networkd configuration
      systemd.network = {
        networks = mapAttrs' (
          name: value:
          (nameValuePair "50-${name}" {
            matchConfig.Name = name;
            inherit (value) address;
            networkConfig.IPv6PrivacyExtensions = "no";
          })
        ) cfg.interfaces;

        netdevs = mapAttrs' (
          name: value:
          (nameValuePair "50-${name}" {
            netdevConfig = {
              Kind = "wireguard";
              Name = name;
            };
            wireguardConfig = lib.filterAttrs (_n: v: v != null) {
              ListenPort = value.listenPort;
              PrivateKeyFile = config.sops.secrets."${value.privateKeySecretName}".path;
              RouteTable = value.routeTable;
              FirewallMark = value.firewallMark;
            };
            wireguardPeers = map (
              peer:
              lib.filterAttrs (_n: v: v != null) {
                PublicKey = peer.publicKey;
                AllowedIPs = peer.allowedIPs;
                Endpoint = peer.endpoint;
                PersistentKeepalive = peer.persistentKeepalive;
              }
            ) value.peers;
          })
        ) cfg.interfaces;
      };
    };
  }
)
