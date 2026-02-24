{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  # Use always up-to-date applications directly from git
  installer = pkgs.writeShellScriptBin "installer" "nix run ${repo}#installer";
  repl = pkgs.writeShellScriptBin "repl" "nix run ${repo}#repl";
  repo = "github:dr460nf1r3/dr460nixed";
in
{
  # Basic installation CD settings & modules
  imports = [
    "${toString inputs.nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-base.nix"
  ];

  # Boot configuration
  boot = {
    initrd = {
      # This is default for GNS, but doesn't work on the ISO
      systemd.enable = false;
      verbose = false;
    };
  };

  # Use CachyOS kernel & a few things like ZRAM
  dr460nixed.performance.enable = true;

  users.users.nixos.autoSubUidGidRange = false;

  # Basic home-manager configuration, also importing garuda-nix dotfiles
  garuda.home-manager.modules = [ ../../home-manager/common.nix ];

  # Image configuration
  image = {
    baseName = lib.mkForce "dr460nixed";
    fileName = lib.mkForce "${config.image.baseName}-${config.system.nixos.label}.iso";
  };

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

    # Speed up the insanely slow compression process
    squashfsCompression = "gzip -Xcompression-level 1";
  };

  # We want to use NetworkManager on desktops
  networking = {
    nameservers = [
      "1.1.1.1"
      "2606:4700:4700::1111"
      "1.0.0.1"
      "2606:4700:4700::1001"
    ];
    networkmanager = {
      dns = "none";
      enable = true;
    };
  };

  # The packages that are always needed
  environment.systemPackages = [
    pkgs.age
    pkgs.bind
    pkgs.btop
    pkgs.eza
    installer
    pkgs.jq
    pkgs.killall
    pkgs.micro
    pkgs.nettools
    pkgs.nmap
    pkgs.python3
    repl
    pkgs.sops
    pkgs.tldr
    pkgs.tmux
    pkgs.traceroute
    pkgs.ugrep
    pkgs.wget
    pkgs.whois
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

      # Max number of parallel jobs
      max-jobs = "auto";

      # Enable certain system features
      system-features = [
        "big-parallel"
        "kvm"
      ];
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
      shellInit = lib.mkForce ''
        set fish_greeting
        echo "Welcome!
        You may install a generic dr460nixed flake to your system by executing:
          - \"installer\".

        The flake may additionally be inspected with "nix repl" by running:
          - \"repl\""
      '';
    };
    git = {
      enable = true;
      lfs.enable = true;
    };
    # The GnuPG agent
    gnupg.agent = {
      enable = true;
      pinentryPackage = lib.mkForce pkgs.pinentry-curses;
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
        hostNames = [ "aur.archlinux.org" ];
        publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDKF9vAFWdgm9Bi8uc+tYRBmXASBb5cB5iZsB7LOWWFeBrLp3r14w0/9S2vozjgqY5sJLDPONWoTTaVTbhe3vwO8CBKZTEt1AcWxuXNlRnk9FliR1/eNB9uz/7y1R0+c1Md+P98AJJSJWKN12nqIDIhjl2S1vOUvm7FNY43fU2knIhEbHybhwWeg+0wxpKwcAd/JeL5i92Uv03MYftOToUijd1pqyVFdJvQFhqD4v3M157jxS5FTOBrccAEjT+zYmFyD8WvKUa9vUclRddNllmBJdy4NyLB8SvVZULUPrP3QOlmzemeKracTlVOUG1wsDbxknF1BwSCU7CmU6UFP90kpWIyz66bP0bl67QAvlIc52Yix7pKJPbw85+zykvnfl2mdROsaT8p8R9nwCdFsBc9IiD0NhPEHcyHRwB8fokXTajk2QnGhL+zP5KnkmXnyQYOCUYo3EKMXIlVOVbPDgRYYT/XqvBuzq5S9rrU70KoI/S5lDnFfx/+lPLdtcnnEPk=";
      };
      aur-ed25519 = {
        hostNames = [ "aur.archlinux.org" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEuBKrPzbawxA/k2g6NcyV5jmqwJ2s+zpgZGZ7tpLIcN";
      };
      github-rsa = {
        hostNames = [ "github.com" ];
        publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCj7ndNxQowgcQnjshcLrqPEiiphnt+VTTvDP6mHBL9j1aNUkY4Ue1gvwnGLVlOhGeYrnZaMgRK6+PKCUXaDbC7qtbW8gIkhL7aGCsOr/C56SJMy/BCZfxd1nWzAOxSDPgVsmerOBYfNqltV9/hWCqBywINIR+5dIg6JTJ72pcEpEjcYgXkE2YEFXV1JHnsKgbLWNlhScqb2UmyRkQyytRLtL+38TGxkxCflmO+5Z8CSSNY7GidjMIZ7Q4zMjA2n1nGrlTDkzwDCsw+wqFPGQA179cnfGWOWRVruj16z6XyvxvjJwbz0wQZ75XK5tKSb7FNyeIEs4TT4jk+S4dhPeAUC5y+bDYirYgM4GC7uEnztnZyaVWQ7B381AK4Qdrwt51ZqExKbQpTUNn+EjqoTwvqNj4kqx5QUCI0ThS/YkOxJCXmPUWZbhjpCg56i+2aB6CmK2JGhn57K5mj0MNdBXA4/WnwH6XoPWJzK5Nyu2zB3nAZp+S5hpQs+p1vN1/wsjk=";
      };
      github-ed25519 = {
        hostNames = [ "github.com" ];
        publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";
      };
      gitlab-rsa = {
        hostNames = [ "gitlab.com" ];
        publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bNKTBSpIYDEGk9KxsGh3mySTRgMtXL583qmBpzeQ+jqCMRgBqB98u3z++J1sKlXHWfM9dyhSevkMwSbhoR8XIq/U0tCNyokEi/ueaBMCvbcTHhO7FcwzY92WK4Yt0aGROY5qX2UKSeOvuP4D6TPqKF1onrSzH9bx9XUf2lEdWT/ia1NEKjunUqu1xOB/StKDHMoX4/OKyIzuS0q/T1zOATthvasJFoPrAjkohTyaDUz2LN5JoH839hViyEG82yB+MjcFV5MU3N1l1QL3cVUCh93xSaua1N85qivl+siMkPGbO5xR/En4iEY6K2XPASUEMaieWVNTRCtJ4S8H+9";
      };
      gitlab-ed25519 = {
        hostNames = [ "gitlab.com" ];
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
  networking.wireless.enable = lib.mkForce false;

  # NixOS stuff
  system.stateVersion = "26.05";
}
