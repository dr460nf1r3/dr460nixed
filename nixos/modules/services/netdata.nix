{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dr460nixed.servers;
in
{
  options.dr460nixed.servers = with lib; {
    monitoring = lib.mkEnableOption "Whether to enable monitoring via Netdata.";
    claimTokenSecret = mkOption {
      type = types.str;
      description = mdDoc "The sops secret name for Netdata claim token.";
    };
  };

  config = lib.mkIf (cfg.enable && cfg.monitoring) {
    services.netdata.enable = true;
    services.netdata.config = {
      global = {
        "dbengine disk space" = "512";
        "memory mode" = "dbengine";
        "update every" = "2";
      };
      ml = {
        "enabled" = "yes";
      };
    };
    services.netdata.configDir = {
      "go.d.conf" = pkgs.writeText "go.d.conf" ''
        enabled: yes
        modules:
          nginx: yes
          web_log: yes
      '';
      "python.d.conf" = pkgs.writeText "python.d.conf" ''
        postgres: no
        web_log: no
      '';
      "go.d/nginx.conf" = lib.mkIf config.services.nginx.enable (
        pkgs.writeText "nginx.conf" ''
          jobs:
            - name: local
              url: http://127.0.0.1/nginx_status
        ''
      );
    };

    services.netdata.package = pkgs.netdata.override { withCloudUi = true; };
    services.netdata.python.extraPackages = ps: [ ps.psycopg2 ];
    systemd.services.netdata = {
      path = with pkgs; [ jq ];
    };

    services.netdata.claimTokenFile = config.sops.secrets.${cfg.claimTokenSecret}.path;
  };
}
