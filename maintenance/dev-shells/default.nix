{
  inputs,
  self,
  pkgs,
  system,
  config,
}:
let
  inherit (config.pre-commit.settings)
    enabledPackages
    ;
  shellHook = config.pre-commit.installationScript;

  preCommitCompat = pkgs.writeShellScriptBin "pre-commit" ''
    exec ${pkgs.lib.getExe pkgs.prek} "$@"
  '';

  linter = pkgs.callPackage ../tools/linter {
    formatter = self.formatter.${system};
  };
in
{
  default = pkgs.mkShell {
    inherit shellHook;

    buildInputs = [
      pkgs.sops
      inputs.colmena.defaultPackage.${system}
      self.formatter.${system}
      self.packages.${system}.write-workflows
      linter
    ];

    packages = enabledPackages ++ [ preCommitCompat ];
  };

  linter = pkgs.mkShell {
    inherit shellHook;

    buildInputs = [ linter ];

    packages = enabledPackages ++ [ preCommitCompat ];
  };
}
