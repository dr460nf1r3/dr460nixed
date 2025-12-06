{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.dr460nixed.compose-runner;
in {
  options.dr460nixed.compose-runner = lib.mkOption (with lib; {
    type = types.attrsOf (types.submodule {
      options = {
        source = mkOption {
          default = null;
          description = "Folder containing a compose file.";
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
        lib.nameValuePair ("compose-runner-" + name) (
          let
            output = derivation {
              builder = pkgs.writeShellScript "build" ''
                PATH="${pkgs.rsync}/bin:${pkgs.coreutils}/bin:${pkgs.gnused}/bin"
                set -e
                mkdir "$out"
                sed -r 's/(^\s+restart:\s*)(unless-stopped|always)(\s*($|#))/\1on-failure\3/g' "$src/compose.yml" > "$out/compose.yml"
                rsync -a "$src/" "$out"
              '';
              name = "compose-runner-" + name;
              src = value.source;
              inherit (pkgs.hostPlatform) system;
            };
            statepath = "/var/compose-runner/${name}";
          in {
            description = "Compose runner for ${name}";
            path = with pkgs; [rsync docker-compose podman bash];
            serviceConfig = {
              ExecStart = pkgs.writeShellScript ("execstart-compose-runner-" + name) ''
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
              ExecStopPost = pkgs.writeShellScript ("execstop-compose-runner-" + name) ''
                set -e
                cd "${statepath}"
                docker-compose down
              '';
            };
            unitConfig = {
              After = "docker.socket";
              Requisite = "docker.socket";
              StopPropagatedFrom = "docker.socket";
            };
            wantedBy = ["multi-user.target"];
          }
        ))
      cfg;
    environment.systemPackages = lib.mkIf (cfg != {}) [pkgs.docker-compose];
    virtualisation.docker.enable = lib.mkIf (cfg != {}) true;
  };
}
