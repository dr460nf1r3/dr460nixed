## 1.3.0 (2024-01-20)

### Feat

- **shells**: add alias/abbr for qemu-kvm booting usb drive
- globally disable coredumps
- **oracle-dragon**: whitelist enable
- **oracle-dragon**: add Multiverse plugins to Minecraft
- **oracle-dragon**: update Minecraft server settings
- **oracle-dragon**: enable MC online mode and add myself to minecraft group
- **oracle-dragon**: replace Minecraft Bedrock server with Paper/Geyser
- **oracle-dragon**: update Minecraft Bedrock server config
- **oracle-dragon**: add Minecraft Bedrock server
- **oracle-dragon**: update Tailscale IP, deprecate Adguard in favour of NextDNS
- **oracle-dragon**: fresh setup
- **dragons-ryzen**: only prompt for LUKS password once during bootup
- **dragons-ryzen**: add swapfile
- **dragons-ryzen**: this one is a garuda-nix-subsystem again
- **kde6**: add KDE6 nixosConfiguration to cache builds via Garnix CI
- **dragons-ryzen**: add flatpak to allow using mpcelauncher
- **kde2nix**: add KDE 6 flake to inputs, bump all of them
- add archix flake for Arch development purposes (and bump inputs)
- **development**: add some things for Arch package development
- **duo**: make it opt-in rather than opt-out
- **dragons-ryzen**: this is a pure NixOS device once again
- **dragons-ryzen**: make the standalone installation a Garuda Nix Subsystem again
- **nixd**: add nixd option evaluation and config file
- **desktops**: default to wayland
- **apps**: add vivaldi and persist the Games folder
- **auto-cpufreq**: add auto-cpufreq flake and enable it on dragons-ryzen
- **adblock**: add adblock module to template, fixup some errors
- **dragons-ryzen**: enable chaotic.mesa-git
- **adblock**: enable host-based adblocking on demand
- **apps**: add github cli (gh) and ocrmypdf, also bump all inputs

### Fix

- **netdata**: re-enable Cloud feature
- **dragons-ryzen**: bluetooth was still not working properly until un/reloading btusb
- **dragons-ryzen**: set SDDM auto-login to plasma
- **development**: don't use zfs docker driver on btrfs
- test
- **locales**: add missing C.UTF-8 lang
- **devshell**: don't use yamlfix for now
- **tv-nixos**: allow building with insecure Electron for now
- **build**: fix build issue for real this time
- **build**: caused by incorrect example nix option and deprecated one
- **build**: comment python-debugpy, broken again. also alias grep to ugrep and bump chaotic-nyx/nixpkgs
- **chaotic**: disable module completely as I currently don't use it
- **images**: include spicetify-nix module which was removed from GNS
- **build**: temporarily disable msmtp until python2.7-oildev is fixed; add missing module (caused by GNS update)

## 1.2.0 (2023-09-24)

### Feat

- **remote-build**: add shell alises, also disables nix-super by default
- **boot**: add GRUB module option
- **apps**: add yt-dlp_git from chaotic-nyx
- **apps**: add firefox_nightly from chaotic-nyx, improve text on installer
- **installer**: more verbosity for nixos-install and confirmation prompts
- **template**: automatically enable options needed for a zfs system via disko module
- **rustdesk**: provide a working desktop launcher, since the package ships none
- **apps**: use telegram-desktop_git from chaotic-nyx instead of tdesktop
- **installer**: automatically detect whether GRUB or systemd-boot needs to be installed

### Fix

- **multiple**: complete nix-snapshotter removal, improve nix remb aliases
- **fish**: fix fish configuration not getting generated, merge shell/nico.nix

### Refactor

- **flake.nix**: sort inputs in another way, remove nix-snapshotter
- **dragons-ryzen**: move join services.* settings; comment out cachix key for now

## 1.1.0 (2023-09-21)

### Feat

- **images**: add yubikey image from drduh's yubikey guide
- **installer**: include installer in ISO and support both dr460nixed/regular NixOS ISO
- **installer**: prepare installer for a basic dr460nixed flake via template

### Fix

