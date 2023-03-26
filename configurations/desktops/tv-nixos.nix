{...}: {
  # Load host dependant home-manager configuration
  home-manager.users."nico" = import ../home/tv-nixos.nix;
}
