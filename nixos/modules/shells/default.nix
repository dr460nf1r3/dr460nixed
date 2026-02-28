{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dr460nixed.shells;
in
{
  imports = [ inputs.direnv-instant.nixosModules.direnv-instant ];

  options.dr460nixed.shells.enable =
    lib.mkEnableOption "Whether the shell should receive our aliases and themes."
    // {
      default = true;
    };

  config = lib.mkIf cfg.enable {
    programs = {
      bash = {
        shellAliases = {
          "gpl" = "${pkgs.curl}/bin/curl https://www.gnu.org/licenses/gpl-3.0.txt -o LICENSE";
          "grep" = "${pkgs.ugrep}/bin/ugrep";
        };
      };

      direnv.enable = lib.mkForce false;
      direnv-instant.enable = true;

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
