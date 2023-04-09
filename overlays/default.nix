{ ... }: {
  # Override applications with useful things I want to have
  nixpkgs.overlays =
    let
      thisConfigsOverlay = final: prev: {
        # OBS with plugins
        obs-studio-wrapped = final.wrapOBS.override { inherit (final) obs-studio; } {
          plugins = with final.obs-studio-plugins; [
            obs-gstreamer
            obs-pipewire-audio-capture
            obs-vaapi
            obs-vkcapture
          ];
        };
        # Telegram Desktop using actual system fonts
        tdesktop-userfonts = prev.tdesktop.overrideDerivation (oa: {
          cmakeFlags =
            [
              "-DDESKTOP_APP_QT6=OFF"
              "-DDESKTOP_APP_USE_PACKAGED_FONTS=OFF"
              "-DTDESKTOP_API_TEST=ON"
            ]
            ++ oa.cmakeFlags;
        });
        # This is quite obvious I guess
        prismlauncher-mod = prev.prismlauncher.overrideDerivation (oa: {
          patches =
            [
              ./offline-mode-prism-launcher.diff
            ]
            ++ oa.patches;
        });
      };
    in
    [ thisConfigsOverlay ];
}
