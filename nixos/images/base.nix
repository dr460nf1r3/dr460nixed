{
  keys,
  pkgs,
  ...
}: {
  # This is default for GNS, but doesn't work on the ISO
  boot = {
    consoleLogLevel = 3;
    initrd = {
      systemd.enable = false;
      verbose = true;
    };
  };

  # Have a different user config for the ISO
  users.users = {
    "nico" = {
      extraGroups = ["wheel"];
      home = "/home/nico";
      isNormalUser = true;
      openssh.authorizedKeys.keyFiles = [keys.nico];
      password = "dr460nixed";
    };
    "root".password = "dr460nixed";
  };

  environment.systemPackages = with pkgs; [
    age
    bind
    btop
    cached-nix-shell
    cachix
    cloudflared
    duf
    dysk
    eza
    jq
    killall
    micro
    mosh
    nettools
    nmap
    python3
    sops
    tldr
    tmux
    traceroute
    ugrep
    wget
    whois
  ];

  # General nix settings
  nix = {
    # Don't warn about dirty flakes and accept flake configs by default
    extraOptions = ''
      http-connections = 0
      warn-dirty = false
    '';

    # Nix.conf settings
    settings = {
      # Accept flake configs by default
      accept-flake-config = true;

      # Test out ca-derivations (https://nixos.wiki/wiki/Ca-derivations)
      experimental-features = ["ca-derivations"];

      # For direnv GC roots
      keep-derivations = true;
      keep-outputs = true;

      # Continue building derivations if one fails
      keep-going = true;

      # Show more log lines for failed builds
      log-lines = 20;

      # Max number of parallel jobs
      max-jobs = "auto";

      # Enable certain system features
      system-features = ["big-parallel" "kvm"];
    };
  };

  # This is meant to be for x86_64 only, use a different config for aarch64
  nixpkgs.hostPlatform = "x86_64-linux";

  # NixOS stuff
  system.stateVersion = "23.11";
}
