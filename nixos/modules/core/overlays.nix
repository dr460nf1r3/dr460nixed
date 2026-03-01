{ inputs, ... }:
let
  localOverlays = import ../../../overlays/overlays.nix { inherit inputs; };
in
{
  nixpkgs.overlays = [
    localOverlays.overlay
    localOverlays.linuxPackagesOverlay
    inputs.nix-cachyos-kernel.overlays.pinned
  ];
}
