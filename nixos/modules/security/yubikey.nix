{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dr460nixed.yubikey;
in
{
  options.dr460nixed.yubikey = {
    enable = lib.mkEnableOption "Yubikey support";
  };

  config = lib.mkIf cfg.enable {
    hardware.gpgSmartcards.enable = true;
    services.pcscd = {
      enable = true;
      plugins = [ pkgs.ccid ];
    };
    services.udev.packages = [ pkgs.yubikey-personalization ];

    environment.systemPackages = [ pkgs.yubioath-flutter ];

    security.pam.yubico = {
      debug = false;
      enable = true;
      mode = "challenge-response";
    };
  };
}
