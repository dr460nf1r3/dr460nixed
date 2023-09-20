{config, ...}: {
  config = {
    # Load this home-manager module for all users
    garuda.home-manager.modules = [../../home-manager/kde.nix];
  };
}
