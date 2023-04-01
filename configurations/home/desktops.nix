{...}: {
  # Import individual configuration snippets
  imports = [
    ./browsers.nix
    ./default-apps.nix
    ./development.nix
    ./email.nix
    ./kde.nix
    ./misc.nix
    ./nico.nix
    #./spicetify.nix
  ];
}
