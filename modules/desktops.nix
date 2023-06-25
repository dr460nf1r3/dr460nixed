{ config
, lib
, pkgs
, ...
}:
with lib;
let
  cfg = config.dr460nixed.desktops;
in
{
  options.dr460nixed.desktops = {
    enable = mkOption
      {
        default = false;
        type = types.bool;
        description = mdDoc ''
          Whether to enable basic dr460nized desktop theming.
        '';
      };
  };

  config = mkIf cfg.enable {
    # Currently needed to obtain nightly Rustdesk
    services.flatpak.enable = true;

    # Additional KDE packages not included by default
    environment.systemPackages = with pkgs; [
      jamesdsp
    ];

    # Define the default fonts Fira Sans & Jetbrains Mono Nerd Fonts
    fonts.enableDefaultFonts = false;

    # # Kernel paramters & settings
    boot.kernelParams = [
      "mitigations=off"
    ];
  };
}
