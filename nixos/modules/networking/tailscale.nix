{
  config,
  lib,
  ...
}:
let
  cfg = config.dr460nixed.tailscale;
in
{
  options.dr460nixed.tailscale = with lib; {
    enable = mkEnableOption "Tailscale client daemon";
  };

  config = lib.mkIf cfg.enable {
    services.tailscale.enable = true;

    networking.firewall.trustedInterfaces = [ "tailscale0" ];
  };
}
