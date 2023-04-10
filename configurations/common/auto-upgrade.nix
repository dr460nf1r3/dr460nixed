{ config, ... }:
let
  inherit (config.networking) hostName;
in
{
  system.autoUpgrade = {
    enable = true;
    dates = "hourly";
    flags = [ "--refresh" ];
    flake = "github:dr460nf1r3/device-configurations";
  };
}
