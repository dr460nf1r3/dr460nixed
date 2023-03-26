{
  inputs,
  pkgs,
  ...
}: {
  # Gaming packages
  environment.systemPackages = with pkgs; [
    bottles
    lutris
    mangohud
    prismlauncher-mod
    (retroarch.override {
      cores = with libretro; [
        citra
        flycast
        ppsspp
      ];
    })
    wine-staging
    winetricks
  ];

  # Enable gamemode
  programs.gamemode.enable = true;

  # Instant replays
  services.replay-sorcery = {
    enable = true;
    autoStart = false;
    settings = {
      videoQuality = "auto";
    };
  };

  # MangoHUD to monitor performance while gaming
  home-manager.users."nico".programs.mangohud = {
    enable = true;
    settings = {
      arch = true;
      background_alpha = "0.05";
      battery = true;
      cpu_temp = true;
      engine_version = true;
      font_size = 17;
      fps_limit = 60;
      gl_vsync = 0;
      gpu_name = true;
      gpu_temp = true;
      io_read = true;
      io_write = true;
      position = "top-right";
      round_corners = 8;
      vram = true;
      vsync = 1;
      vulkan_driver = true;
      width = 260;
      wine = true;
    };
  };

  # Enable Steam
  programs.steam.enable = true;

  # Fix League of Legends
  boot.kernel.sysctl = {
    "abi.vsyscall32" = 0;
  };
}
