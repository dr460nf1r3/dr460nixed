# Shell for bootstrapping flake-enabled nix and other tooling
{ pkgs ? # If pkgs is not defined, instanciate nixpkgs from locked commit
  let
    lock = (builtins.fromJSON (builtins.readFile ./flake.lock)).nodes.nixpkgs.locked;
    nixpkgs = fetchTarball {
      url = "https://github.com/nixos/nixpkgs/archive/${lock.rev}.tar.gz";
      sha256 = lock.narHash;
    };
  in
  import nixpkgs { overlays = [ ]; }
, ...
}:
let
  nix-pre-commit-hooks = import (builtins.fetchTarball "https://github.com/cachix/pre-commit-hooks.nix/tarball/master");
  pre-commit-check = nix-pre-commit-hooks.run {
    hooks = {
      actionlint.enable = true;
      commitizen.enable = true;
      deadnix.enable = true;
      nil.enable = true;
      nixpkgs-fmt.enable = true;
      pre-commit-hook-ensure-sops.enable = true;
      prettier.enable = true;
      shellcheck.enable = true;
      shfmt.enable = true;
      statix.enable = true;
      yamllint.enable = true;
    };
    settings.deadnix = {
      edit = true;
      hidden = true;
      noLambdaArg = true;
    };
    src = ../.;
  };
in
pkgs.mkShell {
  name = "dr460nixed";
  packages = with pkgs; [
    age
    commitizen
    git
    gnupg
    manix
    nixos-generators
    rsync
    sops
    yamlfix
  ];
  shellHook = ''
    ${pre-commit-check.shellHook}
    echo "Welcome to the dr460nixed shell! ❄️"
  '';
  NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";
}
