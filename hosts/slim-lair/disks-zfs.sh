#!/usr/bin/env sh
set -o errexit

# Create EFI
mkfs.vfat -F32 /dev/nvme0n1p1

# Create pool
zpool create -f zroot /dev/nvme0n1p2
zpool set autotrim=on zroot
zfs set compression=on zroot
zfs set mountpoint=none zroot
zfs create -o refreservation=10G -o mountpoint=none zroot/reserved

# System volumes.
zfs create -o mountpoint=none zroot/data
zfs create -o mountpoint=none zroot/ROOT
zfs create -o mountpoint=legacy zroot/ROOT/empty
zfs create -o mountpoint=legacy zroot/ROOT/nix
zfs create -o mountpoint=legacy zroot/ROOT/residues
zfs create -o mountpoint=legacy zroot/data/persistent
zfs snapshot zroot/ROOT/empty@start

# Different recordsize
zfs create -o mountpoint=none -o recordsize=1M zroot/games
zfs create -o mountpoint=legacy zroot/games/home

# Encrypted volumes
zfs create -o encryption=on -o keyformat=passphrase \
	-o mountpoint=/home/nico/.encrypted zroot/data/encrypted

# Mount & Permissions
mount -t zfs zroot/ROOT/empty /mnt
mkdir -p /mnt/nix /mnt/home/nico/Games \
	/mnt/var/persistent /mnt/var/residues /mnt/boot
mount -t zfs zroot/ROOT/nix /mnt/nix
mount -t zfs zroot/games/home /mnt/home/nico/Games
chown -R 1000:100 /mnt/home/nico
chmod 0700 /mnt/home/nico
mount -t zfs zroot/data/persistent /mnt/var/persistent
mount -t zfs zroot/ROOT/residues /mnt/var/residues
mount /dev/nvme0n1p1 /mnt/boot

# Not needed
zfs set atime=off zroot/ROOT/nix

# Podman
zfs create -o mountpoint=none -o canmount=on zroot/containers

echo "Finished."