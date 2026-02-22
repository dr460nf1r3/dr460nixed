#!/usr/bin/env bash
set -eo pipefail

# Check for root rights
if [ "$EUID" -ne 0 ]; then
  echo "I can only run as root!"
  exit 3
fi

# Prepare our environment
prepare() {
  # Clone dr460nixed repo if it is not present, otherwise use current dir
  if [ ! "$(test -f flake.nix)" ]; then
    test -d /tmp/dr460nixed && sudo rm -rf /tmp/dr460nixed
    WORK_DIR=/tmp/dr460nixed
    git clone https://github.com/dr460nf1r3/dr460nixed.git "$WORK_DIR"
    cd "$WORK_DIR"
  else
    WORK_DIR=$(pwd)
  fi

  # Ensure needed "experimental" features are always enabled
  export NIX_CONFIG="experimental-features = nix-command flakes"
}

# Confirmation prompt
confirm_choices() {
  # Continue if the user confirms our choice
  read -rp "Are you sure you want to continue? $1 [y/n] " _ANSWER

  while [ -z "${KILLIT+x}" ]; do
    case "${_ANSWER}" in
    y | yes | Y | YES)
      KILLIT=1
      ;;
    n | no | N | NO)
      exit 1
      ;;
    *)
      read -rp "Invalid input. Only yes or no is valid: " _ANSWER
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

  read -rp "Enter the number of the partition layout you want to use: " _LAYOUT

  # https://stackoverflow.com/questions/3601515/how-to-check-if-a-variable-is-set-in-bash
  while [ -z "${DISKO_MODULE+x}" ]; do
    case "${_LAYOUT}" in
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
    *)
      read -rp "Invalid input. Enter the number of the partition layout you want to use: " _LAYOUT
      ;;
    esac
  done

  while [ -z "${_VALID_DISK+x}" ]; do
    read -rp 'Specify the disk you want to use, eg. "nvme0n1": ' DISK
    # Disk identifiers should at least be 3 characters long and be present in our system
    # this does not prevent all possible errors (eg. nvme0 would be valid) but good enough for now
    if [ ${#DISK} -gt 2 ] && lsblk | grep "$DISK"; then
      _VALID_DISK=1
    else
      echo "The disk you entered is invalid! Try again."
    fi
  done

  # Ask whether the hard drive should really be wiped
  echo "The disk you chose to format is $DISK."
  confirm_choices "This will start the wiping process!"

  # Create partitions and set up /mnt
  disko_runner ./nixos/modules/disko/"$DISKO_MODULE".nix /dev/"$DISK"
}

# Create initial configuration
create_config() {
  NIX_ROOT=/mnt/etc/nixos
  read -rp "Enter the hostname you want to use: " HOSTNAME
  read -rp "Enter your desired username: " USER
  [ -d /sys/firmware/efi ] && SYSTEM_TYPE=systemd-boot || SYSTEM_TYPE=grub

  # Create config without filesystems as disko provides those already
  # also apply our dr460nixed template
  nixos-generate-config --no-filesystems --root /mnt
  pushd "$NIX_ROOT" || exit 2
  nix flake init --template "$WORK_DIR"#dr460nixed

  mv ./hardware-configuration.nix ./nixos/example-host
  rm ./configuration.nix # we are using flakes, no need for that anymore
  mv ./nixos/example-host ./nixos/"$HOSTNAME"
  mv ./nixos/"$HOSTNAME"/example-host.nix ./nixos/"$HOSTNAME"/"$HOSTNAME".nix

  sed -i s/example-boot/"$SYSTEM_TYPE"/g ./nixos/"$HOSTNAME"/"$HOSTNAME".nix
  sed -i s/example-disk/"$DISK"/g .{/nixos/flake-module.nix,nixos/"$HOSTNAME"/"$HOSTNAME".nix}
  sed -i s/example-hostname/"$HOSTNAME"/g {./nixos/flake-module.nix,nixos/"$HOSTNAME"/"$HOSTNAME".nix}
  sed -i s/example-layout/"$DISKO_MODULE"/g ./nixos/flake-module.nix
  sed -i s/example-user/"$USER"/g ./nixos/modules/users.nix

  echo "Configuration successfully created.
You made the following choices:
hostname: $HOSTNAME
user: $USER"
  confirm_choices "This starts the installation process."

  popd || exit 2
}

# Install basic dr460nixed system
install_system() {
  nixos-install --flake "$NIX_ROOT#$HOSTNAME" --verbose
}

# Notices
finish() {
  echo "The installation finished successfully. You may now reboot into your new system."
  confirm_choices "This will remove the temporary directory an reboot the system."
  umount -Rf /mnt
  rm -rf "$WORK_DIR"
}

# Actually execute our functions
prepare
disko
create_config
install_system
finish
