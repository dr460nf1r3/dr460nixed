{ ... }:
{
  imports = [
    ./acme.nix
    ./cloudflared.nix
    ./compose-runner.nix
    ./monitoring.nix
    ./msmtp.nix
    ./netdata.nix
    ./nginx
    ./oci.nix
    ./syncthing.nix
    ./tor.nix
  ];
}
