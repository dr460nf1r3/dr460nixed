{
  lib,
  pkgs,
  ...
}: {
  # List the packages I need for school but nowhere else
  environment.systemPackages = with pkgs; [
    onedrive
    teams-for-linux
    virt-manager
  ];

  # Enable the GNOME Onedrive extension
  home-manager.users."nico".dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = lib.mkForce [
        "bubblemail@razer.framagit.org"
        "expandable-notifications@kaan.g.inam.org"
        "gsconnect@andyholmes.github.io"
        "onedrive@diegomerida.com"
        "unite@hardpixel.eu"
      ];
    };
  };
}
