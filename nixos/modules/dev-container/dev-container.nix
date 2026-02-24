{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dr460nixed.dev-container;
in
{
  options.dr460nixed.dev-container = {
    enable = lib.mkEnableOption "development container configuration";
    user = lib.mkOption {
      type = lib.types.str;
      default = "nixos";
      description = lib.mdDoc "The user to create in the dev container.";
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      chromium
      jetbrains.webstorm
      nodejs_latest
    ];

    services = {
      desktopManager.plasma6.enable = true;
      displayManager.sddm.enable = true;
      xserver.enable = true;
    };

    nixpkgs.config.allowUnfree = true;

    users.users.${cfg.user} = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      password = "password";
    };

    services.xrdp.enable = true;
    services.xrdp.defaultWindowManager = "startplasma-x11";
    services.xrdp.openFirewall = true;
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (
          subject.isInGroup("users")
            && (
              action.id == "org.freedesktop.login1.reboot" ||
              action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
              action.id == "org.freedesktop.login1.power-off" ||
              action.id == "org.freedesktop.login1.power-off-multiple-sessions"
            )
          )
        {
          return polkit.Result.YES;
        }
      });
    '';

    programs.ssh.setXAuthLocation = lib.mkForce true;

    system.stateVersion = "26.05";
  };
}
