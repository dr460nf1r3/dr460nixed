{
  pkgs,
  lib,
  ...
}: {
  # Icon themes & GTK
  gtk = {
    enable = true;
    iconTheme = {
      name = "oomox-gruvbox-dark";
      package = pkgs.gruvbox-dark-icons-gtk;
    };
  };

  # Configure Qt theming
  qt = {
    enable = true;
    platformTheme = "gtk";
    style.name = "adwaita-dark";
  };

  # Our cursor theme
  home.pointerCursor = {
    name = "Numix-Cursor";
    package = pkgs.numix-cursor-theme;
    size = 32;
    gtk.enable = true;
  };
}
