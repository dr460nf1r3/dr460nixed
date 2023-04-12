{ lib
, pkgs
, modulesPath
, ...
}:
with lib; let
  nixos-wsl = import ./nixos-wsl;
in
{
  # Slimmed down configurations
  imports = [
    ../../configurations/common/common.nix
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

  # Enable a few selected custom settings
  dr460nixed.common.enable = true;
  dr460nixed.shells.enable = true;

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
