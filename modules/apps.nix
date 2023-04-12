{ config, lib, pkgs, ... }:
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
}
