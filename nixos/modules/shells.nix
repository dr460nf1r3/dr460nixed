{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dr460nixed.shells;
in {
  options.dr460nixed.shells.enable = with lib;
    mkOption
    {
      default = true;
      type = types.bool;
      description = mdDoc ''
        Whether the shell should receive our aliases and themes.
      '';
    };

  config = lib.mkIf cfg.enable {
    # Programs & global config
    programs = {
      bash.shellAliases = {
        "gpl" = "${pkgs.curl}/bin/curl https://www.gnu.org/licenses/gpl-3.0.txt -o LICENSE";
        "grep" = "${pkgs.ugrep}/bin/ugrep";
        "nix" = "${pkgs.nix}/bin/nix --verbose --print-build-logs"; # https://github.com/NixOS/nix/pull/8323
      };
      fish = {
        shellAbbrs = {
          "gpl" = "${pkgs.curl}/bin/curl https://www.gnu.org/licenses/gpl-3.0.txt -o LICENSE";
        };
        shellAliases = {
          "grep" = "${pkgs.ugrep}/bin/ugrep";
          "nix" = "${pkgs.nix}/bin/nix --verbose --print-build-logs"; # https://github.com/NixOS/nix/pull/8323
        };
      };
    };
  };
}
