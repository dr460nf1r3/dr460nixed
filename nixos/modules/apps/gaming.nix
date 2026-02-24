{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dr460nixed.gaming;

  patchDesktop =
    pkg: appName: from: to:
    lib.hiPrio (
      pkgs.runCommand "$patched-desktop-entry-for-${appName}" { } ''
        ${pkgs.coreutils}/bin/mkdir -p $out/share/applications
        ${pkgs.gnused}/bin/sed 's#${from}#${to}#g' < ${pkg}/share/applications/${appName}.desktop > $out/share/applications/${appName}.desktop
      ''
    );
  GPUOffloadApp =
    pkg: desktopName:
    lib.mkIf (config.hardware.nvidia.prime.offload.enable or false) (
      patchDesktop pkg desktopName "^Exec=" "Exec=nvidia-offload "
    );
in
{
  options.dr460nixed.gaming = with lib; {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc ''
        Whether this device is used for gaming.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # Gamemode
    programs.gamemode.enable = true;

    # Enable Steam
    programs.steam = {
      enable = true;
      extraCompatPackages = with pkgs; [ ];
    };

    environment.systemPackages = with pkgs; [
      protonplus
      lutris
      prismlauncher
      (GPUOffloadApp prismlauncher "org.prismlauncher.PrismLauncher")
      (GPUOffloadApp steam "steam")
    ];
  };
}
