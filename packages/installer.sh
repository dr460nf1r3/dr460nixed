#!/usr/bin/env bash

# Check for root rights
if [ "$EUID" -ne 0 ]; then
	echo "I can only run as root!"
	exit 1
fi

# Create working directory
prepare() {
	TMP_DIR=$(mktemp -d)
	cd "$TMP_DIR" || exit 1
	git clone https://github.com/dr460nf1r3/dr460nixed.git && cd dr460nixed || exit 1
}

# Confirmation prompt
confirm_choices() {
	echo "You made the following choices:
		disk: $DISK
		hostname: $HOSTNAME
		user: $USER"
	read -pr "Do you want to continue?" _CHOICE

	# Continue if the user confirms our choice
	echo "Do you wish to continue (destructive action ahead!) ?"
	select yn in "Yes" "No"; do
		case $yn in
		Yes)
			break
			;;
		No)
			exit
			;;
		esac
	done
}

# Create a runner for disko, directly from git
disko_runner() {
	nix run github:nix-community/disko -- --mode disko "$1" --arg disks "[ \"$2\" ]"
}

# Create partitions using disko and mount them to /mnt
disko() {
	echo "The following partition layouts are available:
            1) BTRFS with subvolumes
            2) BTRFS on LUKS with subvolumes
            3) Simple EFI
            4) ZFS (recommended)
            5) ZFS encrypted"

	read -rp "Enter the numer of the partition layout you want to use: " LAYOUT

	# https://stackoverflow.com/questions/3601515/how-to-check-if-a-variable-is-set-in-bash
	while [ -z "${DISKO_MODULE+x}" ]; do
		case "${LAYOUT}" in
		1)
			DISKO_MODULE=btrfs-subvolumes
			;;
		2)
			DISKO_MODULE=luks-btrfs-subvolumes
			;;
		3)
			DISKO_MODULE=simple-efi
			;;
		4)
			DISKO_MODULE=zfs-encrypted
			;;
		5)
			DISKO_MODULE=zfs
			;;
		*) read -rp "Invalid input. Enter the numer of the partition layout you want to use: " LAYOUT ;;
		esac
	done

	read -rp "Enter the path of the disk of the disk you want to use (eg. /dev/nvme0n1): " DISK

	# Ask whether the hard drive should really be wiped
	echo "The disk you chose to format is $DISK."
	confirm_choices

	# Create partitions and set up /mnt
	disko_runner ./nixos/modules/disko/zfs.nix "$DISK"
}

# Create initial configuration
create_config() {
	NIX_ROOT=/mnt/etc/nixos
	read -pr "Enter the hostname you want to use: " HOSTNAME
	read -pr "Enter your desired username: " USER

	# Create config without filesystems as disko provides those already
	nixos-generate-config --no-filesystems --root /mnt
	nix flake init --template github:dr460nf1r3/dr460nixed#dr460nixed "$NIX_ROOT"

	mv "$NIX_ROOT"/hosts/example-host "$NIX_ROOT"/hosts/"$HOSTNAME"
	mv "$NIX_ROOT"/hosts/"$HOSTNAME"/example-host.nix "$NIX_ROOT"/hosts/"$HOSTNAME"/"$HOSTNAME".nix

	sed -i s/example-hostname/"$HOSTNAME"/g "$NIX_ROOT"/hosts/"$HOSTNAME"/"$HOSTNAME".nix
	sed -i s/example-user/"$USER"/g "$NIX_ROOT"/nixos/modules/users.nix
	sed -i s/example-disko/"$DISK"O_MODULE/g "$NIX_ROOT"/nixos/flake-module.nix
	sed -i s/example-disk/"$DISK"/g "$NIX_ROOT"/nixos/flake-module.nix

	echo "Configuration successfully created."
}

# Install basic dr460nixed system
install_system() {
	nixos-install --flake "$NIX_ROOT#$HOSTNAME"
}

# Notices
finish() {
	echo "The installation was finished successfully. You may now reboot into your new system."
	umount -Rf /mnt
	rm -rf "$TMP_DIR"
}

# Actually execute our functions
prepare
disko
create_config
confirm_choices
install_system
finish
