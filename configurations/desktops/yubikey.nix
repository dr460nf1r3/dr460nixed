{
  pkgs,
  config,
  ...
}: {
  # Enable the smartcard daemon
  hardware.gpgSmartcards.enable = true;
  services.pcscd.enable = true;
  services.udev.packages = [pkgs.yubikey-personalization];

  # Configure as challenge-response for instant login,
  # can't provide the secrets as the challenge gets updated
  security.pam.yubico = {
    debug = false;
    enable = true;
    mode = "challenge-response";
  };

  # Yubikey personalization & Yubico Authenticator
  environment.systemPackages = with pkgs; [
    yubikey-personalization
    yubioath-flutter
  ];

  # Enable the smartcard daemon for commit signing
  home-manager.users."nico".services.gpg-agent = {
    enableExtraSocket = true;
    enableScDaemon = true;
  };
}
