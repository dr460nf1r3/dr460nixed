_:
let
  overlay = final: _: {
    chromium-flagged = final.chromium.override {
      commandLineArgs = [
        "--enable-accelerated-2d-canvas"
        "--enable-features=UseOzonePlatform,WebUIDarkMode,VaapiVideoDecoder,WebContentsForceDark:classifier_policy/transparency_and_num_colors"
        "--enable-gpu-rasterization"
        "--enable-smooth-scrolling"
        "--enable-zero-copy"
        "--ignore-gpu-blacklist"
        "--ozone-platform=wayland"
        "--smooth-scrolling"
      ];
      enableWideVine = true;
    };

    obs-studio-wrapped = final.wrapOBS.override { inherit (final) obs-studio; } {
      plugins = with final.obs-studio-plugins; [
        obs-gstreamer
        obs-pipewire-audio-capture
        obs-vaapi
        obs-vkcapture
      ];
    };

    zenpower5 = final.linuxPackages.zenpower;
  };

  linuxPackagesOverlay = _final: prev: {
    linuxPackagesFor =
      kernel:
      (prev.linuxPackagesFor kernel).extend (
        lfinal: _lprev: {
          zenpower = lfinal.callPackage ../packages/zenpower5 { };
        }
      );
  };
in
{
  inherit overlay linuxPackagesOverlay;
}
