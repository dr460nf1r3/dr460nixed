{
  lib,
  pkgs,
  ...
}:
{
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

  users.users.nico = {
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
}
