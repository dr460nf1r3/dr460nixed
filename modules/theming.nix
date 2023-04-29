{ config
, lib
, pkgs
, ...
}:
with lib;
let
  base16-schemes = pkgs.fetchFromGitHub {
    owner = "tinted-theming";
    repo = "base16-schemes";
    rev = "cf6bc89";
    sha256 = "U9pfie3qABp5sTr3M9ga/jX8C807FeiXlmEZnC4ZM58=";
  };
  base16-theme = "shades-of-purple";

  cfg = config.dr460nixed.theming;

  emoji = {
    package = pkgs.noto-fonts-emoji;
    name = "Noto Color Emoji";
  };
  monospace = {
    package = pkgs.jetbrains-mono;
    name = "Jetbrains Mono Nerd Font";
  };
  sansSerif = {
    package = pkgs.fira;
    name = "Fira Sans";
  };
  serif = config.stylix.fonts.sansSerif;
in
{
  options.dr460nixed.theming = {
    enable = mkOption
      {
        default = true;
        type = types.bool;
        description = mdDoc ''
          Whether the operating system be having a default set of locales set.
        '';
      };
  };

  config = mkIf cfg.enable {
    # Style the operating system using Stylix
    stylix.base16Scheme = "${base16-schemes}/${base16-theme}.yaml";
    stylix.image = builtins.fetchurl {
      url = "https://images.pling.com/img/00/00/36/61/48/1309907/67dee71cfa2a80d3990373ce12365557fd6a.png";
      sha256 = "sha256:0xnjiv1lsavk2gligzaq8jjma60sm3hd1xs19c86cnqcgnkd1a07";
    };
    # Closes I found to Sweet as of now
    stylix.override = {
      scheme = "Catpuccin Mocha";
      base00 = "222235";
      base01 = "181b28";
      base02 = "363a4f";
      base03 = "494d64";
      base04 = "5b6078";
      base05 = "cad3f5";
      base06 = "f4dbd6";
      base07 = "b7bdf8";
      base08 = "ed254e";
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
      inherit emoji;
      inherit monospace;
      inherit sansSerif;
      inherit serif;
    };
  };
}
