{ pkgs
, lib
, sources
, ...
}:
let
  # future = nixpkgs-staging.legacyPackages.${pkgs.system};
  dropN = n: list: lib.lists.take (builtins.length list - n) list;

  mesaGitApplier = base:
    base.mesa.overrideAttrs (fa: {
      version = "23.1.99";
      src = sources.mesa-git-src;
      buildInputs = fa.buildInputs ++ [ base.libunwind base.lm_sensors ];
      mesonFlags =
        lib.lists.remove "-Dgallium-rusticl=true" fa.mesonFlags; # fails to find "valgrind.h"
      #  ++ ["-Dandroid-libbacktrace=disabled"];
      #patches = dropN 1 fa.patches ++ [./disk_cache-include-dri-driver-path-in-cache-key.patch];
    });

  mesa-bleeding = mesaGitApplier pkgs;
  lib32-mesa-bleeding = mesaGitApplier pkgs.pkgsi686Linux;
in
{
  # Apply latest mesa in the system
  hardware.opengl.package = mesa-bleeding.drivers;
  hardware.opengl.package32 = lib32-mesa-bleeding.drivers;
  hardware.opengl.extraPackages = [ mesa-bleeding.opencl ];
}
