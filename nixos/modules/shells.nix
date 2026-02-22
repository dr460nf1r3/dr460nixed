{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dr460nixed.shells;
in
{
  options.dr460nixed.shells.enable =
    with lib;
    mkOption {
      default = true;
      type = types.bool;
      description = mdDoc ''
        Whether the shell should receive our aliases and themes.
      '';
    };

  config = lib.mkIf cfg.enable {
    programs = {
      bash = {
        shellAliases = {
          "gpl" = "${pkgs.curl}/bin/curl https://www.gnu.org/licenses/gpl-3.0.txt -o LICENSE";
          "grep" = "${pkgs.ugrep}/bin/ugrep";
        };
      };
      fish = {
        shellAbbrs = {
          "gpl" = "${pkgs.curl}/bin/curl https://www.gnu.org/licenses/gpl-3.0.txt -o LICENSE";
        };
        shellAliases = {
          "grep" = "${pkgs.ugrep}/bin/ugrep";
        };
        useBabelfish = true;
      };
    };
  };
}
