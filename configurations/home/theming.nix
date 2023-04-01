{pkgs, ...}: {
  # Icon themes & GTK
  gtk = {
    enable = true;
    iconTheme = {
      name = "oomox-gruvbox-dark";
      package = pkgs.gruvbox-dark-icons-gtk;
    };
  };

  # Configure Qt theming
  # qt = {
  #   enable = true;
  #   platformTheme = "kde";
  #   #style.name = "adwaita-dark";
  # };

  # Our cursor theme
  home.pointerCursor = {
    name = "Capitaine-cursors";
    package = pkgs.capitaine-cursors;
    size = 32;
    gtk.enable = true;
  };
}
