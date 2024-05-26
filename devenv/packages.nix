{pkgs, ...}: {
  packages = with pkgs; [
    age
    commitizen
    gnupg
    manix
    mdbook
    nix-melt
    nixos-anywhere
    nixos-install-tools
    rsync
    sops
  ];
}
