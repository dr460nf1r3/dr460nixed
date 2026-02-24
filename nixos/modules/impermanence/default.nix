{ lib, ... }:
{
  options.dr460nixed.impermanence = {
    enable = lib.mkEnableOption "impermanence";
    persistentUsers = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = lib.mdDoc "List of users to apply persistence to.";
    };
  };

  imports = [
    ./persistence.nix
    ./rollback.nix
    ./tools.nix
  ];
}
