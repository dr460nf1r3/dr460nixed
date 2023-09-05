[![built with nix](https://img.shields.io/static/v1?logo=nixos&logoColor=white&label=&message=Built%20with%20Nix&color=41439a)](https://builtwithnix.org) [![built with garnix](https://img.shields.io/endpoint.svg?url=https%3A%2F%2Fgarnix.io%2Fapi%2Fbadges%2Fdr460nf1r3%2Fdr460nixed%3Fbranch%3Dmain)](https://garnix.io)
[![Build images](https://github.com/dr460nf1r3/dr460nixed/actions/workflows/build_images.yml/badge.svg)](https://github.com/dr460nf1r3/dr460nixed/actions/workflows/build_images.yml) [![Periodic flake bump](https://github.com/dr460nf1r3/dr460nixed/actions/workflows/periodic_bump.yml/badge.svg)](https://github.com/dr460nf1r3/dr460nixed/actions/workflows/periodic_bump.yml) [![Sync Tailscale ACLs](https://github.com/dr460nf1r3/dr460nixed/actions/workflows/tailscale.yml/badge.svg)](https://github.com/dr460nf1r3/dr460nixed/actions/workflows/tailscale.yml)

# My personal NixOS flake & system configurations

This repo contains my NixOS dotfiles. Every device supported by NixOS will be added here! 😎

![desktop-kde](https://i.imgur.com/h3WGSJ4.jpg)

**What is inside?**:

- Multiple **NixOS configurations**, including **desktop**, **server**, **nixos-wsl** , **raspberry pi** & **live-usb**
- A fully ported & configured **Garuda dr460nized KDE** setup: **Dr460nixed** !
- Root-on-ZFS and secure-boot enabled systems via **Lanzaboote**
- **Opt-in persistence** through impermanence + ZFS snapshots
- **Mesh networked** hosts with **Tailscale**
- Uses the custom **Linux-cachyos BORE EEVDF** kernel
- Additional packages not existing in Nixpkgs (yet) via **chaotic-nyx**
- **Opt-in 2FA protection** of ssh and password prompts **with Duo Security**
- Secrets are managed via **nix-sops**
- Automated flake building when pushing to main & pushing to **Cachix** via **GitHub Actions**
- Always up-to-date installer images are automatically built via **Github actions**

Other, smaller tweaks I particularly like about this setup include:

- A much enhanced, fancy-themed Spotify **via spicetify-cli**
- No password prompts when having my **Yubikey** connected to my laptop
- Being able to easily remote-control my machines via **KDEConnect** and a self-hosted **Rustdesk server**
- Having custom **bleeding-edge Mesa** builds

## Structure

```
├── configurations
├── disko
├── flake.nix
├── home-manager
├── hosts
├── modules
├── overlays
├── secrets
└── shell.nix
```

- `configurations`: All the Nix configurations not available via modules, eg. home-manager configurations
- `disco`: Configurations for managing partitions & filesystems
- `flake.nix`: Entrypoint for hosts and home configurations. Also exposes a devshell for bootstrapping via `nix develop`
- `home-manager`: Contains all home-manager configurations
- `hosts`: NixOS Configurations, accessible via `nixos-rebuild --flake`
- `modules`: The major part of the system configurations that are not in `garuda-nix-subsystem`, exposes `dr460nixed.*` options
- `overlays`: Patches and version overrides for some packages
- `secrets`: The secrets used by `sops-nix`

## Module options

A lot of those have been moved to the [Garuda Nix Subsystem](https://gitlab.com/garuda-linux/garuda-nix-subsystem).

```
├── apps.nix
├── boot.nix
├── chaotic
├── common.nix
├── default.nix
├── desktops.nix
├── development.nix
├── docker-compose-runner.nix
├── gaming.nix
├── hardening.nix
├── locales.nix
├── misc.nix
├── monitoring.nix
├── msmtp.nix
├── networking.nix
├── nix.nix
├── oci.nix
├── servers.nix
├── shells.nix
├── syncthing.nix
├── tailscale-tls.nix
├── tailscale.nix
└── zfs.nix
```

- `dr460nixed.auto-upgrade.enable` (default false) - enables auto-upgrading the system daily by pulling the updated Nix flake from the repo
- `dr460nixed.common.enable` (default true) - common options for every system
- `dr460nixed.desktops.enable` (default false) - options for desktop systems
- `dr460nixed.development.enable` (default false) - enables a development environment
- `dr460nixed.docker-compose-runner` (default false) - runs a docker-compose.yml and supplies an additional .env file for secrets if desired
- `dr460nixed.hardening.enable` (default true) - system hardening
- `dr460nixed.lanzaboote.enable` (default false) - enables Lanzaboote instead of systemd-boot for secure-boot support
- `dr460nixed.live-cd` (default false) - live CD applications
- `dr460nixed.locales` (default true) - does all the localization setup / console font config
- `dr460nixed.nodocs` (default true) - removes unneeded documentation to save space
- `dr460nixed.rpi` (default false) - Raspberry Pi related things
- `dr460nixed.school` (default false) - things I need for school
- `dr460nixed.servers.enable` (default false) - common server options
- `dr460nixed.servers.monitoring` (default false) - enables some basic monitoring via Netdata
- `dr460nixed.shells` (default true) - enables common shell aliases & theming
- `dr460nixed.systemd-boot.enable` (default true) - a quiet systemd-boot configuration
- `dr460nixed.tailscale-autoconnect.enable` (default true) - automatically connects to the Tailnet
- `dr460nixed.tailscale-autoconnect.authFile` - points to the location where the authkey file is stored
- `dr460nixed.tailscale-autoconnect.extraUpArgs` (default none) - Extra arguments to pass to the Tailscale daemon
- `dr460nixed.tailscale-tls.enable` (default false) - enables automatic management of Tailscale certificates
- `dr460nixed.theming` (default true) - supplies fonts and general system theming via Stylix
- `dr460nixed.yubikey` (default false) - options for using the Yubikey as login

## How to use the flake?

Several preparations have to be made in order to bootstrap a working installation:

- A working `hardware-configuration.nix` needs to be generated for the current machine to replace mine
- The hosts `*.nix` configuration should be adapted to suit the hardware's needs, eg. needed kernel modules or `services.xserver.videoDrivers` should be fitting
- Since `sops-nix` is used to handle secrets, my files need to be replaced with own ones. Usage instructions can be found [here](https://github.com/Mic92/sops-nix#usage-example), basically one needs to create an age public key from the host's ed21559 SSH private key, which is then added to `.sops.yaml` to allow the host to decrypt secrets while booting up. A fitting age key should also be generated and placed in `~/.config/sops/age/keys.txt` as described in the usage instructions - this allows decrypting the secrets file to edit it. It lives in `secrets/global.yaml` and contains the secrets and can be edited with sops `secrets/global.yaml` (opens a terminal text editor).
- It might be easier to supply a static password in `users.nix` for bootstrapping, since no login will be possible if the secrets management isn't properly set up yet. I had a few issues with this in the past while setting things up, so I felt giving this advice might help. Usernames are of course also to be changed, as well as SSH public keys.

Then, the bootstrapping process can be started. All you need is `nix`. Run:

`nix develop` or `nix-shell` to create a shell containing the basic dependencies, then you can proceed by `nixos-rebuild --flake .#hostname` to build system configurations.

How to proceed from here?

- Adapt the configurations like enabled modules and home-manager configs to your needs
- Set up CI to build your custom system configurations
- Add your hosts to Tailscale, if you want to be using it. I can warmly recommend it for connecting with any kind of host!
- Build an ISO to play around with `nix build .#iso` - this has no theming, but has all the important configs for live usb purposes
- ... so much more. It never ends ❄️

## Credits

A special thanks to [PedroHLC](https://github.com/pedrohlc), who always gives great advice and who is also the reason I'm using NixOS today. Also, I studied [Mysterio77](https://github.com/Misterio77)'s and [NotAShelf](https://github.com/NotAShelf)'s Nix configurations while building this one.
