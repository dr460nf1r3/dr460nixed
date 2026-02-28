{
  lib,
  pkgs,
  ...
}:
{
  # Import base configuration
  imports = [ ./base.nix ];

  users.users.nixos.autoSubUidGidRange = false;

  # Enable a few selected custom settings
  dr460nixed.desktops.enable = true;

  # Home-manager configuration for desktops
  garuda = {
    home-manager.modules = [ ../../home-manager/desktops.nix ];
    noSddmAutologin = {
      enable = true;
      startupCommand = "startplasma-wayland";
      user = "nixos";
    };
  };

  # Fix conflict with the cd-graphical-base module (we use Pipewire)
  services.pulseaudio.enable = lib.mkForce false;

  # Desktop environment packages
  environment.systemPackages = with pkgs; [
    acpi
    ansible
    bind.dnsutils
    chntpw
    cryptsetup
    efibootmgr
    ffmpegthumbnailer
    flashrom
    freerdp
    hwinfo
    inxi
    libsecret
    libva-utils
    lm_sensors
    memtest86-efi
    nixos-generators
    obs-studio-wrapped
    pciutils
    rustdesk
    speedcrunch
    tcpdump
    usbutils
    (vscode-with-extensions.override {
      vscodeExtensions =
        with vscode-extensions;
        [
          bbenoist.nix
          davidanson.vscode-markdownlint
          eamodio.gitlens
          esbenp.prettier-vscode
          foxundermoon.shell-format
          jnoortheen.nix-ide
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
    xdg-utils
  ];

  # NixOS stuff
  system.stateVersion = "26.05";
}
