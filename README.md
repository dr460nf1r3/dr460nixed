# Dr460nixed NixOS ❄️

[![built with nix](https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a)](https://builtwithnix.org) [![built with garnix](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Fgarnix.io%2Fapi%2Fbadges%2Fdr460nf1r3%2Fdr460nixed%3Fbranch%3Dmain)](https://garnix.io) [![Sync Tailscale ACLs](https://github.com/dr460nf1r3/dr460nixed/actions/workflows/tailscale.yml/badge.svg)](https://github.com/dr460nf1r3/dr460nixed/actions/workflows/tailscale.yml)

This repository contains a framework to get started with NixOS quickly, featuring opiniated and selected default settings.
It also contains my personal NixOS configuration, which might serve as inspiration for other peoples' setups.

While starting out with NixOS, especially reading other peoples flakes proved to be very helpful, so I figured sharing my personal setup my help other people as well!
Those who like the "dr460nized" look of Garuda will definitely like this one as well ☺️

## So how does it work?

ISO builds are available as well as a simple installer, which employs `nix flake init` to deploy a basic and generic version of this flake's template based on user's choices.
Partitioning is achieved via [disko](https://github.com/nix-community/disko) presets and the installer may be used on regular NixOS live mediums as well.
Users may then continue building their own version of NixOS using code snippets of this repository and further linked sources.
Furthermore, the flakes' outputs are automatically build and cached via [garnix](https://garnix.io).

There is a [documentation available about various topics](https://nixed.dr460nf1r3.org), which also contains the code snippets that might provide further useful customization options.

## How does it look like?

![desktop-kde](https://i.imgur.com/h3WGSJ4.jpg)

## What settings does the installer provide?

Right now, it basically just bootstraps a basic desktop environment with theming, Nix and OS related defaults to have common things working out of the box.

```nix
{
  dr460nixed = {
    chromium = true;
    desktops.enable = true;
    example-boot.enable = true;
    performance = true;
  };
}
```

Which translates to:

- Enjoying a fully pre-configured [Garuda dr460nized KDE](https://garudalinux.org) themed setup: **Dr460nixed** !
- Being able to use all of [Garuda Nix Subsystems](https://github.com/garuda-linux/garuda-nix-subsystem) modules
- The custom **Linux-cachyos BORE EEVDF** kernel of the [Linux CachyOS](https://cachyos.org) developers
- Having access to additional packages not existing in Nixpkgs (yet) via [Chaotic Nyx](https://nyx.chaotic.cx)
- Using **Garnix CI cache** for this flakes' outputs
- Keeping all of it well organized via **flake-parts**

It might receive more module options in the future, though I currently believe that showing people how to achieve things in Nix might be more useful than just providing a toggle for it.

## What kind of configuration is available via code snippets?

- Multiple **NixOS configurations**, including **desktop**, **server**, **nixos-wsl** , **raspberry pi** & **live-usb**
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

## Credits

Inspiration for parts of this configurations came from these awesome people's setups ❄️

- https://github.com/PedroHLC/system-setup
- https://github.com/Misterio77/nix-config
- https://github.com/isabelroses/dotfiles
