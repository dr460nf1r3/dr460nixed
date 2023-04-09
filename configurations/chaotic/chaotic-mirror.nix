{ lib
, pkgs
, config
, sources
, ...
}:
with lib; let
  cfg = config.services.chaotic-mirror;
  repo = derivation {
    name = "chaotic-mirror";
    src = sources.chaotic-mirror;
    envfile = pkgs.writeText "envfile" ''
      DOMAIN_NAME=${cfg.domain}
      EMAIL=${cfg.email}
      ${
        if pkgs.hostPlatform.system == "aarch64-linux"
        then "LETSENCRYPT_TAG=arm64v8-latest"
        else ""
      }
      RESTART=on-failure
    '';
    builder = pkgs.writeShellScript "build" ''
      PATH="${pkgs.gnutar}/bin:${pkgs.rsync}/bin:${pkgs.coreutils}/bin"
            set -e
            mkdir "$out"
            cp "$envfile" "$out/.env"
            rsync -a "$src/" "$out"
    '';
    system = pkgs.hostPlatform.system;
  };
in
{
  options.services.chaotic-mirror = {
    enable = mkEnableOption "Chaotic Mirror service";
    domain = mkOption { type = types.str; };
    email = mkOption { type = types.str; };
  };

  config = mkIf cfg.enable {
    systemd.services.chaotic-mirror = {
      wantedBy = [ "multi-user.target" ];
      description = "Start the chaotic-aur mirror";
      path = with pkgs; [ rsync docker-compose docker bash gawk ];
      serviceConfig = {
        CacheDirectory = "chaotic-mirror";
        CacheDirectoryMode = "0755";
        ExecStart = pkgs.writeShellScript "execstart" ''
          rsync -a --no-owner --size-only "${repo}/" "/var/cache/chaotic-mirror"
          cd "/var/cache/chaotic-mirror"
          COMPOSEFLAGS=" " bash ./run
        '';
        ExecStopPost = pkgs.writeShellScript "execstop" ''
          cd "/var/cache/chaotic-mirror"
          bash ./stop
        '';
      };
      unitConfig = {
        After = "docker.service";
        StopPropagatedFrom = "docker.service";
        Requisite = "docker.service";
      };
    };
    virtualisation.docker.enable = true;
  };
}
