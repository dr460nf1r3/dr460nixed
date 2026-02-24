{
  config,
  lib,
  ...
}:
let
  cfg = config.dr460nixed.tor;
in
{
  options.dr460nixed.tor = {
    enable = lib.mkEnableOption "the Tor network";
  };

  config = lib.mkIf cfg.enable {
    # Enable the tor network
    services.tor = {
      client.dns.enable = true;
      client.enable = true;
      enable = true;
      torsocks.enable = true;
    };
  };
}
