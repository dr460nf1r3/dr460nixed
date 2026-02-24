{ ... }:
{
  imports = [
    ./compose-runner.nix
    ./monitoring.nix
    ./msmtp.nix
    ./oci.nix
    ./syncthing.nix
  ];
}
