{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: {
  # Basic installation CD settings
  imports = [
    "${toString inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
  ];

  # Boot configuration
  boot = {
    # Allow cross-compilation
    binfmt.emulatedSystems = ["aarch64-linux"];

    # Let us see the boot messages
    consoleLogLevel = 3;

    # No need for containers
    enableContainers = false;

    # This is default for GNS, but doesn't work on the ISO
    initrd = {
      systemd.enable = false;
      verbose = true;
    };
  };

  # Home-manager common configurations
  home-manager.users."nixos" = import ../../home-manager/common.nix;

  # Image configuration
  isoImage = {
    # Add memtest86+ to the ISO
    contents = [
      {
        source = pkgs.memtest86plus + "/memtest.bin";
        target = "boot/memtest.bin";
      }
    ];

    # The ISO image name and edition label
    edition = "dr460nixed";
    isoBaseName = "dr460nixed";
    isoName = lib.mkForce "${config.isoImage.isoBaseName}-${config.system.nixos.label}.iso";

    # Speed up the insanely slow compression process
    squashfsCompression = "zstd -Xcompression-level 3";
  };

  # The packages that are always needed
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

  # This is meant to be for x86_64 only, need to use a different config for aarch64
  nixpkgs.hostPlatform = "x86_64-linux";

  # Some handy aliases and applications
  programs = {
    bash.shellAliases = {
      "nix" = "${pkgs.nix}/bin/nix --verbose --print-build-logs"; # https://github.com/NixOS/nix/pull/8323
    };
    fish = {
      shellAliases = {
        "nix" = "${pkgs.nix}/bin/nix --verbose --print-build-logs"; # https://github.com/NixOS/nix/pull/8323
      };
    };
    git = {
      enable = true;
      lfs.enable = true;
    };
    # The GnuPG agent
    gnupg.agent = {
      enable = true;
      pinentryFlavor = "curses";
    };
  };

  # Hardened SSH configuration
  services.openssh = {
    extraConfig = ''
      AllowTcpForwarding no
      HostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,sk-ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-512,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com
      PermitTunnel no
    '';
    settings = {
      Ciphers = [
        "aes256-gcm@openssh.com"
        "aes256-ctr,aes192-ctr"
        "aes128-ctr"
        "aes128-gcm@openssh.com"
        "chacha20-poly1305@openssh.com"
      ];
      KbdInteractiveAuthentication = false;
      KexAlgorithms = [
        "curve25519-sha256"
        "curve25519-sha256@libssh.org"
        "diffie-hellman-group16-sha512"
        "diffie-hellman-group18-sha512"
        "sntrup761x25519-sha512@openssh.com"
      ];
      Macs = [
        "hmac-sha2-512-etm@openssh.com"
        "hmac-sha2-256-etm@openssh.com"
        "umac-128-etm@openssh.com"
      ];
      X11Forwarding = false;
    };
  };

  # Client side SSH configuration
  programs.ssh = {
    ciphers = [
      "aes256-gcm@openssh.com"
      "aes256-ctr,aes192-ctr"
      "aes128-ctr"
      "aes128-gcm@openssh.com"
      "chacha20-poly1305@openssh.com"
    ];
    hostKeyAlgorithms = [
      "ssh-ed25519"
      "ssh-ed25519-cert-v01@openssh.com"
      "sk-ssh-ed25519@openssh.com"
      "sk-ssh-ed25519-cert-v01@openssh.com"
      "rsa-sha2-512"
      "rsa-sha2-512-cert-v01@openssh.com"
      "rsa-sha2-256"
      "rsa-sha2-256-cert-v01@openssh.com"
    ];
    kexAlgorithms = [
      "curve25519-sha256"
      "curve25519-sha256@libssh.org"
      "diffie-hellman-group16-sha512"
      "diffie-hellman-group18-sha512"
      "sntrup761x25519-sha512@openssh.com"
    ];
    knownHosts = {
      aur-rsa = {
        hostNames = ["aur.archlinux.org"];
        publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDKF9vAFWdgm9Bi8uc+tYRBmXASBb5cB5iZsB7LOWWFeBrLp3r14w0/9S2vozjgqY5sJLDPONWoTTaVTbhe3vwO8CBKZTEt1AcWxuXNlRnk9FliR1/eNB9uz/7y1R0+c1Md+P98AJJSJWKN12nqIDIhjl2S1vOUvm7FNY43fU2knIhEbHybhwWeg+0wxpKwcAd/JeL5i92Uv03MYftOToUijd1pqyVFdJvQFhqD4v3M157jxS5FTOBrccAEjT+zYmFyD8WvKUa9vUclRddNllmBJdy4NyLB8SvVZULUPrP3QOlmzemeKracTlVOUG1wsDbxknF1BwSCU7CmU6UFP90kpWIyz66bP0bl67QAvlIc52Yix7pKJPbw85+zykvnfl2mdROsaT8p8R9nwCdFsBc9IiD0NhPEHcyHRwB8fokXTajk2QnGhL+zP5KnkmXnyQYOCUYo3EKMXIlVOVbPDgRYYT/XqvBuzq5S9rrU70KoI/S5lDnFfx/+lPLdtcnnEPk=";
      };
      aur-ed25519 = {
        hostNames = ["aur.archlinux.org"];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEuBKrPzbawxA/k2g6NcyV5jmqwJ2s+zpgZGZ7tpLIcN";
      };
      github-rsa = {
        hostNames = ["github.com"];
        publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=";
      };
      github-ed25519 = {
        hostNames = ["github.com"];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      };
      gitlab-rsa = {
        hostNames = ["gitlab.com"];
        publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bNKTBSpIYDEGk9KxsGh3mySTRgMtXL583qmBpzeQ+jqCMRgBqB98u3z++J1sKlXHWfM9dyhSevkMwSbhoR8XIq/U0tCNyokEi/ueaBMCvbcTHhO7FcwzY92WK4Yt0aGROY5qX2UKSeOvuP4D6TPqKF1onrSzH9bx9XUf2lEdWT/ia1NEKjunUqu1xOB/StKDHMoX4/OKyIzuS0q/T1zOATthvasJFoPrAjkohTyaDUz2LN5JoH839hViyEG82yB+MjcFV5MU3N1l1QL3cVUCh93xSaua1N85qivl+siMkPGbO5xR/En4iEY6K2XPASUEMaieWVNTRCtJ4S8H+9";
      };
      gitlab-ed25519 = {
        hostNames = ["gitlab.com"];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
      };
    };
    macs = [
      "hmac-sha2-512-etm@openssh.com"
      "hmac-sha2-256-etm@openssh.com"
      "umac-128-etm@openssh.com"
    ];
  };

  # Enable all hardware drivers
  hardware.enableRedistributableFirmware = true;

  # We use iwd instead
  networking.wireless.enable = false;

  # NixOS stuff
  system.stateVersion = "23.11";
}
