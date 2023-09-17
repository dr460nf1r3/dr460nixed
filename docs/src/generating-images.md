# Generating images

Images of this flake may easily be built by using [nixos-generators](https://github.com/nix-community/nixos-generators).
In our case, we use it as [NixOS module](https://github.com/nix-community/nixos-generators?tab=readme-ov-file#using-as-a-nixos-module) in order to be able to build the system via `garuda-nix.lib.garudaSystem`.
This is important, as this function exposes all the `garuda-nix-subsystem` modules for us to consume.

## How to get going?

Lets build a regular dr460nixed ISO!

```sh
nix build .#nixosConfigurations.dr460nixed-desktop.config.formats.install-iso
```

This is pretty much everything needed! The result will be available at `./result/iso/*.iso`.

Likewise, all other configurations may be built by simply exchanging `iso` with the desired format.
Depending on what kind of image is being built it is needed to use the `dr460nixed-base` system to built the image.

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
