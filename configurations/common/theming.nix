{
  config,
  lib,
  pkgs,
  ...
}: let
  base16-schemes = pkgs.fetchFromGitHub {
    owner = "tinted-theming";
    repo = "base16-schemes";
    rev = "cf6bc89";
    sha256 = "U9pfie3qABp5sTr3M9ga/jX8C807FeiXlmEZnC4ZM58=";
  };
in {
  # Style the operating system using Stylix - gruvbox-dark-medium on GNOME
  stylix.base16Scheme = "${base16-schemes}/nebula.yaml";
  stylix.image = builtins.fetchurl {
    url = "https://images.pling.com/img/00/00/36/61/48/1309907/67dee71cfa2a80d3990373ce12365557fd6a.png";
    sha256 = "sha256:0xnjiv1lsavk2gligzaq8jjma60sm3hd1xs19c86cnqcgnkd1a07";
  };
  stylix.polarity = "dark";
  stylix.fonts = {
    serif = config.stylix.fonts.sansSerif;
    sansSerif = {
      package = pkgs.fira;
      name = "Fira Sans";
    };
    monospace = {
      package = pkgs.jetbrains-mono;
      name = "Jetbrains Mono Nerd Font";
    };
    emoji = {
      package = pkgs.noto-fonts-emoji;
      name = "Noto Color Emoji";
    };
  };

  # This is false by default for some reason
  stylix.targets.gnome.enable =
    lib.mkIf config.services.xserver.desktopManager.gnome.enable true;
}
