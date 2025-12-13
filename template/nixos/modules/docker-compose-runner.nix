{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.dr460nixed.docker-compose-runner;
in {
  options.dr460nixed.docker-compose-runner = lib.mkOption (with lib; {
    type = types.attrsOf (types.submodule {
      options = {
        source = mkOption {
          default = null;
          description = "Folder containing a docker-compose file.";
          type = types.path;
        };
        envfile = mkOption {
          default = null;
          description = "Direct path to a valid .env file";
          type = types.nullOr types.path;
        };
      };
    });
    default = {};
  });

  config = {
    systemd.services =
      lib.mapAttrs'
      (name: value:
        lib.nameValuePair ("docker-compose-runner-" + name) (
          let
            output = derivation {
              builder = pkgs.writeShellScript "build" ''
                PATH="${pkgs.rsync}/bin:${pkgs.coreutils}/bin:${pkgs.gnused}/bin"
                set -e
                mkdir "$out"
                rsync -a "$src/" "$out"
              '';
              name = "docker-compose-runner-" + name;
              src = value.source;
              inherit (pkgs.hostPlatform) system;
            };
            statepath = "/var/docker-compose-runner/${name}";
          in {
            description = "docker-compose runner for ${name}";
            path = with pkgs; [rsync docker-compose docker bash];
            serviceConfig = {
              ExecStart = pkgs.writeShellScript ("execstart-docker-compose-runner-" + name) ''
                set -e
                mkdir -p "${statepath}"
                rsync -a --no-owner --size-only "${output}/" "${statepath}"
                ${lib.optionalString (value.envfile != null) ''
                  cp "${value.envfile}" "${statepath}/.env"
                  chmod 600 "${statepath}/.env"
                ''}
                cd "${statepath}"
                docker-compose up
              '';
              ExecStopPost = pkgs.writeShellScript ("execstop-docker-compose-runner-" + name) ''
                set -e
                cd "${statepath}"
                docker-compose down
              '';
            };
            unitConfig = {
              After = "docker.service";
              Requisite = "docker.service";
              StopPropagatedFrom = "docker.service";
            };
            wantedBy = ["multi-user.target"];
          }
        ))
      cfg;
    environment.systemPackages = lib.mkIf (cfg != {}) [pkgs.docker-compose];
    virtualisation.docker.enable = lib.mkIf (cfg != {}) true;
  };
}
