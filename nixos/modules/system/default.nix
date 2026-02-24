{ ... }:
{
  imports = [
    ./auto-upgrade.nix
    ./live-cd.nix
    ./performance.nix
    ./remote-build.nix
    ./zfs.nix
  ];
}
