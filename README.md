# Dr460nixed NixOS ❄️

[![built with nix](https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a)](https://builtwithnix.org) [![built with garnix](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Fgarnix.io%2Fapi%2Fbadges%2Fdr460nf1r3%2Fdr460nixed%3Fbranch%3Dmain)](https://garnix.io) [![Sync Tailscale ACLs](https://github.com/dr460nf1r3/dr460nixed/actions/workflows/tailscale.yml/badge.svg)](https://github.com/dr460nf1r3/dr460nixed/actions/workflows/tailscale.yml)

This repository contains a framework for NixOS configuration, featuring opinionated and selected default
settings. It also includes my personal NixOS setup, which may serve as inspiration for others.

While starting out with NixOS, reading other people's flakes proved very helpful, so I'm sharing my own configuration.
Those who like the "dr460nized" look of Garuda will definitely enjoy this one ☺️

## Overview

This flake provides various NixOS configurations, modules, and helper utilities. Outputs are automatically built and
cached via [garnix](https://garnix.io). You can adapt snippets from the documentation to craft your own setup.

There is [documentation available](https://nixed.dr460nf1r3.org), which contains code snippets and other topics that
might be useful for customization.

## How does it look like?

![desktop-kde](https://i.imgur.com/h3WGSJ4.jpg)

## What kind of configuration is available via code snippets?

- Multiple **NixOS configurations** such as `cup-dragon`, `dev-container`, `dragons-ryzen`, `dragons-strix`,
  `dr460nixed-base`, `dr460nixed-desktop`, and `nixos-wsl`.
- Root-on-ZFS and secure-boot enabled systems via **Lanzaboote**
- **Opt-in persistence** through impermanence + ZFS snapshots
- **Mesh networked** hosts with **Tailscale**
- **Opt-in 2FA protection** of ssh and password prompts **with Duo Security**
- Secrets managed via **nix-sops**
- Always up-to-date live images automatically built via **Github actions**
- Custom devshells with fully declarative **pre-commit-hooks**
- No password prompts when having a **Yubikey** connected to a device
- Easily remote-controllable machines via **KDEConnect** and a self-hosted **Rustdesk server**
- Custom **bleeding-edge Mesa** builds

## Structure

```sh
├── compose/
│   └── cup-dragon/
├── docs/
├── garuda-nix-subsystem/
├── home-manager/
├── hosts/
├── lib/
├── maintenance/
├── nixos/
│   ├── modules/
│   └── flake-module.nix
├── overlays/
├── packages/
├── secrets/
└── users/
```

## Credits

Inspiration for parts of this configuration came from these awesome people's setups ❄️

- https://github.com/PedroHLC/system-setup
- https://github.com/Misterio77/nix-config
- https://github.com/isabelroses/dotfiles
