# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Dr460nixed is a NixOS flake framework providing opinionated default configurations and personal machine setups. It uses **flake-parts** for modular organization, **Garuda Linux** theming (dr460nized KDE Plasma), and follows nixpkgs-unstable.

## Common Commands

```bash
# Enter dev shell (auto-activated via direnv/.envrc)
nix develop

# Format all code (treefmt: nixfmt, shellcheck, shfmt, deadnix, statix, actionlint)
nix fmt

# Build a NixOS configuration
nix build .#nixosConfigurations.<host>.config.system.build.toplevel

# Build a specific package
nix build .#<package>  # packages: docs, installer, iso, vbox, repl

# Check flake outputs
nix flake check

# Evaluate a specific host (quick syntax check without full build)
nix eval .#nixosConfigurations.<host>.config.system.build.toplevel --no-build

# Lint (CI mode)
nix build .#linter  # runs treefmt --ci, statix check, deadnix --fail

# Deploy to remote host
nixos-anywhere  # available in devShell

# Build home-manager standalone config
nix build .#homeConfigurations.nico.activationPackage
```

## Hosts

| Host                 | Type                    | Builder              | Notes                                  |
| -------------------- | ----------------------- | -------------------- | -------------------------------------- |
| `dragons-ryzen`      | Desktop (Lenovo Slim 7) | `garudaSystem`       | Impermanence, ZFS, gaming, secure boot |
| `dragons-strix`      | Desktop (ROG laptop)    | `garudaSystem`       | Impermanence, ZFS, zenpower            |
| `cup-dragon`         | Server (Oracle Cloud)   | `garudaSystem`       | Forgejo, Matrix, Redlib, Wakapi        |
| `nixos-wsl`          | WSL                     | `garudaSystem`       | Work environment                       |
| `dev-container`      | LXC container           | `patchedNixosSystem` | Minimal dev setup                      |
| `dr460nixed-base`    | Image                   | `garudaSystem`       | VBox image via nixos-generators        |
| `dr460nixed-desktop` | Image                   | `garudaSystem`       | ISO image via nixos-generators         |

## Architecture

### Flake Structure

- `flake.nix` - Entry point: inputs, devShell, formatter, pre-commit hooks
- `nixos/flake-module.nix` - All nixosConfigurations, modules, templates, homeConfigurations
- `packages/flake-module.nix` - Package outputs (docs, installer, iso, vbox, repl)
- `lib/default.nix` - Helpers: `patchInput`, `patchedNixosSystem`, `mkColmenaHive`

### Module System

All custom options live under the `dr460nixed` namespace (e.g., `dr460nixed.desktops.enable`, `dr460nixed.gaming.enable`).

- `nixos/modules/` - NixOS modules imported as a set via `nixos/modules/default.nix`
- `nixos/modules/disko/` - Disk partitioning presets (btrfs, luks-btrfs, zfs, zfs-encrypted, simple-efi)
- `nixos/<hostname>/` - Per-host configuration + hardware-configuration
- `home-manager/` - Shared home-manager modules
- `users/nico/` - Personal user config (git, shells, email, NixOS user settings)
- `overlays/default.nix` - Package overlays (chromium, OBS, KDE applet patches)
- `template/` - Starter flake for `nix flake init`

### Default Module Stack

Every host using `garudaSystem` gets `defaultModules`: disko, lanzaboote, lix-module, sops-nix, spicetify-nix, ucodenix, plus all modules from `./modules/`. Image builds use a slimmer `imageModules` set.

### Secrets

SOPS with age encryption. Keys defined in `.sops.yaml`, secrets stored in `secrets/global.yaml`. Age key derived from host SSH ed25519 key at `/etc/ssh/ssh_host_ed25519_key`.

### Key Inputs

Garuda-nix (theming/system), Lix (alternative Nix implementation), Catppuccin (theming), nix-gaming, impermanence, nixos-hardware, nix-cachyos-kernel.

## Conventions

- **Nix formatter**: The treefmt wrapper uses `nixfmt` (not alejandra, despite alejandra being in devShell for pre-commit hooks)
- **Commit style**: Conventional commits enforced via commitizen pre-commit hook
- **Nix linting**: statix and deadnix are enforced; `statix.toml` ignores `.direnv` and disables `repeated_keys`
- **Typo checking**: `_typos.toml` allows: crypted, immortalis, odf, uage
- **CI**: Garnix builds most configurations (see `garnix.yaml` for exclusions); GitHub Actions handles ISO releases, docs deployment, and Tailscale ACL sync
- **Flake inputs**: Follow nixpkgs aggressively to minimize closure size; use `"input-patch-"` prefix convention for nixpkgs patches
