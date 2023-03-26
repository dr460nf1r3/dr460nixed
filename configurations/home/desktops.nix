{pkgs, ...}: {
  # Import individual configuration snippets
  imports = [
    ./default-apps.nix
    ./email.nix
    ./gnome.nix
    ./theming.nix
  ];
}
