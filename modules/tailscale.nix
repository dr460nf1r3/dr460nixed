{ config
, lib
, pkgs
, ...
}:
with lib; let
  cfg = config.dr460nixed.tailscale-autoconnect;

  tailscaleJoinArgsList =
    [
      "-authkey"
      "$(cat ${cfg.authFile})"
    ]
    ++ cfg.extraUpArgs;

  tailscaleJoinArgsString = builtins.concatStringsSep " " tailscaleJoinArgsList;

  tailscaleUpScript = ''
    # wait for tailscaled to settle
    sleep 2

    # check if we are already authenticated to tailscale
    status="$(${pkgs.tailscale}/bin/tailscale status -json | ${pkgs.jq}/bin/jq -r .BackendState)"
    if [ $status = "Running" ]; then # if so, then do nothing
      exit 0
    fi

    ${pkgs.tailscale}/bin/tailscale up ${tailscaleJoinArgsString}
  '';
in
{
  options.dr460nixed.tailscale-autoconnect = {
    enable = mkEnableOption "Tailscale client daemon";

    authFile = mkOption {
      type = types.path;
      example = "/run/secrets/tailscale-key";
      description = "File location store tailscale auth-key";
    };

    extraUpArgs = mkOption {
      type = with types; listOf str;
      default = [ ];
      description = "Extra args for tailscale up";
    };
  };

  config = mkIf cfg.enable {
    systemd.services.tailscale-autoconnect = {
      description = "Automatic connection to Tailscale";

      # make sure tailscale is running before trying to connect to tailscale
      after = [ "network-pre.target" "tailscale.service" ];
      wants = [ "network-pre.target" "tailscale.service" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig.Type = "oneshot";
      script = tailscaleUpScript;
    };
  };
}
