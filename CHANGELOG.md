## 1.0.0 (2023-09-17)

### Feat

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
- **flake**: expose dr460nixed.\* modules to other flakes
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
