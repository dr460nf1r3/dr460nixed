_: {
  # Override applications with useful things I want to have
  nixpkgs.overlays =
    let
      thisConfigsOverlay = final: _prev: {
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

        # Proton-CachyOS for gaming on Linux
        proton-cachyos = final.callPackage ../packages/proton-bin {
          toolTitle = "Proton-CachyOS";
          tarballPrefix = "proton-";
          tarballSuffix = "-x86_64.tar.xz";
          toolPattern = "proton-cachyos-.*";
          releasePrefix = "cachyos-";
          releaseSuffix = "-slr";
          versionFilename = "cachyos-version.json";
          owner = "CachyOS";
          repo = "proton-cachyos";
        };
        proton-cachyos_x86_64_v3 = final.proton-cachyos.override {
          toolTitle = "Proton-CachyOS x86-64-v3";
          tarballSuffix = "-x86_64_v3.tar.xz";
          versionFilename = "cachyos-v3-version.json";
        };
      };
    in
    [
      thisConfigsOverlay
    ];
}
