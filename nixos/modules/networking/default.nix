{ ... }:
{
  imports = [
    ./core.nix
    ./tailscale.nix
    ./tailscale-tls.nix
    ./wireguard.nix
  ];
}
