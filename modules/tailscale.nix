{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.dr460nixed.tailscale;

  tailscaleJoinArgsList =
    [
      "-authkey"
      "$(cat ${cfg.authFile})"
    ]
    ++ cfg.extraUpArgs;

  tailscaleJoinArgsString = builtins.concatStringsSep " " tailscaleJoinArgsList;

  tailscaleUpScript = ''
    sleep 2
    status="$(${pkgs.tailscale}/bin/tailscale status -json | ${pkgs.jq}/bin/jq -r .BackendState)"
    if [ $status = "Running" ]; then # if so, then do nothing
      exit 0
    fi
    ${pkgs.tailscale}/bin/tailscale up ${tailscaleJoinArgsString}
  '';
in
{
  options.dr460nixed.tailscale = {
    enable = mkEnableOption "Tailscale client daemon";

    autoConnect = mkOption {
      type = types.bool;
      default = false;
      description = "Whether to automatically connect to Tailscale using an auth key";
    };

    authFile = mkOption {
      type = types.path;
      example = "/run/secrets/tailscale-key";
      description = "File location storing tailscale auth-key";
    };

    extraUpArgs = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = "Extra args for tailscale up";
    };
  };

  config = mkIf cfg.enable {
    # Enable Tailscale service
    services.tailscale.enable = true;

    # Allow Tailscale devices to connect
    networking.firewall.trustedInterfaces = [ "tailscale0" ];

    # Connect to Tailnet automatically
    systemd.services.tailscale-autoconnect = mkIf cfg.autoConnect {
      description = "Automatic connection to Tailscale";

      # Make sure tailscale is running before trying to connect to tailscale
      after = [ "network-pre.target" "tailscale.service" ];
      wants = [ "network-pre.target" "tailscale.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig.Type = "oneshot";
      script = tailscaleUpScript;
    };
  };
}
