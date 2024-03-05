# https://github.com/drduh/YubiKey-Guide
let
  configuration = {
    config,
    lib,
    pkgs,
    ...
  }:
    with pkgs; let
      src = fetchGit "https://github.com/drduh/YubiKey-Guide";

      guide = "${src}/README.md";

      contrib = "${src}/contrib";

      drduhConfig = fetchGit "https://github.com/drduh/config";

      gpg-conf = "${drduhConfig}/gpg.conf";

      xserverCfg = config.services.xserver;

      pinentryFlavour =
        if xserverCfg.desktopManager.lxqt.enable || xserverCfg.desktopManager.plasma6.enable
        then "qt"
        else if xserverCfg.desktopManager.xfce.enable
        then "gtk2"
        else if xserverCfg.enable || config.programs.sway.enable
        then "gnome3"
        else "curses";

      # Instead of hard-coding the pinentry program, chose the appropriate one
      # based on the environment of the image the user has chosen to build.
      gpg-agent-conf = runCommand "gpg-agent.conf" {} ''
        sed '/pinentry-program/d' ${drduhConfig}/gpg-agent.conf > $out
        echo "pinentry-program ${pinentry.${pinentryFlavour}}/bin/pinentry" >> $out
      '';

      view-yubikey-guide = writeShellScriptBin "view-yubikey-guide" ''
        viewer="$(type -P xdg-open || true)"
        if [ -z "$viewer" ]; then
          viewer="${glow}/bin/glow -p"
        fi
        exec $viewer "${guide}"
      '';

      shortcut = makeDesktopItem {
        name = "yubikey-guide";
        icon = "${yubikey-manager-qt}/share/ykman-gui/icons/ykman.png";
        desktopName = "drduh's YubiKey Guide";
        genericName = "Guide to using YubiKey for GPG and SSH";
        comment = "Open the guide in a reader program";
        categories = ["Documentation"];
        exec = "${view-yubikey-guide}/bin/view-yubikey-guide";
      };

      yubikey-guide = symlinkJoin {
        name = "yubikey-guide";
        paths = [view-yubikey-guide shortcut];
      };
    in {
      nixpkgs.config = {allowBroken = true;};

      isoImage.isoBaseName = lib.mkForce "nixos-yubikey";
      # Uncomment this to disable compression and speed up image creation time
      #isoImage.squashfsCompression = "gzip -Xcompression-level 1";

      boot.kernelPackages = linuxPackages_latest;
      # Always copytoram so that, if the image is booted from, e.g., a
      # USB stick, nothing is mistakenly written to persistent storage.
      boot.kernelParams = ["copytoram"];
      # Secure defaults
      boot.cleanTmpDir = true;
      boot.kernel.sysctl = {"kernel.unprivileged_bpf_disabled" = 1;};

      services.pcscd.enable = true;
      services.udev.packages = [yubikey-personalization];

      programs = {
        ssh.startAgent = false;
        gnupg.agent = {
          enable = true;
          enableSSHSupport = true;
        };
      };

      environment.systemPackages = [
        # Tools for backing up keys
        paperkey
        pgpdump
        parted
        cryptsetup

        # Yubico's official tools
        yubikey-manager
        yubikey-manager-qt
        yubikey-personalization
        yubikey-personalization-gui
        yubico-piv-tool
        yubioath-flutter

        # Testing
        ent
        (haskell.lib.justStaticExecutables haskellPackages.hopenpgp-tools)

        # Password generation tools
        diceware
        pwgen

        # Miscellaneous tools that might be useful beyond the scope of the guide
        cfssl
        pcsctools

        # This guide itself (run `view-yubikey-guide` on the terminal to open it
        # in a non-graphical environment).
        yubikey-guide
      ];

      # Disable networking so the system is air-gapped
      # Comment all of these lines out if you'll need internet access
      boot.initrd.network.enable = false;
      networking.dhcpcd.enable = false;
      networking.dhcpcd.allowInterfaces = [];
      networking.interfaces = {};
      networking.firewall.enable = true;
      networking.useDHCP = false;
      networking.useNetworkd = false;
      networking.wireless.enable = false;
      networking.networkmanager.enable = lib.mkForce false;

      # Unset history so it's never stored
      # Set GNUPGHOME to an ephemeral location and configure GPG with the
      # guide's recommended settings.
      environment.interactiveShellInit = ''
        unset HISTFILE
        export GNUPGHOME="/run/user/$(id -u)/gnupg"
        if [ ! -d "$GNUPGHOME" ]; then
          echo "Creating \$GNUPGHOME…"
          install --verbose -m=0700 --directory="$GNUPGHOME"
        fi
        [ ! -f "$GNUPGHOME/gpg.conf" ] && cp --verbose ${gpg-conf} "$GNUPGHOME/gpg.conf"
        [ ! -f "$GNUPGHOME/gpg-agent.conf" ] && cp --verbose ${gpg-agent-conf} "$GNUPGHOME/gpg-agent.conf"
        echo "\$GNUPGHOME is \"$GNUPGHOME\""
      '';

      # Copy the contents of contrib to the home directory, add a shortcut to
      # the guide on the desktop, and link to the whole repo in the documents
      # folder.
      system.activationScripts.yubikeyGuide = let
        homeDir = "/home/nixos/";
        desktopDir = homeDir + "Desktop/";
        documentsDir = homeDir + "Documents/";
      in ''
        mkdir -p ${desktopDir} ${documentsDir}
        chown nixos ${homeDir} ${desktopDir} ${documentsDir}

        cp -R ${contrib}/* ${homeDir}
        ln -sf ${yubikey-guide}/share/applications/yubikey-guide.desktop ${desktopDir}
        ln -sfT ${src} ${documentsDir}/YubiKey-Guide
      '';
    };

  nixos = import <nixpkgs/nixos/release.nix> {
    inherit configuration;
    supportedSystems = ["x86_64-linux"];
  };

  nixos-yubikey = nixos.iso_plasma6;
in {
  inherit nixos-yubikey;
}
