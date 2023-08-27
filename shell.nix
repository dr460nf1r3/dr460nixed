{ pkgs ? import <nixpkgs> { } }:
let
  nix-pre-commit-hooks = import (builtins.fetchTarball "https://github.com/cachix/pre-commit-hooks.nix/tarball/master");
  pre-commit-check = nix-pre-commit-hooks.run {
    src = ./.;
    hooks = {
      deadnix.enable = true;
      nixpkgs-fmt.enable = true;
      prettier.enable = true;
      shellcheck.enable = true;
    };
    settings.deadnix = {
      edit = true;
      hidden = true;
      noLambdaArg = true;
    };
  };
in
pkgs.mkShell {
  name = "dr460nixed";
  shellHook = ''
    ${pre-commit-check.shellHook}
    echo "Welcome to the dr460nixed shell! ❄️"
  '';
  packages = with pkgs; [
    age
    deadnix
    git
    gnupg
    nix
    nixos-generators
    nixpkgs-fmt
    rsync
    sops
    statix
  ];
}
