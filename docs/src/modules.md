# Module options

## Intro

A lot of those have been moved to the [Garuda Nix Subsystem](https://gitlab.com/garuda-linux/garuda-nix-subsystem). To read its documentation please follow [this link](https://nix.garudalinux.org).

```shell
├── apps
│   ├── cli.nix
│   ├── default.nix
│   ├── desktops.nix
│   ├── development.nix
│   └── gaming.nix
├── boot
│   ├── common.nix
│   ├── default.nix
│   ├── grub.nix
│   ├── lanzaboote.nix
│   └── systemd-boot.nix
├── core
│   ├── common.nix
│   ├── default.nix
│   ├── garuda-compat.nix
│   ├── home-manager.nix
│   ├── ids.nix
│   ├── locales.nix
│   ├── misc.nix
│   ├── nix.nix
│   ├── servers.nix
│   └── users.nix
├── dev-container
│   ├── default.nix
│   └── dev-container.nix
├── disko
│   ├── btrfs-subvolumes.nix
│   ├── default.nix
│   ├── luks-btrfs-subvolumes.nix
│   ├── simple-efi.nix
│   ├── zfs-encrypted.nix
│   └── zfs.nix
├── hardware
│   ├── default.nix
│   └── nvidia.nix
├── impermanence
│   ├── default.nix
│   ├── persistence.nix
│   ├── rollback.nix
│   └── tools.nix
├── networking
│   ├── core.nix
│   ├── default.nix
│   ├── tailscale-tls.nix
│   ├── tailscale.nix
│   └── wireguard.nix
├── security
│   ├── default.nix
│   └── hardening.nix
├── services
│   ├── compose-runner.nix
│   ├── default.nix
│   ├── monitoring.nix
│   ├── msmtp.nix
│   ├── oci.nix
│   └── syncthing.nix
├── shells
│   └── default.nix
└── system
    ├── default.nix
    └── zfs.nix
```

- `dr460nixed.auto-upgrade.enable` (default false) - whether this device automatically upgrades daily via pulling the updated Nix flake from the repo
- `dr460nixed.chromium.enable` (default false) - configures Chromium with a set of default extensions and settings
- `dr460nixed.common.enable` (default true) - common options for every system
- `dr460nixed.compose-runner` (default { }) - runs a docker-compose.yml and supplies an additional .env file for secrets if desired
- `dr460nixed.desktops.enable` (default false) - options for desktop systems including Plasma 6 and various apps
- `dr460nixed.development.enable` (default false) - enables a development environment with many tools
- `dr460nixed.gaming.enable` (default false) - enables gaming-related options like Steam and Gamemode
- `dr460nixed.grub.enable` (default false) - enables GRUB as bootloader
- `dr460nixed.hardening.enable` (default true) - system hardening options
- `dr460nixed.hardening.duosec` (default false) - protects logins and sudo via Duo Security
- `dr460nixed.impermanence.enable` (default false) - enables impermanence for a stateless system
- `dr460nixed.lanzaboote.enable` (default false) - enables Lanzaboote instead of systemd-boot for secure-boot support
- `dr460nixed.live-cd.enable` (default false) - live CD applications and configurations
- `dr460nixed.locales.enable` (default true) - default set of locales and console font configuration
- `dr460nixed.nodocs` (default true) - removes unneeded documentation to save space
- `dr460nixed.performance.enable` (default false) - optimizes the system for performance including CachyOS kernels
- `dr460nixed.servers.enable` (default false) - common server options
- `dr460nixed.servers.monitoring` (default false) - enables some basic monitoring via Netdata
- `dr460nixed.shells.enable` (default true) - enables common shell aliases, direnv and fish
- `dr460nixed.systemd-boot.enable` (default false) - a quiet systemd-boot configuration
- `dr460nixed.tailscale.enable` (default false) - enables the Tailscale client daemon
- `dr460nixed.tailscale-tls.enable` (default false) - enables automatic management of Tailscale certificates
- `dr460nixed.tor.enable` (default false) - configures the system to use the Tor network
- `dr460nixed.yubikey.enable` (default false) - options for using the Yubikey as login

## Individual modules

- [apps](./modules/apps.md)
- [auto-upgrade](./modules/auto-upgrade.md)
- [boot](./modules/boot.md)
- [chromium](./modules/chromium.md)
- [common](./modules/common.md)
- [compose-runner](./modules/compose-runner.md)
- [desktops](./modules/desktops.md)
- [dev-container](./modules/dev-container.md)
- [deterministic-ids](./modules/deterministic-ids.md)
- [development](./modules/development.md)
- [disko](./modules/disko.md)
- [gaming](./modules/gaming.md)
- [hardening](./modules/hardening.md)
- [impermanence](./modules/impermanence.md)
- [live-cd](./modules/live-cd.md)
- [locales](./modules/locales.md)
- [monitoring](./modules/monitoring.md)
- [msmtp](./modules/msmtp.md)
- [networking](./modules/networking.md)
- [nix](./modules/nix.md)
- [nvidia](./modules/nvidia.md)
- [oci](./modules/oci.md)
- [performance](./modules/performance.md)
- [servers](./modules/servers.md)
- [shells](./modules/shells.md)
- [syncthing](./modules/syncthing.md)
- [tailscale-tls](./modules/tailscale-tls.md)
- [tailscale](./modules/tailscale.md)
- [tor](./modules/tor.md)
- [users](./modules/users.md)
- [wireguard](./modules/wireguard.md)
- [yubikey](./modules/yubikey.md)
- [zfs](./modules/zfs.md)
