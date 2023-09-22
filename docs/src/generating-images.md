# Generating images

Images of this flake may easily be built by using [nixos-generators](https://github.com/nix-community/nixos-generators).
In our case, we use it as [NixOS module](https://github.com/nix-community/nixos-generators?tab=readme-ov-file#using-as-a-nixos-module) to be able to build the system via `garuda-nix.lib.garudaSystem`.
This is important, as this function exposes all the `garuda-nix-subsystem` modules for us to consume.

## How to get going?

Let's build a regular dr460nixed ISO!

```sh
nix build .#nixosConfigurations.dr460nixed-desktop.config.formats.install-iso
```

You may also just run `nix run .#iso`, which builds an image using the `install-iso` format.

This is pretty much everything needed! The result will be available at `./result`, which links to the corresponding path in `/nix/store`.

Likewise, all other configurations may be built by simply exchanging `installer-iso` with the desired format.
Depending on what kind of image is being built it is needed to use the `dr460nixed-base` system to build the image.

```sh
nix build .#nixosConfigurations.dr460nixed-base.config.formats.sdcard
```

For a list of other supported formats please have a look [here](https://github.com/nix-community/nixos-generators?tab=readme-ov-file#supported-formats).

## Cross-compiling

It is also possible to build images for other architectures, eg. the Raspberry Pi.
To allow cross-compilation, please have a look at how to set up the required options [here](https://github.com/nix-community/nixos-generators?tab=readme-ov-file#cross-compiling).

TLDR: add the following to your configuration and apply it:

```nix
{
  # Enable binfmt emulation of aarch64-linux.
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
```

## Provided images

[![Build images](https://github.com/dr460nf1r3/dr460nixed/actions/workflows/build_images.yml/badge.svg)](https://github.com/dr460nf1r3/dr460nixed/actions/workflows/build_images.yml)
Refreshed ISO files are automatically built with every new commit. Click the badge to have a look at the latest workflow runs.
