{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.dr460nixed.docker-compose-runner;
in
{
  options.dr460nixed.docker-compose-runner = mkOption {
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
    default = { };
  };

  config = {
    systemd.services = mapAttrs'
      (name: value: nameValuePair ("docker-compose-runner-" + name) (
        let
          output = derivation {
            builder = pkgs.writeShellScript "build" ''
              PATH="${pkgs.rsync}/bin:${pkgs.coreutils}/bin:${pkgs.gnused}/bin"
              set -e
              mkdir "$out"
              sed -r 's/(^\s+restart:\s*)(unless-stopped|always)(\s*($|#))/\1on-failure\3/g' "$src/docker-compose.yml" > "$out/docker-compose.yml"
              rsync -a "$src/" "$out"
            '';
            name = "docker-compose-runner-" + name;
            src = value.source;
            inherit (pkgs.hostPlatform) system;
          };
          statepath = "/var/docker-compose-runner/${name}";
        in
        {
          description = "docker-compose runner for ${name}";
          path = with pkgs; [ rsync docker-compose docker bash ];
          serviceConfig = {
            ExecStart = pkgs.writeShellScript ("execstart-docker-compose-runner-" + name) ''
              set -e
              mkdir -p "${statepath}"
              rsync -a --no-owner --size-only "${output}/" "${statepath}"
              ${optionalString (value.envfile != null) ''
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
          wantedBy = [ "multi-user.target" ];
        }
      ))
      cfg;
    environment.systemPackages = mkIf (cfg != { }) [ pkgs.docker-compose ];
    virtualisation.docker.enable = mkIf (cfg != { }) true;
  };
}
