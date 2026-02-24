{
  inputs,
  self,
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
  patchedGarudaSystem =
    args:
    let
      nixpkgsSrc = patchInput "nixpkgs" inputs.nixpkgs;
    in
    if nixpkgsSrc != inputs.nixpkgs then
      inputs.garuda-nix.lib.garudaSystem (
        args
        // {
          # When using a patched nixpkgs, we must ensure it is used
          # However, garudaSystem doesn't easily support overriding nixpkgs
          # without triggering assertions. We'll stick to the original logic
          # but keep it wrapped in garudaSystem to get the modules.
        }
      )
    else
      inputs.garuda-nix.lib.garudaSystem args;

  # Shared binary caches
  binaryCaches = {
    substituters = [
      "https://cache.nixos.org/"
      "https://cache.garnix.io"
      "https://catppuccin.cachix.org"
      "https://nix-community.cachix.org"
      "https://nix-gaming.cachix.org"
      "https://nixpkgs-unfree.cachix.org"
      "https://numtide.cachix.org"
      "https://pre-commit-hooks.cachix.org"
      "https://attic.xuyh0120.win/lantian"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "cache.garnix.io:CTFPyKSLcx5RMJKfLo5EEPUObbA78b0YQ2DTCJXqr9g="
      "catppuccin.cachix.org-1:noG/4HkbhJb+lUAdKrph6LaozJvAeEEZj4N732IysmU="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
      "nixpkgs-unfree.cachix.org-1:hqvoInulhbV4nJ9yJOEr+4wxhDV4xq2d1DK7S6Nj6rs="
      "numtide.cachix.org-1:2ps1kLBUWjxIneOy1Ik6cQjb41X0iXVXeHigGmycPPE="
      "pre-commit-hooks.cachix.org-1:Pkk3Panw5AW24TOv6kz3PvLhlH8puAsJTBbOPmBo7Rc="
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
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
in
{
  inherit
    patchInput
    patchedNixosSystem
    patchedGarudaSystem
    binaryCaches
    jamesdsp
    patchDesktop
    GPUOffloadApp
    ;

  mkColmenaHive =
    nixpkgs: nodeDeployments:
    let
      confs = self.nixosConfigurations;
      mkDefaultDeployment =
        value:
        let
          interfaces = value.config.networking.interfaces or { };
          ipv4Addresses = lib.flatten (
            lib.mapAttrsToList (_ifName: ifCfg: (ifCfg.ipv4.addresses or [ ])) interfaces
          );
          targetHost = if ipv4Addresses == [ ] then null else (builtins.head ipv4Addresses).address;
        in
        lib.optionalAttrs (targetHost != null) { inherit targetHost; };

      colmenaConf = {
        meta = {
          inherit nixpkgs;
          nodeNixpkgs = builtins.mapAttrs (_name: value: value.pkgs) confs;
          nodeSpecialArgs = builtins.mapAttrs (_name: value: value._module.specialArgs) confs;
        };
      }
      // builtins.mapAttrs (nodeName: value: {
        imports = value._module.args.modules;
        deployment = lib.recursiveUpdate (mkDefaultDeployment value) (nodeDeployments.${nodeName} or { });
      }) confs;
    in
    inputs.colmena.lib.makeHive colmenaConf;
}
