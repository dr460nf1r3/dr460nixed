{
  lib,
  pkgs,
  modulesPath,
  ...
}:
with lib; let
  nixos-wsl = import ./nixos-wsl;
in {
  # Slimmed down configurations
  imports = [
    ../../configurations/common/common.nix
    ../../configurations/common/locales.nix
    ../../configurations/common/nix.nix
    ../../configurations/common/shells.nix
    ../../configurations/common/theming.nix
    ../../overlays/default.nix
    "${modulesPath}/profiles/minimal.nix"
    nixos-wsl.nixosModules.wsl
  ];

  # WSL flake settings
  wsl = {
    enable = true;
    automountPath = "/mnt";
    defaultUser = "nico";
    startMenuLaunchers = true;

    # Enable native Docker support
    docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    docker-desktop.enable = true;
  };

  # Slimmed down user config
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users."nico" = import ../../configurations/home/nico.nix;
  };

  # Override this to always run fish & workaround fastfetch error
  programs.fish.shellInit = lib.mkForce ''
    exec "${pkgs.fish}/bin/fish"
  '';
  programs.fish.shellInit = lib.mkForce ''
    set fish_greeting
    fastfetch -l nixos
  '';

  # NixOS stuff
  system.stateVersion = "22.11";
}
