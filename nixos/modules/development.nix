{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.dr460nixed.development;

  # Distrobox setup scripts
  additionalPackages = ''
    --additional-packages "git tmux micro fish fastfetch wlroots"
  '';
  distrobox-setup = pkgs.writeScriptBin "distrobox-setup" ''
    distrobox create --name arch \
      --init --image quay.io/toolbx/arch-toolbox:latest \
      --additional-packages "git tmux micro fish base-devel pacman-contrib fastfetch" \
      --init-hooks "pacman-key --init && pacman-key --recv-key 0706B90D37D9B881 3056513887B78AEB --keyserver keyserver.ubuntu.com && pacman-key --lsign-key 0706B90D37D9B881 3056513887B78AEB && pacman --noconfirm -U 'https://geo-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' && pacman --noconfirm -U 'https://geo-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst' && echo '[multilib]' >>/etc/pacman.conf && echo 'Include = /etc/pacman.d/mirrorlist' >>/etc/pacman.conf && echo '[garuda]' >>/etc/pacman.conf && echo 'Include = /etc/pacman.d/chaotic-mirrorlist' >>/etc/pacman.conf && echo '[chaotic-aur]' >>/etc/pacman.conf && echo 'Include = /etc/pacman.d/chaotic-mirrorlist' >>/etc/pacman.conf"
    distrobox generate-entry arch
    distrobox create --name debian \
      --init --image quay.io/toolbx-images/debian-toolbox:unstable \
      ${additionalPackages}
    distrobox generate-entry debian
    distrobox create --name steamos \
      --init --image ghcr.io/linuxserver/steamos:latest \
      ${additionalPackages}
    distrobox generate-entry steamos
    distrobox create --name void \
      --init --image ghcr.io/void-linux/void-glibc-full:latest \
      ${additionalPackages}
    distrobox generate-entry void
    distrobox create --name kali \
      --init --image docker.io/kalilinux/kali-rolling:latest \
      ${additionalPackages}
    distrobox generate-entry kali
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
        enableHardening = true;
        # enableKvm = true; patch is currently failing
      };
    };

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
