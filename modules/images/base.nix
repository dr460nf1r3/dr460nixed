{ config
, keys
, pkgs
, ...
}:
let
  ifTheyExist = groups: builtins.filter (group: builtins.hasAttr group config.users.groups) groups;
in
{
  # My user
  users.users = {
    "nico" = {
      extraGroups = [
        "audio"
        "video"
        "wheel"
      ] ++ ifTheyExist [
        "adbusers"
        "disk"
        "network"
        "networkmanager"
        "systemd-journal"
      ];
      home = "/home/nico";
      isNormalUser = true;
      openssh.authorizedKeys.keyFiles = [ keys.nico ];
      uid = 1000;
    };
    "root".openssh.authorizedKeys.keyFiles = [ keys.nico ];
  };

  services.openssh.enable = true;

  networking.nameservers = [ "1.1.1.1" "1.0.0.1" ];

  security.sudo = {
    execWheelOnly = true;
    package = pkgs.sudo.override { withInsults = true; };
  };

  programs = {
    git = {
      enable = true;
      lfs.enable = true;
    };
    gnupg.agent = {
      enable = true;
      pinentryFlavor = "curses";
    };
  };

  nixpkgs.config.allowUnfree = true;
  nix = {
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
    package = pkgs.nixFlakes;
  };

  documentation = {
    dev.enable = false;
    doc.enable = false;
    enable = true;
    info.enable = false;
    man.enable = false;
    nixos.enable = false;
  };

  programs.command-not-found.enable = false;
  programs.nix-index-database.comma.enable = true;

  # These are the CLI packages I always need
  environment.systemPackages = with pkgs; [
    age
    ansible
    bind
    btop
    btrfs-progs
    cachix
    chntpw
    cloudflared
    cryptsetup
    dosfstools
    duf
    e2fsprogs
    efibootmgr
    ffmpegthumbnailer
    flashrom
    freerdp
    gnutar
    home-manager
    hwinfo
    inxi
    jq
    killall
    libsecret
    micro
    mosh
    nettools
    nixos-generators
    nixpkgs-fmt
    nmap
    ntfs3g
    nvme-cli
    p7zip
    pciutils
    perl
    python3
    qemu-utils
    rsync
    sops
    tcpdump
    testdisk
    tldr
    tmux
    traceroute
    ugrep
    usbutils
    util-linux
    wget
    whois
    wipe
    xdg-utils
    xfsprogs
    yarn
  ];

  # NixOS stuff
  system.stateVersion = "23.11";
}
      