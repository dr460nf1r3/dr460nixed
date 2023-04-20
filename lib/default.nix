{ nixpkgs
, lib
, ...
}:
with lib;
nixpkgs.lib.extend (
  _final: _prev: {
    # Filter files that have the .nix suffix
    filterNixFiles = k: v: v == "regular" && hasSuffix ".nix" k;
    # Import files that are selected by filterNixFiles
    importNixFiles = path:
      (lists.forEach (mapAttrsToList (name: _: path + ("/" + name))
        (filterAttrs filterNixFiles (builtins.readDir path))))
        import;
  }
)
