{
  inputs,
  lib,
  ...
}: {
  imports = ["${toString inputs.nixpkgs}/nixos/modules/virtualisation/google-compute-image.nix"];

  dr460nixed = {
    grub = {
      device = "/dev/sda";
      enable = true;
    };
    servers = {
      enable = true;
      monitoring = true;
    };
    smtp.enable = true;
    tailscale.enable = true;
    tailscale-tls.enable = true;
  };

  # Hostname of this machine
  networking.hostName = "google-dragon";

  # Clashing gcp.nix / GNS
  boot.loader.timeout = lib.mkForce 0;

  # NixOS stuff
  system.stateVersion = "23.11";
}
