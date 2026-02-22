{ pkgs, ... }:
{
  # Script to find new files since blank snapshot (for Durable Erasure setup)
  # Available as `fs-diff` command system-wide
  # Shows differences for both /root and /home subvolumes
  # Usage: fs-diff
  environment.systemPackages = with pkgs; [
    tree
    (writeShellScriptBin "fs-diff" ''
      #!/usr/bin/env bash
      # fs-diff - Find files that have changed since blank snapshots
      # Automatically handles mounting and setup for both root and home
      set -euo pipefail

      MOUNT_POINT="/mnt"
      CRYPT_DEVICE="/dev/mapper/crypted"
      TMPDIR=$(mktemp -d)
      trap "rm -rf $TMPDIR" EXIT

      # Check if already mounted
      if ! mountpoint -q "$MOUNT_POINT"; then
        echo "Mounting btrfs root at $MOUNT_POINT..."
        mkdir -p "$MOUNT_POINT"
        sudo mount -o subvol=/ "$CRYPT_DEVICE" "$MOUNT_POINT" || {
          echo "Error: Failed to mount $CRYPT_DEVICE"
          exit 1
        }
      else
        echo "$MOUNT_POINT is already mounted"
      fi

      echo ""
      echo "======================================="
      echo "ROOT SUBVOLUME DIFFERENCES"
      echo "======================================="
      echo ""

      # Check if root-blank snapshot exists
      if [ ! -d "$MOUNT_POINT/root-blank" ]; then
        echo "Error: $MOUNT_POINT/root-blank snapshot does not exist"
        echo "You may need to create a blank snapshot first"
      else
        # Check if root subvolume exists
        if [ ! -d "$MOUNT_POINT/root" ]; then
          echo "Error: $MOUNT_POINT/root subvolume does not exist"
        else
          echo "Finding changed files in /root since blank snapshot..."
          echo ""

          OLD_TRANSID=$(sudo btrfs subvolume find-new "$MOUNT_POINT/root-blank" 9999999 | sed 's/transid marker was //')
          TMPDIR_ROOT="$TMPDIR/root"
          mkdir -p "$TMPDIR_ROOT"

          sudo btrfs subvolume find-new "$MOUNT_POINT/root" "$OLD_TRANSID" |
          sed '$d' |
          cut -f17- -d' ' |
          sort |
          uniq |
          while read path; do
            path="/$path"
            if [ -L "$MOUNT_POINT/root$path" ]; then
              : # The path is a symbolic link
            elif [ -d "$MOUNT_POINT/root$path" ]; then
              : # The path is a directory, ignore
            elif [[ "$path" == /tmp* ]]; then
              : # Exclude /tmp files
            else
              # Create the directory structure in temp dir for tree display
              mkdir -p "$(dirname "$TMPDIR_ROOT$path")"
              touch "$TMPDIR_ROOT$path"
            fi
          done

          if [ -n "$(find "$TMPDIR_ROOT" -type f 2>/dev/null)" ]; then
            echo "Changed files in /root (tree view):"
            echo ""
            tree -a "$TMPDIR_ROOT" -L 10 --charset ascii 2>/dev/null || find "$TMPDIR_ROOT" -type f | sed "s|$TMPDIR_ROOT||" | sort
          else
            echo "No changed files in /root (excluding /tmp)"
          fi
        fi
      fi

      echo ""
      echo "======================================="
      echo "HOME SUBVOLUME DIFFERENCES"
      echo "======================================="
      echo ""

      # Check if home-blank snapshot exists
      if [ ! -d "$MOUNT_POINT/home-blank" ]; then
        echo "Info: $MOUNT_POINT/home-blank snapshot does not exist"
        echo "Home subvolume will NOT be rolled back on reboot"
      else
        # Check if home subvolume exists
        if [ ! -d "$MOUNT_POINT/home" ]; then
          echo "Error: $MOUNT_POINT/home subvolume does not exist"
        else
          echo "Finding changed files in /home since blank snapshot..."
          echo ""

          OLD_TRANSID=$(sudo btrfs subvolume find-new "$MOUNT_POINT/home-blank" 9999999 | sed 's/transid marker was //')
          TMPDIR_HOME="$TMPDIR/home"
          mkdir -p "$TMPDIR_HOME"

          sudo btrfs subvolume find-new "$MOUNT_POINT/home" "$OLD_TRANSID" |
          sed '$d' |
          cut -f17- -d' ' |
          sort |
          uniq |
          while read path; do
            path="/$path"
            if [ -L "$MOUNT_POINT/home$path" ]; then
              : # The path is a symbolic link
            elif [ -d "$MOUNT_POINT/home$path" ]; then
              : # The path is a directory, ignore
            elif [[ "$path" == /tmp* ]]; then
              : # Exclude /tmp files
            else
              # Create the directory structure in temp dir for tree display
              mkdir -p "$(dirname "$TMPDIR_HOME$path")"
              touch "$TMPDIR_HOME$path"
            fi
          done

          if [ -n "$(find "$TMPDIR_HOME" -type f 2>/dev/null)" ]; then
            echo "Changed files in /home (tree view):"
            echo ""
            tree -a "$TMPDIR_HOME" -L 10 --charset ascii 2>/dev/null || find "$TMPDIR_HOME" -type f | sed "s|$TMPDIR_HOME||" | sort
          else
            echo "No persistent files found to be changed in /home (excluding /tmp)"
          fi
        fi
      fi

      echo ""
      echo "======================================="
      echo "Unmounting $MOUNT_POINT..."
      sudo umount "$MOUNT_POINT"
      echo "Done."
    '')
  ];
}
