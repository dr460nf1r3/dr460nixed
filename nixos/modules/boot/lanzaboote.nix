{
  config,
  lib,
  ...
}:
let
  cfgLanza = config.dr460nixed.lanzaboote;
in
{
  config = lib.mkIf (cfgLanza.enable && config.boot ? lanzaboote) {
    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    boot.loader.systemd-boot.enable = lib.mkForce false;
  };
}
