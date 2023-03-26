[![built with nix](https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a)](https://builtwithnix.org) [![Build config](https://github.com/dr460nf1r3/device-configurations/actions/workflows/cachix_x86.yml/badge.svg)](https://github.com/dr460nf1r3/device-configurations/actions/workflows/cachix_x86.yml)

# My personal NixOS flake & system configurations

This repo contains my NixOS dotfiles. All of my personal devices are going to be added here over time.

![desktop](https://i.imgur.com/Ghbgwht.png)
![vscode](https://i.imgur.com/T24G1Tk.png)
![browser](https://i.imgur.com/DlEVFxs.png)


**What is inside?**:

- Multiple **NixOS configurations**, including **desktop**, **server**, **nixos-wsl** & **live-usb**
- **Opt-in persistence** through impermanence + ZFS snapshots
- **Mesh networked** hosts with **zerotier**
- Fully Gruvbox themed & configured operating system using **Stylix** & the **GNOME desktop**
- Secrets are managed via **nix-sops**
- Automated flake building when pushing to main & pushing to **Cachix** via **GitHub Actions**
- Easy building of configurations & deployment via **Colmena**

Other, smaller tweaks I particularly like about this setup include:
- A much enhanced, Gruvbox themed Spotify **via spicetify-cli**
- No password prompts when having my **Yubikey** connected to my laptop
- Being able to easily remote-control my machines via **KDEConnect**
- Having custom, (sometimes too) **bleeding-edge Mesa** builds

## Structure

- `flake.nix`: Entrypoint for hosts and home configurations. Also exposes a
  devshell for boostrapping (`nix develop` or `nix-shell`) as well as Colmena configs.
- `hosts`: NixOS Configurations, accessible via `nixos-rebuild --flake`.
- `apps`: Packages built from source
- `overlays`: Patches and version overrides for some packages.
- `pkgs`: My custom packages.

## How to bootstrap

All you need is nix (any version). Run:

```
nix-shell
```

If you already have nix 2.4+, git, and have already enabled `flakes` and
`nix-command`, you can also use the non-legacy command:

```
nix develop
```

`nixos-rebuild --flake .` To build system configurations

## Credits

A special thanks to [PedroHLC](https://github.com/pedrohlc)
and [Mysterio77](https://github.com/Misterio77), their Nix
configurations helped tremendously while setting all of this up.
