{
  deadnix,
  formatter,
  statix,
  writeShellScriptBin,
}:
let
  fmtBin = "${formatter}/bin/treefmt";
  statixBin = "${statix}/bin/statix";
  deadnixBin = "${deadnix}/bin/deadnix";
in
writeShellScriptBin "infra-lint" ''
  set -euo pipefail

  ${fmtBin} --ci
  ${statixBin} check .
  ${deadnixBin} --fail .
''
