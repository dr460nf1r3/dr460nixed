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
    src = ./.;
    hooks = {
      actionlint.enable = true;
      commitizen.enable = true;
      deadnix.enable = true;
      hadolint.enable = true;
      nil.enable = true;
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
  packages = with pkgs; [
    age
    commitizen
    deadnix
    git
    gnupg
    manix
    nix
    nixos-generators
    nixpkgs-fmt
    nodePackages_latest.prettier
    rsync
    sops
    statix
  ];
  shellHook = ''
    ${pre-commit-check.shellHook}
    echo "Welcome to the dr460nixed shell! ❄️"
  '';
  NIX_CONFIG = "extra-experimental-features = nix-command flakes repl-flake";
}
