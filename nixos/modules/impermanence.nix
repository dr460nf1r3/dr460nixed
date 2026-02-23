{ lib, ... }:
{
  options.dr460nixed.impermanence = {
    enable = lib.mkEnableOption "impermanence";
  };

  imports = [
    ./impermanence/persistence.nix
    ./impermanence/rollback.nix
    ./impermanence/tools.nix
  ];
}
