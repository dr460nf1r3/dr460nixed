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
    # Enable Tailscale service
    services.tailscale.enable = true;

    # Allow Tailscale devices to connect
    networking.firewall.trustedInterfaces = [ "tailscale0" ];
  };
}
