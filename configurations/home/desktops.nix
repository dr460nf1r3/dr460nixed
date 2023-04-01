{pkgs, ...}: {
  # Import individual configuration snippets
  imports = [
    ./default-apps.nix
    ./email.nix
    ./kde.nix
    ./nico.nix
    ./theming.nix
  ];
}
