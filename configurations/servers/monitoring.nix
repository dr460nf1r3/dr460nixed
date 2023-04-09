{ lib
, pkgs
, config
, ...
}: {
  # Enable the Netdata daemon
  services.netdata.enable = true;
  services.netdata.config = {
    global = {
      "memory mode" = "none";
      "update every" = "2";
    };
    ml = { "enabled" = "yes"; };
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
    "go.d/nginx.conf" =
      lib.mkIf config.services.nginx.enable
        (pkgs.writeText "nginx.conf" ''
          jobs:
            - name: local
              url: http://localhost/nginx_status
        '');
  };

  # Extra Python & system packages required for Netdata to function
  services.netdata.python.extraPackages = ps: [ ps.psycopg2 ];
  systemd.services.netdata = { path = with pkgs; [ jq ]; };

  # Let Netdata poll Nginx' status page
  services.nginx.statusPage = true;
}
