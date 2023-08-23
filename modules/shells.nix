{ config
, lib
, pkgs
, ...
}:
with lib;
let
  cfg = config.dr460nixed.shells;
in
{
  options.dr460nixed.shells.enable = mkOption
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
        "deploy" = "deploy -s";
        "reloc-us" = "sudo tailscale up --exit-node=100.75.73.33";
      };
      fish = {
        shellAliases = {
          "deploy" = "deploy -s";
        };
        shellAbbrs = {
          "reloc-us" = "sudo tailscale up --exit-node=100.75.73.33";
        };
      };
    };
  };
}
