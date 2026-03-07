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
    nix = {
      extraOptions = ''
        http-connections = 0
        warn-dirty = false
      '';

      nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
        accept-flake-config = true;
        keep-derivations = true;
        keep-outputs = true;
        keep-going = true;
        log-lines = 20;
        max-jobs = "auto";
        sandbox = pkgs.stdenv.isLinux;
        flake-registry = "/etc/nix/registry.json";

        inherit (inputs.self.dragonLib.binaryCaches) substituters;
        inherit (inputs.self.dragonLib.binaryCaches) trusted-public-keys;
      };
    };

    environment = {
      etc = with inputs; {
        "nix/flake-channels/home-manager".source = home-manager;
        "nix/flake-channels/nixpkgs".source = nixpkgs;
        "nix/flake-channels/system".source = self;
        "nixos/flake".source = self;
      };
      systemPackages = corePkgs;
    };
  };
}
