{pkgs, ...}: {
  # Import base configuration
  imports = [./base.nix];

  # Enable a few selected custom settings
  dr460nixed = {
    chromium = true;
    desktops.enable = true;
  };

  # Home-manager desktop settings
  home-manager.users."nico" = import ../../home-manager/desktops.nix;

  # CD's may use autologin for convenience
  services.xserver.displayManager.sddm.settings = {
    Autologin = {
      User = "nico";
      Session = "plasma";
    };
  };

  # Wireshark
  programs.wireshark.enable = true;

  # Desktop environment
  environment.systemPackages = with pkgs; [
    acpi
    ansible
    ansible
    beekeeper-studio
    bind.dnsutils
    chntpw
    chromium-flagged
    cryptsetup
    deadnix
    efibootmgr
    ffmpegthumbnailer
    flashrom
    freerdp
    heroku
    hugo
    hwinfo
    inxi
    libsecret
    libva-utils
    lm_sensors
    memtest86-efi
    nix-prefetch-git
    nixos-generators
    obs-studio-wrapped
    pciutils
    rsync
    rustdesk
    speedcrunch
    speedcrunch
    tcpdump
    tdesktop
    termius
    usbutils
    ventoy-full
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions;
        [
          bbenoist.nix
          davidanson.vscode-markdownlint
          eamodio.gitlens
          esbenp.prettier-vscode
          foxundermoon.shell-format
          jnoortheen.nix-ide
          kamadorueda.alejandra
          pkief.material-icon-theme
          redhat.vscode-yaml
          tyriar.sort-lines
        ]
        ++ vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "sweet-vscode";
            publisher = "eliverlara";
            sha256 = "sha256-kJgqMEJHyYF3GDxe1rnpTEmbfJE01tyyOFjRUp4SOds=";
            version = "1.1.1";
          }
        ];
    })
    vulkan-tools
    vulnix
    wireshark
    xdg-utils
    yubikey-manager-qt
    yubioath-flutter
  ];

  # We use iwd instead
  networking.wireless.enable = false;

  # NixOS stuff
  system.stateVersion = "23.11";
}
