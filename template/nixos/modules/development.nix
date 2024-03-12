{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.dr460nixed.development;
in {
  options.dr460nixed.development = {
    enable =
      mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Enables commonly used development tools.
        '';
      };
  };

  config = mkIf cfg.enable {
    # Libvirt & Podman with docker alias
    virtualisation = {
      docker = {
        autoPrune = {
          enable = true;
          flags = ["--all"];
        };
        enable = true;
        enableOnBoot = false;
        storageDriver = "overlay2";
      };
      libvirtd = {
        enable = true;
        parallelShutdown = 2;
        qemu = {
          ovmf = {
            enable = true;
            packages = [pkgs.OVMFFull.fd];
          };
          swtpm.enable = true;
        };
      };
      lxd.enable = false;
    };

    # Allow cross-compiling to aarch64
    boot.binfmt.emulatedSystems = ["aarch64-linux"];

    # In case I need to fix my phone
    programs.adb.enable = true;
  };
}
