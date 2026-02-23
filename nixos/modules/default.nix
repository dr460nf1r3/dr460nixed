{ lib, ... }:
let
  # Find all .nix files in the current directory, excluding default.nix
  # We only take top-level files to avoid importing mutually exclusive modules from subdirs
  files = builtins.readDir ./.;
  nixFiles = lib.filterAttrs (
    name: type: name != "default.nix" && type == "regular" && lib.hasSuffix ".nix" name
  ) files;
  validModules = lib.mapAttrsToList (name: _: ./. + "/${name}") nixFiles;
in
{
  imports = [
    ../../overlays
  ]
  ++ validModules;
}
