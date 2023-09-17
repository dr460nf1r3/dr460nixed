{
  inputs,
  pkgs,
  self,
  ...
}: {
  flake = let
    # Default modules to use in all systems
    defaultModules = [
      ./modules
      inputs.disko.nixosModules.disko
      inputs.lanzaboote.nixosModules.lanzaboote
      inputs.nix-snapshotter.nixosModules.default
      inputs.sops-nix.nixosModules.sops
    ];

    # Our images should be cleaner, so we use a different set of modules
    imageModules = [
      ./modules/desktops.nix
      ./modules/misc.nix
      ../overlays
      inputs.nixos-generators.nixosModules.all-formats
    ];

    specialArgs = {
      inherit inputs;
      keys.nico = inputs.keys_nico;
      sources = {
        chaotic-toolbox = inputs.src-chaotic-toolbox;
        repoctl = inputs.src-repoctl;
      };
      self = {
        inherit (self) inputs;
        inherit (self) nixosModules;
        packages = self.packages.x86_64-linux;
      };
    };
  in {
    # All the system configurations
    nixosConfigurations = {
      # My main device (Lenovo Slim 7)
      dragons-ryzen = inputs.garuda-nix.lib.garudaSystem {
        system = "x86_64-linux";
        modules =
          defaultModules
          ++ [
            ./dragons-ryzen/dragons-ryzen.nix
            ./modules/disko/zfs-encrypted.nix
            inputs.impermanence.nixosModules.impermanence
            inputs.nixos-hardware.nixosModules.common-cpu-amd
            inputs.nixos-hardware.nixosModules.common-cpu-amd-pstate
            inputs.nixos-hardware.nixosModules.common-gpu-amd
            {
              _module.args.disks = ["/dev/nvme0n1"];
              nixpkgs.overlays = [
                inputs.nixd.overlays.default
                inputs.nix-snapshotter.overlays.default
              ];
            }
          ];
        inherit specialArgs;
      };

      # Dr460nixed base image for nixos-generators
      dr460nixed-base = inputs.garuda-nix.lib.garudaSystem {
        system = "x86_64-linux";
        modules =
          imageModules ++ [./images/base.nix];
        inherit specialArgs;
      };

      # Dr460nized desktop image for nixos-generators
      dr460nixed-desktop = inputs.garuda-nix.lib.garudaSystem {
        system = "x86_64-linux";
        modules =
          imageModules ++ [./images/iso.nix];
        inherit specialArgs;
      };

      # For WSL, mostly used at work only
      nixos-wsl = inputs.garuda-nix.lib.garudaSystem {
        system = "x86_64-linux";
        modules =
          defaultModules
          ++ [
            ./nixos-wsl/nixos-wsl.nix
            inputs.nixos-wsl.nixosModules.wsl
          ];
        inherit specialArgs;
      };

      # Free Tier Oracle aarch64 VM
      oracle-dragon = inputs.garuda-nix.lib.garudaSystem {
        system = "aarch64-linux";
        modules =
          defaultModules ++ [./oracle-dragon/oracle-dragon.nix];
        inherit specialArgs;
      };

      # My Raspberry Pi 4B
      rpi-dragon = inputs.garuda-nix.lib.garudaSystem {
        system = "aarch64-linux";
        modules =
          defaultModules
          ++ [
            ./rpi-dragon/rpi-dragon.nix
            inputs.nixos-hardware.nixosModules.raspberry-pi-4
          ];
        inherit specialArgs;
      };

      # My old laptop serving as TV
      tv-nixos = inputs.garuda-nix.lib.garudaSystem {
        system = "x86_64-linux";
        modules =
          defaultModules
          ++ [
            ./tv-nixos/tv-nixos.nix
            inputs.nixos-hardware.nixosModules.common-gpu-intel
            inputs.nixos-hardware.nixosModules.lenovo-thinkpad-t470s
          ];
        inherit specialArgs;
      };
    };

    # Expose dr460nixed and other modules for use in other flakes
    nixosModules.dr460nixed = import ./modules;

    # Images to build via "nix build .#packages.{iso,vbox}"
    packages.x86_64-linux = {
      iso = pkgs.writeScriptBin "dr460nixed-iso" ''
        ${pkgs.nix}/bin/nix build .#nixosConfigurations.dr460nixed-iso.config.formats.install-iso
      '';
      vbox = pkgs.writeScriptBin "dr460nixed-vbox" ''
        ${pkgs.nix}/bin/nix build .#nixosConfigurations.dr460nixed-iso.config.formats.vbox
      '';
    };
  };
}
