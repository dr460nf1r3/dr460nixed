{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dr460nixed.shells;
in {
  options.dr460nixed.shells.enable = with lib;
    mkOption
    {
      default = true;
      type = types.bool;
      description = mdDoc ''
        Whether the shell should receive our aliases and themes.
      '';
    };

  config = lib.mkIf cfg.enable {
    # Programs & global config
    programs = {
      bash.shellAliases = {
        "bootsda" = ''
          sudo qemu-kvm \
          -m 4G \
          -drive file=/dev/sda,format=raw,index=0,media=disk \
          -net user,hostfwd=tcp:127.0.0.1:2222-:22 \
          -net nic
        '';
        "bootsdb" = ''
          sudo qemu-kvm
          -m 4G \
          -drive file=/dev/sdb,format=raw,index=0,media=disk \
          -net user,hostfwd=tcp:127.0.0.1:2222-:22 \
          -net nic
        '';
        "gpl" = "${pkgs.curl}/bin/curl https://www.gnu.org/licenses/gpl-3.0.txt -o LICENSE";
        "grep" = "${pkgs.ugrep}/bin/ugrep";
      };
      fish = {
        shellAbbrs = {
          "bootusb" = ''
            sudo qemu-kvm \
            -m 4G \
            -drive file=/dev/sda,format=raw,index=0,media=disk \
            -net user,hostfwd=tcp:127.0.0.1:2222-:22 \
            -net nic
          '';
          "gpl" = "${pkgs.curl}/bin/curl https://www.gnu.org/licenses/gpl-3.0.txt -o LICENSE";
        };
        shellAliases = {
          "grep" = "${pkgs.ugrep}/bin/ugrep";
        };
      };
    };
  };
}
