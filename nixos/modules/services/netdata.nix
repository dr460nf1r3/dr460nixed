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
    monitoring = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc ''
        Whether to enable monitoring via Netdata.
      '';
    };
  };

  config = lib.mkIf (cfg.enable && cfg.monitoring) {
    # Enable the Netdata daemon
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

    # Extra Python & system packages required for Netdata to function
    services.netdata.package = pkgs.netdata.override { withCloudUi = true; };
    services.netdata.python.extraPackages = ps: [ ps.psycopg2 ];
    systemd.services.netdata = {
      path = with pkgs; [ jq ];
    };

    # Connect to Netdata Cloud easily
    services.netdata.claimTokenFile = config.sops.secrets."api_keys/netdata".path;
    sops.secrets."api_keys/netdata" = {
      mode = "0600";
      owner = "netdata";
      path = "/run/secrets/api_keys/netdata";
    };
  };
}
