{ lib, ... }: {
  # Common used configurations
  imports = [
    ./monitoring.nix
    ./networking.nix
    ./nginx.nix
  ];

  # Enable fail2ban for SSH by default
  services.fail2ban = {
    enable = true;
    ignoreIP = [
      "100.0.0.0/8"
      "127.0.0.1/8"
    ];
  };

  # The common used config is not available
  programs.fish.shellInit = lib.mkForce ''
    set fish_greeting
    fastfetch -l nixos
  '';
}
