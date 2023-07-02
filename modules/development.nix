{ config
, lib
, pkgs
, ...
}:
with lib;
let
  cfg = config.dr460nixed.development;
in
{
  options.dr460nixed.development = {
    enable = mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Enables commonly used development tools.
        '';
      };
  };

  config = mkIf cfg.enable {
    # Import secrets needed for development
    sops.secrets."api_keys/sops" = {
      mode = "0600";
      owner = config.users.users.nico.name;
      path = "/home/nico/.config/sops/age/keys.txt";
    };
    sops.secrets."api_keys/heroku" = {
      mode = "0600";
      owner = config.users.users.nico.name;
      path = "/home/nico/.netrc";
    };
    sops.secrets."api_keys/cloudflared" = {
      mode = "0600";
      owner = config.users.users.nico.name;
      path = "/home/nico/.cloudflared/cert.pem";
    };

    # Conflicts with virtualisation.containers if enabled
    boot.enableContainers = false;

    # Wireshark
    programs.wireshark.enable = true;

    # Libvirt & Podman with docker alias
    virtualisation = {
      kvmgt.enable = true;
      libvirtd = {
        enable = true;
        parallelShutdown = 2;
        qemu = {
          ovmf = {
            enable = true;
            packages = [ pkgs.OVMFFull.fd ];
          };
          package = pkgs.qemu_kvm;
          swtpm.enable = true;
        };
      };
      lxd.enable = false;
      podman = {
        autoPrune = {
          enable = true;
          flags = [ "--all" ];
        };
        dockerCompat = true;
        dockerSocket.enable = true;
        enable = true;
      };
    };

    # Allow to cross-compile to aarch64
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

    # In case I need to fix my phone & Waydroid
    programs.adb.enable = true;
  };
}
