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
  stylix.base16Scheme = "${base16-schemes}/shades-of-purple.yaml";
  stylix.image = builtins.fetchurl {
    url = "https://images.pling.com/img/00/00/36/61/48/1309907/67dee71cfa2a80d3990373ce12365557fd6a.png";
    sha256 = "sha256:0xnjiv1lsavk2gligzaq8jjma60sm3hd1xs19c86cnqcgnkd1a07";
  };
  # Closes I found to Sweet as of now
  stylix.override = {
    scheme = "Catpuccin Mocha";
    base00 = "24273a";
    base01 = "1e2030";
    base02 = "363a4f";
    base03 = "494d64";
    base04 = "5b6078";
    base05 = "cad3f5";
    base06 = "f4dbd6";
    base07 = "b7bdf8";
    base08 = "ed8796";
    base09 = "f5a97f";
    base0A = "eed49f";
    base0B = "a6da95";
    base0C = "8bd5ca";
    base0D = "8aadf4";
    base0E = "c6a0f6";
    base0F = "f0c6c6";
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
