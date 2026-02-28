{ pkgs, ... }:
with pkgs;
[
  bind
  btop
  cached-nix-shell
  curl
  direnv
  duf
  eza
  fishPlugins.done
  fishPlugins.plugin-git
  fishPlugins.plugin-sudope
  fishPlugins.sponge
  gdu
  jq
  killall
  manix
  micro
  nettools
  python3
  sops
  tldr
  tmux
  tmuxPlugins.catppuccin
  ugrep
  wget
]
