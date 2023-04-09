{ ... }: {
  # Common used configurations
  imports = [
    ./monitoring.nix
    ./motd.nix
    ./networking.nix
    ./nginx.nix
  ];

  # Enable fail2ban for SSH by default
  services.fail2ban = {
    enable = true;
    ignoreIP = [
      "10.241.1.0/24"
      "127.0.0.1/8"
    ];
  };
}
