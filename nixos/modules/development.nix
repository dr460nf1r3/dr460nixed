{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.dr460nixed.development;

  # Distrobox setup scripts
  additionalPackages = ''
    --additional-packages "git tmux micro fish fastfetch wlroots"
  '';
  distrobox-setup = pkgs.writeScriptBin "distrobox-setup" ''
    distrobox create --name arch \
      --init --image quay.io/toolbx/arch-toolbox:latest \
      --additional-packages "git tmux micro fish base-devel pacman-contrib fastfetch"
    distrobox generate-entry arch
    distrobox create --name kali \
      --init --image docker.io/kalilinux/kali-rolling:latest \
      ${additionalPackages}
    distrobox generate-entry kali
  '';
in {
  options.dr460nixed.development = with lib; {
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

  config = lib.mkIf cfg.enable {
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

    # Allow building sdcard images for Raspi
    nixpkgs.config.allowUnsupportedSystem = true;

    # Wireshark
    programs.wireshark.enable = true;

    # Virtualbox KVM & Podman with docker alias
    virtualisation = {
      containers.enable = true;
      lxd.enable = false;
      podman = {
        autoPrune.enable = true;
        defaultNetwork.settings.dns_enabled = true;
        # dockerCompat = true;
        # dockerSocket.enable = true;
        enable = true;
      };
      docker = {
        enable = true;
        autoPrune.enable = true;
      };
      virtualbox.host = {
        addNetworkInterface = false;
        enable = true;
        enableExtensionPack = true;
        enableHardening = true;
        enableKvm = true;
      };
    };

    # For Redis
    boot.kernel.sysctl = {"vm.overcommit_memory" = "1";};

    # Archlinux development
    environment.systemPackages = [
      distrobox-setup
    ];

    # Local instances
    networking.hosts = {
      "127.0.0.1" = ["metrics.chaotic.local" "backend.chaotic.local"];
    };

    # Allow cross-compiling to aarch64
    boot.binfmt.emulatedSystems = ["aarch64-linux"];

    # In case I need to fix my phone
    programs.adb.enable = true;
  };
}
