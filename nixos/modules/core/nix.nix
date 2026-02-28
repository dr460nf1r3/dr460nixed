{
  inputs,
  pkgs,
  self,
  lib,
  ...
}:
let
  corePkgs = import ../apps/core-packages.nix { inherit pkgs lib; };
in
{
  config = {
    # General nix settings
    nix = {
      # Dont warn about dirty flakes and accept flake configs by default
      extraOptions = ''
        http-connections = 0
        warn-dirty = false
      '';

      # Set the nix path, needed e.g. for Nixd
      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

      # Nix.conf settings
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];

        # Accept flake configs by default
        accept-flake-config = true;

        # Lix cache
        extra-substituters = [ "https://cache.lix.systems" ];

        # For direnv GC roots
        keep-derivations = true;
        keep-outputs = true;

        # Continue building derivations if one fails
        keep-going = true;

        # Show more log lines for failed builds
        log-lines = 20;

        # Max number of parallel jobs
        max-jobs = "auto";

        # Build inside sandboxed environments
        sandbox = pkgs.stdenv.isLinux;

        # Specify the path to the nix registry
        flake-registry = "/etc/nix/registry.json";

        inherit (inputs.self.dragonLib.binaryCaches) substituters;
        inherit (inputs.self.dragonLib.binaryCaches) trusted-public-keys;
      };
    };

    environment = {
      etc = with inputs; {
        # set channels (backwards compatibility)
        "nix/flake-channels/home-manager".source = home-manager;
        "nix/flake-channels/nixpkgs".source = nixpkgs;
        "nix/flake-channels/system".source = self;

        # preserve current flake in /etc
        "nixos/flake".source = self;
      };

      # Git is required for flakes, and cachix for binary substituters.
      # the full list is shared with home-manager so that the same set of
      # "core" tools is available whether the configuration is evaluated on
      # a NixOS host or a standalone machine.
      systemPackages = corePkgs;
    };
  };
}
