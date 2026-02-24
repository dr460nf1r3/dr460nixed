{ lib, ... }:
let
  files = builtins.readDir ./.;

  # Top-level .nix files (excluding default.nix itself)
  nixFiles = lib.filterAttrs (
    name: type: name != "default.nix" && type == "regular" && lib.hasSuffix ".nix" name
  ) files;

  # Subdirectories — each must have a default.nix
  nixDirs = lib.filterAttrs (_name: type: type == "directory") files;

  validModules =
    lib.mapAttrsToList (name: _: ./. + "/${name}") nixFiles
    ++ lib.mapAttrsToList (name: _: ./. + "/${name}") nixDirs;
in
{
  imports = [
    ../../overlays
  ]
  ++ validModules;
}