- **template**: apparently dr460nixed is not of type a-zA-Z0-9
- **ci**: fix cut failing to provide a valid string; also disables promtail by default)
- **installer**: enable experimental features on non-dr460nixed live cd via env var #28
- **installer**: fix various issues that prevented the installation
- **docs**: update path of docs, got messed up by moving packages to their own dir
- **installer**: final fixups, add README
- **installer**: fixup build blockers & minor enhancements
- **installer**: fix paths, use current dir to prepare system, add image modules
- **installer**: use a better way to check whether disk is valid, move hosts to nixos directory
- **installer**: lots of improvements and fixes (yes, really.)

### Refactor

- **template**: symlinks don't work with flake templates, therefore provide the real files and strip them down
- **flake.nix**: move packages to their own directory and make nixos-generators an input

## 1.0.0 (2023-09-18)

### Feat

- **images**: add image name customisation and import NixOS installer profiles, activating Calamares
- **images**: give the user a generic name
- **images**: fix failures by including installer cd modules
- **images**: provide more configurations for the iso; set up automatic Github releases
- **images**: provide a fully functional dr460nixed iso via nixos-generators
- **modules**: add nix remote build module; move garuda options to dr460nixed ones; minor changes
- **pre-commit-hooks;apps**: add quiet alejandra; use nixpkgs ruff vscode-extension
- **flake**: adds repl package for quick access to flake, use alejandra as formatter
- **home-manager**: make use of garuda's system-wide home manager option and apply modules on demand
- **flake**: add new modules, redo a few files
- **apps**: add nix-snapshotter
- **docs**: update mdbook config
- **flake,-docs**: refactor flake to provide the same nix-shell/nix develop; add mdbook for documentation generation
- **inputs;-nix**: replace nix with nix-super; move inputs to garuda-nix-subsystem & add nix-gaming lowlatecy
- **flake**: use common inputs by specifying follows; enable nix lock file maintenance
- **flake**: expose dr460nixed.* modules to other flakes
- **tailscale**: allow my personal devices to use Mullvad exit nodes
- **impermanence.nix**: add more persisting directories (direnv, lorri, ..)
- **flake**: rotate my SSH key used to authenticate
- **flake.nix**: add NUR module; update inputs
- **apps.nix;-boot.nix**: add wireshark and sqlite to apps; make boot completely quiet
- **dragons-ryzen**: enable autologin; always request zfs encryption credentials
- **apps.nix;-shell.nix**: add vulnix; add nix flakes enabled shell; add chromium-gate option
- **dragons-ryzen**: set up dragons-ryzen with ZFS encrypted root & disko
- **development.nix**: enhance direnv with lorri
- **apps.nix**: add manix as cli manual
- **development.nix**: add Garuda nspawn configuration
- **vscode**: update ruff and tailscale extensions
- **.cz.json**: add commitizen for commit management
- add syncthing module; flake.nix: cleanup
- add bfptune; add back sudo insults
- add remove-ssh & pull-request vscode extentions
- Duo 2FA on servers; feat: tailscale SSH

### Fix

- **all**: fixes build issues due to deterministicIds & enables redistributable hardware
- **cache**: replace cachix with garnix cache; attempt fixing CI cache failure
- **users.nix,flack.lock**: fix renamed hashedPasswordFile option; bump garuda-nix-subsystem to fixed commit
- **flake.nix**: remove obsolete inputs & import
- **pages.yml**: fix typo
- **tv-nixos**: remove obsolete, build breaking import
- **shells**: final fix for exa -> eza change. updates garuda-nix-subsystem to the fixed comment
- **shells**: fix build error by replacing exa with eza - exa is unmaintained and got dropped from Nixpkgs almost INSTANTLY
- **nixos-wsl.nix**: turn off nftables as it seems to be required for nixos-wsl
- **builds**: fix all profile and package builds; fix build image workflow
- **.prettierignore**: add flack.lock to exclusions
- **checks**: fix check build error
- **dragons-ryzen;-tv-nixos**: fix bluetooth by adding btintel kernel module
- **flake**: remove irrelevant code; update GH runner token
- **disko**: fix disko modules to allow usage with flakes
- **github-runner.nix**: fix GitHub runner service and update runner token

### Refactor

- **policy.hujson**: compact keys
- **modules**: move a few more modules to garuda-nix-subsystem and adapt flake inputs to it
- **shells.nix**: use more variables for commonly used strings and use Tailnet FQDN
- **structure**: put important folders to top level & update README to reflect the changes
- **yaml**: run yamlfix on all corresponding files and add a fitting configuration for it
- **flake**: heavily refactor flake based on flake-parts
