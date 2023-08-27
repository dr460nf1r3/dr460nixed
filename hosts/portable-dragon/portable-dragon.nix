{ lib, ... }: {
  imports = [
    ../../configurations/common.nix
  ];

  # Speed up spashfs process & set names
  isoImage = {
    isoName = lib.mkForce "portable-dragon.iso";
    squashfsCompression = "zstd -Xcompression-level 6";
    volumeID = lib.mkForce "portable-dragon";
  };

  # Enable a few selected custom settings
  dr460nixed = {
    chromium = true;
    desktops.enable = true;
  };

  # Garuda Nix subsystem options
  garuda.dr460nized.enable = true;

  # This seems to be needed for not getting "root account locked"
  users.mutableUsers = lib.mkForce true;

  # Increase timeout
  boot.loader.timeout = lib.mkForce 10;

  # Needed for https://github.com/NixOS/nixpkgs/issues/58959
  boot.supportedFilesystems = lib.mkForce [ "btrfs" "reiserfs" "vfat" "f2fs" "xfs" "ntfs" "cifs" "zfs" ];

  # This is a live USB
  networking.hostName = "portable-dragon";

  # For ZFS to be happy
  networking.hostId = "00000000";

  # Otherwise set to "no" by my config
  services.openssh.settings.PermitRootLogin = lib.mkForce "yes";

  # Allow the usage of Calamares
  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (subject.isInGroup("wheel")) {
        return polkit.Result.YES;
      }q
    });
  '';

  # Enable the X server with all the drivers
  services.xserver = {
    displayManager = {
      autoLogin = {
        enable = true;
        user = "nico";
      };
    };
    videoDrivers = [ "nvidia" "amdgpu" "vesa" "modesetting" ];
  };

  # Override default iso configuration
  networking.wireless.enable = lib.mkForce false;

  # Enable virtualization support
  services.qemuGuest.enable = true;
  services.spice-vdagentd.enable = true;

  # NixOS stuff
  system.stateVersion = "23.11";
}
