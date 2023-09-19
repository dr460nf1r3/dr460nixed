# The installer

This flake features an installer, which may be used to set up a basic dr460nixed NixOS installation. It assumes that the dr460nixed ISO has been booted.
It uses the files of the `templates` folder to run `nix init -t` from and proceeds to customize the installation with users' choices.
Multiple disk formats are available via [pre-configured disko configurations](https://github.com/dr460nf1r3/dr460nixed/tree/main/template/nixos/modules/disko).
Choices during the execution of the script currently include:

- the disk to install NixOS on
- the partition layout to use during the process
- hostname
- username

The installer may only install by wiping the destination disk.

To begin, clone the dr460nixed repository (the installer assumes its located in here, so this is mandatory) and run the installer:

```sh
git clone https://github.com/dr460nf1r3/dr460nixed && cd dr460nixed
sudo nix run .#installer
```

Provide the needed input. After completion, a dr460nixed system is ready for you to use.
You may customize it with configurations found in the main repository, since the template has been kept as generic as possible.
