{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.dr460nixed.shells;
in {
  options.dr460nixed.shells.enable =
    mkOption
    {
      default = true;
      type = types.bool;
      description = mdDoc ''
        Whether the shell should receive our aliases and themes.
      '';
    };

  config = mkIf cfg.enable {
    # Programs & global config
    programs = {
      bash.shellAliases = {
        "gpl" = "curl https://www.gnu.org/licenses/gpl-3.0.txt -o LICENSE";
        "tree" = "eza --git --color always -T";
      };
      fish = {
        shellAbbrs = {
          "gpl" = "curl https://www.gnu.org/licenses/gpl-3.0.txt -o LICENSE";
        };
        shellAliases = {
          "tree" = "eza --git --color always -T";
        };
      };
    };
  };
}
