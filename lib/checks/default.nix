{ pkgs, ... }: {
  nixpkgs-fmt = pkgs.callPackage ./nixpkgs-fmt.nix { };
  statix = pkgs.callPackage ./statix.nix { };
}
