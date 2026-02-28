{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dr460nixed.development;
in
{
  config = lib.mkIf cfg.jetbrains {
    boot.kernel.sysctl = {
      "vm.overcommit_memory" = "1";
    };

    environment.systemPackages = with pkgs; [
      android-studio
      dbeaver-bin
      jetbrains.webstorm
      jetbrains.rust-rover
    ];

    nixpkgs.config = {
      allowUnsupportedSystem = true;
      android_sdk.accept_license = true;
    };
  };
}
