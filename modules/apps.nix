{ config
, lib
, pkgs
, ...
}:
with lib;
let
  cfg = config.dr460nixed;
in
{
  # These are the packages I always need
  environment.systemPackages = with pkgs;
    let
      required-packages = [
        age
        bind
        bitwarden-cli
        btop
        cached-nix-shell
        cachix
        cloudflared
        colmena
        curl
        direnv
        duf
        exa
        jq
        killall
        micro
        nettools
        nmap
        nur.repos.federicoschonborn.fastfetch
        python3
        sops
        tldr
        traceroute
        ugrep
        wget
        whois
      ];
    in
    required-packages
    ++ lib.optionals cfg.desktops.enable (with pkgs; [
      acpi
      asciinema
      aspell
      aspellDicts.de
      aspellDicts.en
      chromium
      ffmpegthumbnailer
      gimp
      helvum
      hunspell
      hunspellDicts.de_DE
      hunspellDicts.en_US
      inkscape
      krita
      libreoffice-qt
      libsForQt5.kdenlive
      libsForQt5.kleopatra
      libsForQt5.krdc
      libsForQt5.krfb
      libsecret
      libva-utils
      lm_sensors
      movit
      nextcloud-client
      nheko
      obs-studio-wrapped
      qbittorrent
      spotify
      tdesktop-userfonts
      tor-browser-bundle-bin
      usbutils
      vorta
      vulkan-tools
    ]) ++ lib.optionals cfg.development.enable (with pkgs; [
      androidStudioPackages.canary
      ansible
      bind.dnsutils
      gitkraken
      heroku
      hugo
      jetbrains.pycharm-professional
      keybase-gui
      nixos-generators
      nixpkgs-fmt
      nixpkgs-lint
      nixpkgs-review
      nur.repos.yes.archlinux.asp
      nur.repos.yes.archlinux.devtools
      nur.repos.yes.archlinux.paru
      shellcheck
      shfmt
      speedcrunch
      teamviewer
      termius
      ventoy-full
      virt-manager
      (vscode-with-extensions.override {
        vscodeExtensions = with vscode-extensions;
          [
            b4dm4n.vscode-nixpkgs-fmt
            bbenoist.nix
            eamodio.gitlens
            esbenp.prettier-vscode
            foxundermoon.shell-format
            github.codespaces
            github.copilot
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
    ]) ++ lib.optionals cfg.yubikey (with pkgs; [
      yubikey-personalization
      yubioath-flutter
    ]) ++ lib.optionals cfg.school (with pkgs; [
      speedcrunch
      teams-for-linux
      virt-manager
    ]) ++ lib.optionals cfg.live-cd (with pkgs; [
      btrfs-progs
      chntpw
      cryptsetup
      dosfstools
      e2fsprogs
      efibootmgr
      flashrom
      gnutar
      gparted
      hexedit
      home-manager
      hwinfo
      inxi
      memtest86-efi
      ntfs3g
      nvme-cli
      p7zip
      pciutils
      perl
      qemu-utils
      rsync
      tcpdump
      testdisk
      util-linux
      wipe
      xfsprogs
    ]);

  xdg.mime.defaultApplications = {
    "application/pdf" = "okular.desktop";
    "image/png" = "okular.desktop";
  };
}
