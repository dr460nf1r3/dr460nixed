{ lib
, modulesPath
, pkgs
, ...
}:
{
  # Slimmed down configurations
  imports = [
    ../../configurations/common/common.nix
    "${modulesPath}/profiles/minimal.nix"
  ];

  # WSL flake settings
  wsl = {
    # NixOS specific settings
    defaultUser = "nico";
    enable = true;
    interop.register = true;
    nativeSystemd = true;
    startMenuLaunchers = true;

    # Enable native Docker support
    docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    docker-desktop.enable = true;

    # Generic WSL settings
    wslConf = {
      automount.root = "/mnt";
      network.generateResolvConf = false;
    };
  };

  # Slimmed down user config
  home-manager = {
    useGlobalPkgs = true;
    users."nico" = import ../../home-manager/common.nix;
  };

  # Override this to always run fish & workaround fastfetch error
  programs.bash.shellInit = lib.mkForce ''
    exec "${pkgs.fish}/bin/fish"
  '';
  programs.fish.shellInit = lib.mkForce ''
    set fish_greeting
    fastfetch -l nixos
  '';

  # NixOS stuff
  system.stateVersion = "23.11";
}
