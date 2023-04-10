{ pkgs, ... }: {
  # Automatically tune nice levels
  services.ananicy = {
    enable = true;
    package = pkgs.ananicy-cpp;
  };

  environment.systemPackages = with pkgs; [
    ananicy-cpp-rules
  ];

  # 90% ZRAM as swap
  zramSwap = {
    enable = true;
    memoryPercent = 90;
  };

  # Tune the Zen kernel
  programs.cfs-zen-tweaks.enable = true;
}
