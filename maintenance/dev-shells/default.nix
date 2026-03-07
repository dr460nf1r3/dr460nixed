{
  config,
  inputs,
  pkgs,
  ...
}:
let
  inherit (config.pre-commit.settings)
    enabledPackages
    ;

  preCommitCompat = pkgs.writeShellScriptBin "pre-commit" ''
    exec ${pkgs.lib.getExe pkgs.prek} "$@"
  '';

  linter = pkgs.callPackage ../tools/linter {
    formatter = config.treefmt.build.wrapper;
  };
in
{
  default = {
    name = "dr460nixed";

    env.NIX_PATH = "nixpkgs=${inputs.nixpkgs}";

    packages = [
      linter
      pkgs.nh
      pkgs.sops
      config.treefmt.build.wrapper
      preCommitCompat
    ]
    ++ enabledPackages;

    enterShell = config.pre-commit.installationScript;
  };

  linter = {
    name = "dr460nixed-linter";

    env.NIX_PATH = "nixpkgs=${inputs.nixpkgs}";

    packages = [
      linter
      preCommitCompat
    ]
    ++ enabledPackages;

    enterShell = config.pre-commit.installationScript;
  };
}
