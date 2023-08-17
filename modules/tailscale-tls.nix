{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.dr460nixed.tailscale-tls;
  domainExpression =
    if cfg.domain-override != null
    then cfg.domain-override
    else "$(${pkgs.tailscale}/bin/tailscale cert 2>&1 | grep use | cut -d '\"' -f2)";
in
{
  options.dr460nixed.tailscale-tls = {
    enable = mkEnableOption "Automatic Tailscale certificates renewal";

    target = mkOption {
      type = types.str;
      description = "Where to put certificates";
      default = "/var/lib/tailscale-tls";
    };

    mode = mkOption {
      type = types.str;
      description = "File mode for certificates";
      default = "0640";
    };

    domain-override = mkOption {
      type = types.nullOr types.str;
      description = "Override domain. Defaults to suggested one by tailscale";
      default = null;
    };
  };

  config = mkIf cfg.enable {
    users.users.tailscale-tls = {
      home = "/var/lib/tailscale-tls";
      group = "tailscale-tls";
      isSystemUser = true;
    };

    users.groups.tailscale-tls = { };

    systemd.services.tailscale-tls = {
      description = "Automatic Tailscale certificates";

      after = [ "network-pre.target" "tailscale.service" ];
      wants = [ "network-pre.target" "tailscale.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig.Type = "oneshot";
      script = ''
        status="Starting"

        until [ $status = "Running" ]; do
          sleep 2
          status=$(${pkgs.tailscale}/bin/tailscale status -json | ${pkgs.jq}/bin/jq -r .BackendState)
        done

        mkdir -p "${cfg.target}"

        DOMAIN=${domainExpression}

        ${pkgs.tailscale}/bin/tailscale cert \
          --cert-file "${cfg.target}/cert.crt" \
          --key-file "${cfg.target}/key.key" \
          "$DOMAIN"

        chown -R tailscale-tls:tailscale-tls "${cfg.target}"

        chmod ${cfg.mode} "${cfg.target}/cert.crt" "${cfg.target}/key.key"
      '';
    };

    systemd.timers.tailscale-tls = {
      description = "Automatic Tailscale certificates renewal";

      after = [ "network-pre.target" "tailscale.service" ];
      wants = [ "network-pre.target" "tailscale.service" ];
      wantedBy = [ "multi-user.target" ];

      timerConfig = {
        OnCalendar = "weekly";
        Persistent = "true";
        Unit = "schedule-test.service";
      };
    };
  };
}
