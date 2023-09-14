# Module options

## Intro

A lot of those have been moved to the [Garuda Nix Subsystem](https://gitlab.com/garuda-linux/garuda-nix-subsystem). To read its documentation please follow [this link](https://nix.garudalinux.org).

```
├── apps.nix
├── boot.nix
├── chaotic
│   ├── chaotic-mirror.nix
│   ├── chaotic.nix
├── common.nix
├── default.nix
├── desktops.nix
├── development.nix
├── disko
│   ├── btrfs-subvolumes.nix
│   ├── luks-btrfs-subvolumes.nix
│   ├── simple-efi.nix
│   ├── zfs-encrypted.nix
│   └── zfs.nix
├── docker-compose-runner.nix
├── gaming.nix
├── hardening.nix
├── impermanence.nix
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
├── tailscale.nix
├── tailscale-tls.nix
├── users.nix
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

## Individual modules

- [apps](./modules/apps.md)
- [boot](./modules/boot.md)
- [common](./modules/common.md)
- [desktops](./modules/desktops.md)
- [deterministic-ids](./modules/deterministic-ids.md)
- [development](./modules/development.md)
- [docker-compose-runner](./modules/docker-compose-runner.md)
- [gaming](./modules/gaming.md)
- [hardening](./modules/hardening.md)
- [impermanence](./modules/impermanence.md)
- [locales](./modules/locales.md)
- [msmtp](./modules/msmtp.md)
- [networking](./modules/networking.md)
- [nix](./modules/nix.md)
- [oci](./modules/oci.md)
- [servers](./modules/servers.md)
- [shells](./modules/shells.md)
- [syncthing](./modules/syncthing.md)
- [tailscale-tls](./modules/tailscale-tls.md)
- [tailscale](./modules/tailscale.md)
- [users](./modules/users.md)
- [zfs](./modules/zfs.md)
