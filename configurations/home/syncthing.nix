{ ... }: {
  # File synchronization between my devices
  services.syncthing = {
    enable = true;
    extraOptions = [ "--no-browser" ];
    tray.enable = true;
  };
}
