[![built with nix](https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a)](https://builtwithnix.org) [![Build x86](https://github.com/dr460nf1r3/dr460nixed/actions/workflows/cachix_x86.yml/badge.svg)](https://github.com/dr460nf1r3/dr460nixed/actions/workflows/cachix_x86.yml) [![Sync Tailscale ACLs](https://github.com/dr460nf1r3/dr460nixed/actions/workflows/tailscale.yml/badge.svg)](https://github.com/dr460nf1r3/dr460nixed/actions/workflows/tailscale.yml)

# My personal NixOS flake & system configurations

This repo contains my NixOS dotfiles. All of my devices are going to be added here over time.

![desktop-kde](https://i.imgur.com/h3WGSJ4.jpg)

**What is inside?**:

- Multiple **NixOS configurations**, including **desktop**, **server**, **nixos-wsl** & **live-usb**
- A fully ported & configured **Garuda dr460nized KDE** setup: **Dr460nixed** !
- NixOS / Garuda living in one partition via BTRFS subvolumes using shared Nix store & home subvolumes as well as running both at the same time via **systemd-nspawn** and shared Xorg sessions
- **Opt-in persistence** through impermanence + BTRFS snapshots (currently unused because of using Garuda/NixOS shared home)
- **Mesh networked** hosts with **Tailscale**
- Uses the custom **Linux-cachyos BORE EEVDF** kernel
- Additional packages not existing in Nixpkgs (yet) via **chaotic-nyx**
- Secrets are managed via **nix-sops**
- Automated flake building when pushing to main & pushing to **Cachix** via **GitHub Actions**
- Easy building of configurations & deployment via **Colmena**

Other, smaller tweaks I particularly like about this setup include:

- A much enhanced, fancy-themed Spotify **via spicetify-cli**
- No password prompts when having my **Yubikey** connected to my laptop
- Being able to easily remote-control my machines via **KDEConnect** and a self-hosted **Rustdesk server**
- Having custom **bleeding-edge Mesa** builds

## Structure

- `flake.nix`: Entrypoint for hosts and home configurations. Also exposes a
  devshell for bootstrapping (`nix develop` or `nix-shell`) as well as Colmena configs
- `apps`: Packages built from source
- `configurations`: All the Nix configurations not available via modules, eg. home-manager configurations
- `hosts`: NixOS Configurations, accessible via `nixos-rebuild --flake`
- `modules`: The major part of the system configurations, exposes `dr460nixed.*` options
- `overlays`: Patches and version overrides for some packages
- `pkgs`: My custom packages

## Module options

- `dr460nixed.common.enable` (default false) - enables auto-upgrading the system daily by pulling the updated Nix flake from the repo
- `dr460nixed.common.enable` (default true) - common options for every system
- `dr460nixed.desktops.enable` (default false) - options for desktop systems
- `dr460nixed.development.enable` (default false) - enables a development environment
- `dr460nixed.docker-compose-runner` (default false) - runs a docker-compose.yml and supplies an additional .env file for secrets if desired
- `dr460nixed.gaming.enable` (default false) - gaming-related apps & options
- `dr460nixed.garuda-chroot` (default false) - mounts my Garuda BTRFS subvolumes and creates a systemd-nspawn machine from it
- `dr460nixed.hardening.enable` (default true) - system hardening
- `dr460nixed.live-cd` (default false) - live CD applications
- `dr460nixed.locales` (default true) - does all the localization setup / console font config
- `dr460nixed.performance-tweaks` (default false) - performance-enhancing options
- `dr460nixed.rpi` (default false) - Raspberry Pi related things
- `dr460nixed.school` (default false) - things I need for school
- `dr460nixed.servers.enable` (default false) - common server options
- `dr460nixed.shells` (default true) - enables common shell aliases & theming
- `dr460nixed.systemd-boot` (default true) - a quiet systemd-boot configuration
- `dr460nixed.theming` (default true) - supplies fonts and general system theming via Stylix
- `dr460nixed.yubikey` (default false) - options for using the Yubikey as login

## How to use the flake?

Several preparations have to be made in order to bootstrap a working installation:

- A working `hardware-configuration.nix` needs to be generated for the current machine to replace mine
- The hosts `*.nix` configuration should be adapted to suit the hardware's needs, eg. needed kernel modules or `services.xserver.videoDrivers = [ "amdgpu" ];` should be fitting
- Since `sops-nix` is used to handle secrets, my files need to be replaced with own ones. Usage instructions can be found [here](https://github.com/Mic92/sops-nix#usage-example), basically one needs to create an age public key from the host's ed21559 SSH private key, which is then added to `.sops.yaml` to allow the host to decrypt secrets while booting up. A fitting age key should also be generated and placed in `~/.config/sops/age/keys.txt` as described in the usage instructions - this allows decrypting the secrets file to edit it. It lives in `secrets/global.yaml` and contains the secrets and can be edited with sops `secrets/global.yaml` (opens a terminal text editor).
- It might be easier to supply a static password in `users.nix` for bootstrapping, since no login will be possible if the secrets management isn't properly set up yet. I had a few issues with this in the past while setting things up, so I felt giving this advice might help. Usernames are of course also to be changed, as well as SSH public keys.
- Declarative management of KDE dotfiles is currently turned off as I'm using a shared home with a Garuda installation, to make it immutable just set `immutable` to `true` in `configurations/home/kde.nix` - otherwise you would have a plain KDE desktop without theming unless you provide the configurations seen in the same file manually.

Then, the bootstrapping process can be started. All you need is `nix`. Run:

```
nix-shell
```

If you already have `nix` 2.4+, `git`, and have already enabled `flakes` and
`nix-command`, you can also use the non-legacy command:

```
nix develop
```

`nixos-rebuild --flake .#hostname` to build system configurations.

How to proceed from here?

- Adapt the configurations like enabled modules and home-manager configs to your needs
- Easily deploy to hosts via `colmena apply`
- Add your hosts to Tailscale, if you want to be using it. I can warmly recommend it for connecting with any kind of host!
- ... 😋

## Credits

A special thanks to [PedroHLC](https://github.com/pedrohlc), who always gives great advice and who is also the reason I'm using NixOS today. Also, I studied [Mysterio77](https://github.com/Misterio77)'s and [NotAShelf](https://github.com/NotAShelf)'s Nix configurations while building this one.
