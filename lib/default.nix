{
  inputs,
  ...
}:
let
  inherit (inputs.nixpkgs) lib;

  # Patching helper for ANY input
  patchInput =
    inputName: inputSource:
    let
      patches = builtins.filter (a: a != null) (
        lib.mapAttrsToList (
          name: patch: if lib.hasPrefix "${inputName}-patch-" name then patch else null
        ) inputs
      );
    in
    if builtins.length patches > 0 then
      inputs.nixpkgs.legacyPackages.x86_64-linux.applyPatches {
        inherit patches;
        name = "${inputName}-patched";
        src = inputSource;
      }
    else
      inputSource;

  # Patched nixosSystem helper
  patchedNixosSystem =
    args:
    let
      nixpkgsSrc = patchInput "nixpkgs" inputs.nixpkgs;
    in
    if nixpkgsSrc != inputs.nixpkgs then
      import (nixpkgsSrc + "/nixos/lib/eval-config.nix") args
    else
      inputs.nixpkgs.lib.nixosSystem args;

  # Patched garudaSystem helper
  #
  # When nixpkgs-patch-* inputs are present, we can't call garuda-nix's
  # garudaSystem directly (it always uses its own nixpkgs closure).  Instead
  # we replicate its behaviour — injecting its modules and garuda-lib — but
  # drive evaluation from eval-config.nix in the patched source tree so that
  # *all* pkgs and lib come from the patched nixpkgs.
  #
  # garuda-nix exports both `internal` and `lib.garuda-lib`, so no local
  # copy of the subsystem is needed.
  patchedGarudaSystem =
    args:
    let
      nixpkgsSrc = patchInput "nixpkgs" inputs.nixpkgs;
      hasPatch = nixpkgsSrc != inputs.nixpkgs;
    in
    if hasPatch then
      import (nixpkgsSrc + "/nixos/lib/eval-config.nix") (
        args
        // {
          extraModules = [ inputs.garuda-nix.internal.modules.default ] ++ args.extraModules or [ ];
          specialArgs = {
            inherit (inputs.garuda-nix.lib) garuda-lib;
          }
          // args.specialArgs or { };
        }
      )
    else
      inputs.garuda-nix.lib.garudaSystem args;

  # Shared binary caches
  binaryCaches = {
    substituters = [
      "https://attic.xuyh0120.win/lantian"
      "https://cache.garnix.io"
      "https://cache.nixos.org"
      "https://catppuccin.cachix.org"
      "https://nix-community.cachix.org"
      "https://nixpkgs-unfree.cachix.org"
      "https://numtide.cachix.org"
      "https://pre-commit-hooks.cachix.org"
    ];
    trusted-public-keys = [
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
    ];
  };

  # Shared JamesDSP presets
  jamesdsp = pkgs: {
    game = pkgs.fetchurl {
      url = "https://cloud.garudalinux.org/s/eimgmWmN485tHGw/download/game.irs";
      sha256 = "0d1lfbzca6wqfqxd6knzshc00khhgfqmk36s5xf1wyh703sdxk79";
    };
    movie = pkgs.fetchurl {
      url = "https://cloud.garudalinux.org/s/K8CpHZYTiLyXLSd/download/movie.irs";
      sha256 = "1r3s8crbmvzm71yqrkp8d8x4xyd3najz82ck6vbh1v9kq6jclc0w";
    };
    music = pkgs.fetchurl {
      url = "https://cloud.garudalinux.org/s/cbPLFeAMeJazKxC/download/music-balanced.irs";
      sha256 = "1szssbqk3dnaqhg3syrzq9zqfb18phph5yy5m3xfnjgllj2yphy0";
    };
    voice = pkgs.fetchurl {
      url = "https://cloud.garudalinux.org/s/wJSs9gckrNidTBo/download/voice.irs";
      sha256 = "1b643m8v7j15ixi2g6r2909vwkq05wi74ybccbdnp4rkms640y4w";
    };
  };

  # Patching helper for desktop entries
  patchDesktop =
    pkgs: pkg: appName: from: to:
    lib.hiPrio (
      pkgs.runCommand "$patched-desktop-entry-for-${appName}" { } ''
        ${pkgs.coreutils}/bin/mkdir -p $out/share/applications
        ${pkgs.gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop
      ''
    );

  # Helper for GPU offloading
  GPUOffloadApp =
    config: pkgs: pkg: desktopName:
    lib.mkIf (config.hardware.nvidia.prime.offload.enable or false) (
      patchDesktop pkgs pkg desktopName "^Exec=" "Exec=nvidia-offload "
    );

  syncthing = rec {
    devices = {
      "cup-dragon" = {
        id = "GNQFVZZ-XAGOWKF-PZPU3IN-W5FD557-JW56VG7-DKOR3UI-56TV4AZ-M7QXCQQ";
      };
      "dragons-strix" = {
        id = "QCUPS44-GCT2ITB-PN3HVFK-THOL6X4-NB7R6AH-W7GFHNS-MH26XTZ-BQ6SZAE";
      };
      "dragons-ryzen" = {
        id = "TBAC4NJ-F36QTJG-PSZMSEW-OAZQSWR-65CYJPE-AZ5VI5T-3Z34D4B-H2QMRQZ";
      };
      "dragons-pixel" = {
        id = "UURR5YB-OKRGL74-3VHQLBQ-KUXX4T3-AE74U2Z-IXCZVKF-KHOCOO5-KO7JBAD";
      };
    };
    getDevicesFor = hostName: lib.filterAttrs (name: _: name != hostName) devices;
  };
in
{
  inherit
    patchInput
    patchedNixosSystem
    patchedGarudaSystem
    binaryCaches
    jamesdsp
    patchDesktop
    syncthing
    GPUOffloadApp
    ;
}
