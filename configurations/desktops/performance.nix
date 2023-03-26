{pkgs, ...}: {
  # Use bleeding edge mesa - to do
  # imports = ../../pkgs/mesa/mesa.nix;

  # Automatically tune nice levels
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
  };

  # 90% ZRAM as swap
  zramSwap = {
    enable = true;
    memoryPercent = 90;
  };

  # Tune the Zen kernel
  programs.cfs-zen-tweaks.enable = true;
}
