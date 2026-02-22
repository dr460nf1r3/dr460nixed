{ pkgs, ... }:
{
  # Rollback function for BTRFS rootfs and home
  # This assumes we have a LUKS volume named "crypted"
  # https://mt-caret.github.io/blog/posts/2020-06-29-optin-state.html
  boot.initrd = {
    enable = true;
    supportedFilesystems = [ "btrfs" ];
    systemd.services.restore-root = {
      description = "Rollback BTRFS rootfs";
      wantedBy = [ "initrd.target" ];
      after = [ "systemd-cryptsetup@crypted.service" ];
      before = [ "sysroot.mount" ];
      unitConfig.DefaultDependencies = "no";
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p /mnt

        # We first mount the btrfs root to /mnt
        # so we can manipulate btrfs subvolumes.
        mount -o subvol=/ /dev/mapper/crypted /mnt

        # While we're tempted to just delete /root and create
        # a new snapshot from /root-blank, /root is already
        # populated at this point with a number of subvolumes,
        # which makes `btrfs subvolume delete` fail.
        # So, we remove them first.
        btrfs subvolume list -o /mnt/root |
        cut -f9 -d' ' |
        while read subvolume; do
          echo "deleting /$subvolume subvolume..."
          btrfs subvolume delete "/mnt/$subvolume"
        done &&
        echo "deleting /root subvolume..." &&
        btrfs subvolume delete /mnt/root

        echo "restoring blank /root subvolume..."
        btrfs subvolume snapshot /mnt/root-blank /mnt/root

        # Rollback home subvolume if home-blank snapshot exists
        if [ -d /mnt/home-blank ]; then
          if [ -d /mnt/home ]; then
            echo "Rolling back /home subvolume..."
            btrfs subvolume list -o /mnt/home |
            cut -f9 -d' ' |
            while read subvolume; do
              echo "deleting /$subvolume subvolume..."
              btrfs subvolume delete "/mnt/$subvolume"
            done &&
            echo "deleting /home subvolume..." &&
            btrfs subvolume delete /mnt/home
          fi

          echo "restoring blank /home subvolume..."
          btrfs subvolume snapshot /mnt/home-blank /mnt/home
        fi

        # Create marker file to indicate successful rollback
        touch /mnt/root/.rollback-success

        # Unmount the btrfs root so systemd can continue with normal boot
        echo "Unmounting /mnt..."
        umount /mnt
      '';
    };
  };

  # Rollback verification service
  # Checks if opt-in state rollback succeeded and notifies user
  systemd.user.services.check-rollback = {
    description = "Check if opt-in state rollback succeeded";
    after = [ "graphical-session-pre.target" ];
    partOf = [ "graphical-session.target" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.writeShellScript "check-rollback" ''
        # Check if rollback marker file exists
        if [ ! -f /.rollback-success ]; then
          # Rollback failed or didn't run - notify user
          ${pkgs.libnotify}/bin/notify-send -u critical "Opt-in State" "Rollback verification failed" 
            "The filesystem rollback may not have completed successfully. Check logs with: journalctl -b"
        fi
      ''}";
    };
  };

  # Rollback results in sudo lectures after each reboot
  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';
}
