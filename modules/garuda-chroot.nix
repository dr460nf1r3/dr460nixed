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
  };

  config = mkIf cfg.enable {
    fileSystems."/mnt/garuda" =
      {
        device = "/dev/disk/by-label/OS";
        fsType = "btrfs";
        options = [ "subvol=@" "compress=zstd" "noatime" ];
      };
    fileSystems."/mnt/garuda/home" =
      {
        device = "/dev/disk/by-label/OS";
        fsType = "btrfs";
        options = [ "subvol=@home" "compress=zstd" "noatime" ];
      };
    fileSystems."/mnt/garuda/root" =
      {
        device = "/dev/disk/by-label/OS";
        fsType = "btrfs";
        options = [ "subvol=@root" "compress=zstd" "noatime" ];
      };
    fileSystems."/mnt/garuda/srv" =
      {
        device = "/dev/disk/by-label/OS";
        fsType = "btrfs";
        options = [ "subvol=@srv" "compress=zstd" "noatime" ];
      };
    fileSystems."/mnt/garuda/var/cache" =
      {
        device = "/dev/disk/by-label/OS";
        fsType = "btrfs";
        options = [ "subvol=@cache" "compress=zstd" "noatime" ];
      };
    fileSystems."/mnt/garuda/var/log" =
      {
        device = "/dev/disk/by-label/OS";
        fsType = "btrfs";
        options = [ "subvol=@log" "compress=zstd" "noatime" ];
      };
    fileSystems."/mnt/garuda/var/tmp" =
      {
        device = "/dev/disk/by-label/OS";
        fsType = "btrfs";
        options = [ "subvol=@tmp" "compress=zstd" "noatime" ];
      };
    fileSystems."/mnt/garuda/nix" =
      {
        device = "/dev/disk/by-label/OS";
        fsType = "btrfs";
        options = [ "subvol=@nix" "compress=zstd" "noatime" ];
      };
    fileSystems."/mnt/garuda/boot/efi" =
      {
        device = "/dev/disk/by-uuid/5772-1FF9";
        fsType = "vfat";
        options = [ "noatime" ];
      };
  };
}
