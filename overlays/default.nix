_: {
  # Override applications with useful things I want to have
  nixpkgs.overlays =
    let
      thisConfigsOverlay = final: prev: {
        kdePackages = prev.kdePackages // {
          applet-window-buttons6 = prev.kdePackages.applet-window-buttons6.overrideAttrs (old: {
            patches = (old.patches or [ ]) ++ [ ../patches/applet-window-buttons6-pr31.patch ];
          });
        };
        # Enable dark mode, hardware acceleration & add WideVine plugin
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
        # OBS with plugins
        obs-studio-wrapped = final.wrapOBS.override { inherit (final) obs-studio; } {
          plugins = with final.obs-studio-plugins; [
            obs-gstreamer
            obs-pipewire-audio-capture
            obs-vaapi
            obs-vkcapture
          ];
        };
      };
    in
    [
      thisConfigsOverlay
    ];
}
