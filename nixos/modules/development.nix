{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.dr460nixed.development;

  # Building inside a container is most likely the easiest solution
  build-arch = pkgs.writeScriptBin "makepkg-up" ''
    ${pkgs.podman}/bin/podman build -t arch-devel:latest - < ${dockerfile}
  '';
  dockerfile = ./static/Dockerfile;
  enter-arch = pkgs.writeScriptBin "enter-arch" ''
    ${pkgs.podman}/bin/podman run --rm -it -v $PWD:/build -w /build -u builder arch-devel:latest /bin/fish
  '';
  makepkg = pkgs.writeScriptBin "makepkg" ''
    ${pkgs.podman}/bin/podman run --rm -it -v $PWD:/build -w /build -u builder arch-devel:latest makepkg "$@"
  '';
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
        dockerCompat = true;
        dockerSocket.enable = true;
        enable = true;
      };
      virtualbox.host = {
        addNetworkInterface = false;
        enable = true;
        enableExtensionPack = true;
        enableHardening = false;
        enableKvm = true;
      };
    };

    # Archlinux development
    environment.systemPackages = [
      build-arch
      enter-arch
      makepkg
    ];

    # Local instances
    networking.hosts = {
      "127.0.0.1" = ["metrics.chaotic.local" "backend.chaotic.local" ];
    };

    # Allow cross-compiling to aarch64
    boot.binfmt.emulatedSystems = ["aarch64-linux"];

    # In case I need to fix my phone
    programs.adb.enable = true;
  };
}
