{ config
, lib
, ...
}:
with lib;
let
  cfg = config.dr460nixed.garuda-chroot;
in
{
  options.dr460nixed.garuda-chroot = {
    enable = mkOption
      {
        default = true;
        type = types.bool;
        description = mdDoc ''
          Enables mounting of the Garuda Linux root partition.
        '';
      };
    root = mkOption
      {
        default = "/mnt/garuda";
        type = types.str;
        description = mdDoc ''
          Specifies where the Garuda Linux root partition should be mounted
        '';
      };
  };

  config = mkIf cfg.enable {
    fileSystems."${cfg.root}" =
      {
        device = "/dev/disk/by-label/OS";
        fsType = "btrfs";
        options = [ "subvol=@" "compress=zstd" "noatime" ];
      };
    fileSystems."${cfg.root}/home" =
      {
        device = "/dev/disk/by-label/OS";
        fsType = "btrfs";
        options = [ "subvol=@home" "compress=zstd" "noatime" ];
      };
    fileSystems."${cfg.root}/root" =
      {
        device = "/dev/disk/by-label/OS";
        fsType = "btrfs";
        options = [ "subvol=@root" "compress=zstd" "noatime" ];
      };
    fileSystems."${cfg.root}/srv" =
      {
        device = "/dev/disk/by-label/OS";
        fsType = "btrfs";
        options = [ "subvol=@srv" "compress=zstd" "noatime" ];
      };
    fileSystems."${cfg.root}/var/cache" =
      {
        device = "/dev/disk/by-label/OS";
        fsType = "btrfs";
        options = [ "subvol=@cache" "compress=zstd" "noatime" ];
      };
    fileSystems."${cfg.root}/var/log" =
      {
        device = "/dev/disk/by-label/OS";
        fsType = "btrfs";
        options = [ "subvol=@log" "compress=zstd" "noatime" ];
      };
    fileSystems."${cfg.root}/var/tmp" =
      {
        device = "/dev/disk/by-label/OS";
        fsType = "btrfs";
        options = [ "subvol=@tmp" "compress=zstd" "noatime" ];
      };
    fileSystems."${cfg.root}/boot/efi" =
      {
        device = "/dev/disk/by-uuid/5772-1FF9";
        fsType = "vfat";
        options = [ "noatime" ];
      };

    systemd.nspawn."garuda" = {
      enable = true;
      execConfig = {
        Boot = "yes";
        Capability = "all";
        PrivateUsers = 0;
      };
    };
  };
}
