{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dr460nixed.development;

  # Distrobox setup scripts
  additionalPackages = ''
    --additional-packages "git tmux micro fish fastfetch wlroots"
  '';
  distrobox-setup = pkgs.writeScriptBin "distrobox-setup" ''
    distrobox create --name arch \
      --init --image quay.io/toolbx/arch-toolbox:latest \
      --additional-packages "git tmux micro fish base-devel pacman-contrib fastfetch"
    distrobox create --name kali \
      --init --image docker.io/kalilinux/kali-rolling:latest \
      ${additionalPackages}
    distrobox generate-entry kali
  '';
in
{
  options.dr460nixed.development = with lib; {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc ''
        Enables commonly used development tools.
      '';
    };
    user = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = mdDoc "The user to configure development tools for.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Conflicts with virtualisation.containers if enabled
    boot.enableContainers = false;

    # Allow building sdcard images for Raspi
    nixpkgs.config.allowUnsupportedSystem = true;

    # Wireshark
    programs.wireshark.enable = true;

    # Virtualbox KVM & Docker
    virtualisation = {
      containers.enable = true;
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
    boot.kernel.sysctl = {
      "vm.overcommit_memory" = "1";
    };

    environment.systemPackages = with pkgs; [
      android-studio
      ansible
      dbeaver-bin
      bruno
      cloudflared
      cmake
      deno
      distrobox
      distrobox-setup
      docker-compose
      fishPlugins.wakatime-fish
      gh
      gnumake
      heroku
      hugo
      jetbrains.webstorm
      jetbrains.rust-rover
      mdbook
      mdbook-admonish
      mdbook-emojicodes
      mdbook-linkcheck
      nil
      nix-prefetch-git
      nixd
      nixos-generators
      nixpkgs-lint
      nixpkgs-review
      nodePackages_latest.bash-language-server
      nodePackages_latest.pnpm
      nodejs_latest
      shellcheck
      shfmt
      sops
      termius
      vscode-fhs
      (yarn-berry.override {
        nodejs = pkgs.nodejs_latest;
      })
      zed-editor
    ];

    # Make android-studio-full happy, and provide me a way to run android VMs
    nixpkgs.config.android_sdk.accept_license = true;

    # Local instances
    networking.hosts = {
      "127.0.0.1" = [
        "metrics.chaotic.local"
        "backend.chaotic.local"
      ];
    };

    # Allow cross-compiling to aarch64
    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  };
}
