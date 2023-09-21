# The installer

This flake features an installer, which may be used to set up a basic dr460nixed NixOS installation. Both the dr460nixed ISO and regular NixOS live CDs are supported.
The installer uses the files of the `templates` folder to run `nix init -t` from and proceeds to customize the installation with users' choices.
Multiple disk formats are available via [pre-configured disko configurations](https://github.com/dr460nf1r3/dr460nixed/tree/main/template/nixos/modules/disko).
Choices during the execution of the script currently include:

- the disk to install NixOS on
- the partition layout to use during the process
- hostname
- username

The installer may only install by wiping the destination disk, custom partition layouts are currently unsupported.
This guide currently requires an EFI-booted system as `systemd-boot` is used as bootloader. [Nix command](https://nixos.wiki/wiki/Nix_command) and [flakes](https://nixos.wiki/wiki/flakes) need to be enabled.

To begin, simply run the installer:

```sh
sudo installer # use this if booted into a dr460nixed ISO
sudo nix run github:dr460nf1r3/dr460nixed#installer # regular NixOS systems
```

Provide the needed input. After completion, a dr460nixed system is ready for you to use.
You may customize it with configurations found in the main repository, since the template has been kept as generic as possible.

Users are expected to continue building their own flake after the installation finished. In order to do so, the dr460nixed repository has many examplery configurations available.
They may be inspected by browsing the "modules" section of this documentation.
