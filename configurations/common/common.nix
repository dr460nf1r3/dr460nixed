{ pkgs
, ...
}: {
  imports = [
    ./auto-upgrade.nix
    ./locales.nix
    ./theming.nix
    ./users.nix
    ../../overlays/default.nix
  ];
}
