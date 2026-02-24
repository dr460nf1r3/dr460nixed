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
    # Enable the smartcard daemon
    hardware.gpgSmartcards.enable = true;
    services.pcscd = {
      enable = true;
      plugins = [ pkgs.ccid ];
    };
    services.udev.packages = [ pkgs.yubikey-personalization ];

    # Configure as challenge-response for instant login,
    # can't provide the secrets as the challenge gets updated
    security.pam.yubico = {
      debug = false;
      enable = true;
      mode = "challenge-response";
    };
  };
}
