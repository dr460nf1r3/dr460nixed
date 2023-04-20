{ runCommand
, self
, pkgs
, ...
}:
runCommand "nixpkgs-fmt-run-${self.rev or "00000000"}" { } ''
  ${pkgs.nixpkgs-fmt}/bin/nixpkgs-fmt ${self} < /dev/null | tee $out
''
