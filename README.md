[![built with nix](https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a)](https://builtwithnix.org) [![built with garnix](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Fgarnix.io%2Fapi%2Fbadges%2Fdr460nf1r3%2Fdr460nixed%3Fbranch%3Dmain)](https://garnix.io)
[![Build images](https://github.com/dr460nf1r3/dr460nixed/actions/workflows/build_images.yml/badge.svg)](https://github.com/dr460nf1r3/dr460nixed/actions/workflows/build_images.yml) [![Sync Tailscale ACLs](https://github.com/dr460nf1r3/dr460nixed/actions/workflows/tailscale.yml/badge.svg)](https://github.com/dr460nf1r3/dr460nixed/actions/workflows/tailscale.yml)

# My personal NixOS flake & system configurations

This repo contains my NixOS dotfiles. Every device supported by NixOS will be added here! 😎

![desktop-kde](https://i.imgur.com/h3WGSJ4.jpg)

**What is inside?**:

- Multiple **NixOS configurations**, including **desktop**, **server**, **nixos-wsl** , **raspberry pi** & **live-usb**
- A fully ported & configured **Garuda dr460nized KDE** setup: **Dr460nixed** !
- Root-on-ZFS and secure-boot enabled systems via **Lanzaboote**
- **Opt-in persistence** through impermanence + ZFS snapshots
- **Mesh networked** hosts with **Tailscale** and optional use of Mullvad VPN exit nodes
- Uses the custom **Linux-cachyos BORE EEVDF** kernel
- Additional packages not existing in Nixpkgs (yet) via **chaotic-nyx**
- **Opt-in 2FA protection** of ssh and password prompts **with Duo Security**
- Secrets are managed via **nix-sops**
- Uses **Garnix CI** for automated flake checks followed by building outputs when pushing to main & uploading to **Garnix CI cache**
- Always up-to-date installer images are automatically built via **Github actions**

Other, smaller tweaks I particularly like about this setup include:

- Keeping it well organized via **flake-parts**
- Custom devshells with fully declarative **pre-commit-hooks**
- A much enhanced, fancy-themed Spotify **via spicetify-cli**
- No password prompts when having my **Yubikey** connected to my laptop
- Being able to easily remote-control my machines via **KDEConnect** and a self-hosted **Rustdesk server**
- Having custom **bleeding-edge Mesa** builds
- Easy deployment of mdBook-generated documentation to Cloudflare pages

## Documentation

A fully searchable, mdBook-based documentation is available [here](https://nixed.dr460nf1r3.org).

## Structure

```
├── docker-compose
│   ├── oracle-dragon
│   └── tv-nixos
├── home-manager
├── nixos
│   ├── dragons-ryzen
│   ├── images
│   ├── modules
│   │   ├── chaotic
│   │   └── disko
│   ├── nixos-wsl
│   ├── oracle-dragon
│   ├── rpi-dragon
│   └── tv-nixos
├── overlays
└── secrets
```
