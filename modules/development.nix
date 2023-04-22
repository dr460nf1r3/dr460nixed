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

  config = mkIf cfg.enable
    {
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
            ovmf.enable = true;
            ovmf.packages = [ pkgs.OVMFFull.fd ];
            swtpm.enable = true;
            package = pkgs.qemu_kvm;
          };
        };
        lxd.enable = false;
        podman = {
          autoPrune = {
            enable = true;
            flags = [ "--all" ];
          };
          enable = true;
          dockerCompat = true;
          dockerSocket.enable = true;
        };
      };

      # This is supposed to fix "The name org.freedesktop.secret 
      # was not provided by any .service files" in VSCode (from NixOS wiki)
      services.gnome.gnome-keyring.enable = true;

      # Needed for makepkg to work
      environment.etc = {
        "makepkg.conf" = {
          mode = "0644";
          source = builtins.fetchurl {
            url = "https://gitlab.com/garuda-linux/tools/garuda-tools/-/raw/master/data/makepkg.conf";
            sha256 = "1irycfzkx6mfyrq8av3jmxsm139xgw93yn57vz8fl0lz3lsbjvnl";
          };
        };
      };

      # This is a containerized version of Garuda Linux from nspawn.org
      systemd.nspawn."garuda-dev" = {
        enable = true;
        execConfig = {
          Boot = "yes";
          ResolvConf = "on";
          PrivateUsers = 0;
          Capability = "all";
        };
        filesConfig = {
          Bind = [ "/home/nico:/home/root" ];
        };
      };
      systemd.services."systemd-nspawn@garuda-dev" = {
        overrideStrategy = "asDropin";
        wantedBy = [ "machines.target" ];
        environment = { SYSTEMD_NSPAWN_UNIFIED_HIERARCHY = "1"; };
        enable = false;
      };

      # Allow to cross-compile to aarch64
      boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

      # In case I need to fix my phone & Waydroid
      programs.adb.enable = true;
    };
}
