{ config
, pkgs
, ...
}: {
  # List all of the packages
  environment.systemPackages = with pkgs; [
    alejandra
    androidStudioPackages.canary
    ansible
    bind.dnsutils
    gitkraken
    heroku
    hugo
    jetbrains.pycharm-professional
    keybase-gui
    nixos-generators
    nur.repos.yes.archlinux.asp
    nur.repos.yes.archlinux.devtools
    nur.repos.yes.archlinux.paru
    shellcheck
    shfmt
    speedcrunch
    teamviewer
    termius
    ventoy-bin-full
    virt-manager
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions;
        [
          bbenoist.nix
          eamodio.gitlens
          esbenp.prettier-vscode
          foxundermoon.shell-format
          github.codespaces
          github.copilot
          #jdinhlife.gruvbox
          kamadorueda.alejandra
          ms-azuretools.vscode-docker
          ms-python.python
          ms-python.vscode-pylance
          ms-vscode.hexeditor
          ms-vsliveshare.vsliveshare
          njpwerner.autodocstring
          pkief.material-icon-theme
          redhat.vscode-xml
          redhat.vscode-yaml
          timonwong.shellcheck
          tyriar.sort-lines
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "sweet-vscode";
            publisher = "eliverlara";
            version = "1.1.1";
            sha256 = "sha256-kJgqMEJHyYF3GDxe1rnpTEmbfJE01tyyOFjRUp4SOds=";
          }
        ];
    })
    xdg-utils
    yarn
  ];

  # Enable Keybase & its filesystem
  # services.kbfs.enable = true;
  # services.keybase.enable = true;

  # Import secrets needed for development
  sops.secrets."api_keys/sops" = {
    mode = "0600";
    owner = config.users.users.nico.name;
    path = "/home/nico/.config/sops/age/keys.txt";
  };
  sops.secrets."api_keys/heroku" = {
    mode = "0600";
    owner = config.users.users.nico.name;
    path = "/home/nico/.netrc";
  };
  sops.secrets."api_keys/cloudflared" = {
    mode = "0600";
    owner = config.users.users.nico.name;
    path = "/home/nico/.cloudflared/cert.pem";
  };

  # Conflicts with virtualisation.containers if enabled
  boot.enableContainers = false;

  # Wireshark
  programs.wireshark.enable = true;

  # Libvirt & Podman with docker alias
  virtualisation = {
    libvirtd = {
      enable = true;
      parallelShutdown = 2;
    };
    podman = {
      autoPrune = {
        enable = true;
        flags = [ "--all" ];
      };
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
    };
  };

  # Needed for makepkg to work
  environment.etc = {
    "makepkg.conf" = {
      mode = "0644";
      source = builtins.fetchurl {
        url = "https://gitlab.com/garuda-linux/tools/garuda-tools/-/raw/master/data/makepkg.conf";
        sha256 = "1irycfzkx6mfyrq8av3jmxsm139xgw93yn57vz8fl0lz3lsbjvnl";
      };
    };
  };

  # This is a containerized version of Garuda Linux from nspawn.org
  systemd.nspawn."garuda-dev" = {
    enable = true;
    execConfig = {
      Boot = "yes";
      ResolvConf = "off";
      PrivateUsers = 0;
      Capability = "all";
    };
    filesConfig = {
      Bind = [ "/home/nico:/home/nico" ];
    };
  };
  systemd.services."systemd-nspawn@garuda-dev" = {
    overrideStrategy = "asDropin";
    wantedBy = [ "machines.target" ];
    environment = { SYSTEMD_NSPAWN_UNIFIED_HIERARCHY = "1"; };
    enable = true;
  };

  # Allow to cross-compile to aarch64
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}
