{
  pkgs,
  config,
  ...
}: {
  # Enable the sound in general
  sound.enable = true;

  # Enable sound with Pipewire
  environment.variables = {
    SDL_AUDIODRIVER = "pipewire";
    ALSOFT_DRIVERS = "pipewire";
  };

  # Disable PulseAudio
  hardware.pulseaudio.enable = false;

  # Enable the realtime kit
  security.rtkit.enable = true;

  # Pipewire & wireplumber configuration
  services.pipewire = {
    alsa.enable = true;
    alsa.support32Bit = true;
    enable = true;
    media-session.enable = false;
    pulse.enable = true;
    systemWide = false;
    wireplumber.enable = true;
  };
}
