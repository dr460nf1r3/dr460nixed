{ lib, ... }:
{
  options.dr460nixed.impermanence = {
    enable = lib.mkEnableOption "impermanence";
  };

  imports = [
    ./persistence.nix
    ./rollback.nix
    ./tools.nix
  ];
}
