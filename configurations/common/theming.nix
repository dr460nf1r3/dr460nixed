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
  stylix.base16Scheme = "${base16-schemes}/dracula.yaml";
  stylix.image = builtins.fetchurl {
    url = "https://gitlab.com/garuda-linux/themes-and-settings/artwork/garuda-wallpapers/-/raw/master/src/garuda-wallpapers/Malefor.jpg";
    sha256 = "sha256-0r6b33k24kq4i3vzp41bxx7gqmw20klakcmw4qy7zana4f3pfnw6";
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
