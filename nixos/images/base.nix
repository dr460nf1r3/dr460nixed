{pkgs, ...}: let
  de = "de_DE.UTF-8";
  defaultLocale = "en_GB.UTF-8";
  terminus-variant = "120n";
in {
  # Cloudflare DNS
  networking.nameservers = ["1.1.1.1" "1.0.0.1"];

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable wireless database
  hardware.wirelessRegulatoryDatabase = true;

  # Flakes only NixOS!
  nix = {
    settings.experimental-features = ["nix-command" "flakes"];
    package = pkgs.nixFlakes;
  };

  # No documentation needed
  documentation = {
    dev.enable = false;
    doc.enable = false;
    enable = true;
    info.enable = false;
    man.enable = false;
    nixos.enable = false;
  };

  # Timezone
  time = {
    hardwareClockInLocalTime = true;
    timeZone = "Europe/Berlin";
  };

  # Common locale settings
  i18n = {
    inherit defaultLocale;
    extraLocaleSettings = {
      LANG = defaultLocale;
      LC_COLLATE = defaultLocale;
      LC_CTYPE = defaultLocale;
      LC_MESSAGES = defaultLocale;
      LC_ADDRESS = de;
      LC_IDENTIFICATION = de;
      LC_MEASUREMENT = de;
      LC_MONETARY = de;
      LC_NAME = de;
      LC_NUMERIC = de;
      LC_PAPER = de;
      LC_TELEPHONE = de;
      LC_TIME = de;
    };
    supportedLocales = [
      "de_DE.UTF-8/UTF-8"
      "en_GB.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
  };

  # Console font
  console = {
    font = "${pkgs.terminus_font}/share/consolefonts/ter-${terminus-variant}.psf.gz";
    keyMap = "de";
  };

  # OpenSSH proves useful at all times
  services.openssh.enable = true;

  # These are the cli packages I always need
  environment.systemPackages = with pkgs; [
    age
    ansible
    bat
    bind
    btop
    btrfs-progs
    cachix
    chntpw
    cloudflared
    cryptsetup
    curl
    dosfstools
    duf
    e2fsprogs
    efibootmgr
    fastfetch
    ffmpegthumbnailer
    fishPlugins.autopair
    fishPlugins.puffer
    flashrom
    freerdp
    git
    gnutar
    home-manager
    htop
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
    screen
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

  # Use micro as editor
  environment.sessionVariables = {
    EDITOR = "${pkgs.micro}/bin/micro";
    VISUAL = "${pkgs.micro}/bin/micro";
  };

  # Programs & global configs
  programs = {
    bash.shellAliases = {
      # General useful things & theming
      "bat" = "bat --style header --style snip --style changes";
      "cat" = "bat --style header --style snip --style changes";
      "cls" = "clear";
      "dd" = "dd progress=status";
      "dir" = "dir --color=auto";
      "egrep" = "egrep --color=auto";
      "fastfetch" = "fastfetch -l nixos";
      "fgrep" = "fgrep --color=auto";
      "gcommit" = "git commit -m";
      "gitlog" = "git log --oneline --graph --decorate --all";
      "glcone" = "git clone";
      "gpr" = "git pull --rebase";
      "gpull" = "git pull";
      "gpush" = "git push";
      "ip" = "ip --color=auto";
      "jctl" = "journalctl -p 3 -xb";
      "ls" = "eza -al --color=always --group-directories-first --icons";
      "micro" = "micro -colorscheme geany -autosu true -mkparents true";
      "psmem" = "ps auxf | sort -nr -k 4";
      "psmem10" = "ps auxf | sort -nr -k 4 | head -1";
      "su" = "sudo su -";
      "tarnow" = "tar acf ";
      "untar" = "tar zxvf ";
      "vdir" = "vdir --color=auto";
      "wget" = "wget -c";
    };
    command-not-found.enable = false;
    fish = {
      enable = true;
      vendor = {
        completions.enable = true;
        config.enable = true;
      };
      shellAbbrs = {
        "cls" = "clear";
        "gcommit" = "git commit -m";
        "glcone" = "git clone";
        "gpr" = "git pull --rebase";
        "gpull" = "git pull";
        "gpush" = "git push";
        "reb" = " sudo nixos-rebuild switch -L";
        "roll" = "sudo nixos-rebuild switch --rollback";
        "run" = "nix run nixpkgs#";
        "su" = "sudo su -";
        "tarnow" = "tar acf ";
        "test" = "sudo nixos-rebuild switch --test";
        "untar" = "tar zxvf ";
        "use" = "nix shell nixpkgs#";
      };
      shellAliases = {
        "bat" = "bat --style header --style snip --style changes";
        "cat" = "bat --style header --style snip --style changes";
        "dd" = "dd progress=status";
        "dir" = "dir --color=auto";
        "egrep" = "egrep --color=auto";
        "fastfetch" = "fastfetch -l nixos";
        "fgrep" = "fgrep --color=auto";
        "gitlog" = "git log --oneline --graph --decorate --all";
        "ip" = "ip --color=auto";
        "jctl" = "journalctl -p 3 -xb";
        "ls" = "eza -al --color=always --group-directories-first --icons";
        "micro" = "micro -colorscheme geany -autosu true -mkparents true";
        "psmem" = "ps auxf | sort -nr -k 4";
        "psmem10" = "ps auxf | sort -nr -k 4 | head -1";
        "vdir" = "vdir --color=auto";
        "wget" = "wget -c";
      };
      shellInit = ''
        set fish_greeting
        ${pkgs.fastfetch}/bin/fastfetch -L nixos --load-config paleofetch
      '';
    };
    git = {
      enable = true;
      lfs.enable = true;
    };
    gnupg.agent = {
      enable = true;
      pinentryFlavor = "curses";
    };
    nix-index-database.comma.enable = true;
  };

  # NixOS stuff
  system.stateVersion = "23.11";
}
