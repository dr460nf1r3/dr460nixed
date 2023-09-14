# Quick start

Several preparations have to be made in order to bootstrap a working installation:

- A working `hardware-configuration.nix` needs to be generated for the current machine to replace mine
- The hosts `*.nix` configuration should be adapted to suit the hardware's needs, eg. needed kernel modules or `services.xserver.videoDrivers` should be fitting
- Since `sops-nix` is used to handle secrets, my files need to be replaced with own ones. Usage instructions can be found [here](https://github.com/Mic92/sops-nix#usage-example), basically one needs to create an age public key from the host's ed21559 SSH private key, which is then added to `.sops.yaml` to allow the host to decrypt secrets while booting up. A fitting age key should also be generated and placed in `~/.config/sops/age/keys.txt` as described in the usage instructions - this allows decrypting the secrets file to edit it. It lives in `secrets/global.yaml` and contains the secrets and can be edited with sops `secrets/global.yaml` (opens a terminal text editor).
- It might be easier to supply a static password in `users.nix` for bootstrapping, since no login will be possible if the secrets management isn't properly set up yet. I had a few issues with this in the past while setting things up, so I felt giving this advice might help. Usernames are of course also to be changed, as well as SSH public keys.

Then, the bootstrapping process can be started. All you need is `nix`. Run:

`nix develop` or `nix-shell` to create a shell containing the basic dependencies, then you can proceed by `nixos-rebuild --flake .#hostname` to build system configurations.

How to proceed from here?

- Adapt the configurations like enabled modules and home-manager configs to your needs
- Set up CI to build your custom system configurations
- Add your hosts to Tailscale, if you want to be using it. I can warmly recommend it for connecting with any kind of host!
- Build an ISO to play around with `nix build .#iso` - this has no theming, but has all the important configs for live usb purposes
- ... so much more. It never ends ❄️
