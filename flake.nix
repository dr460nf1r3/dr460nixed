{
  description = "Dr460nixed NixOS flake ❄️";

  inputs = {
    # We roll unstable, as usual
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    # Chaotic Nyx!
    chaotic.url = "github:chaotic-cx/nyx/nyxpkgs-unstable";

    # My SSH keys
    keys_nico = {
      flake = false;
      url = "https://github.com/dr460nf1r3.keys";
    };
  };

  outputs =
    { chaotic
    , nixpkgs
    , ...
    } @ inputs:
    let
      nixos = nixpkgs;
      system = "x86_64-linux";
      specialArgs = {
        sources = {
          chaotic-toolbox = inputs.src-chaotic-toolbox;
          repoctl = inputs.src-repoctl;
        };
        keys = { nico = inputs.keys_nico; };
      };
      defaultModules = [
        chaotic.nixosModules.default
      ];

    in
    {
      # My main device (Lenovo Slim 7)
      nixosConfigurations."slim-lair" = nixos.lib.nixosSystem {
        inherit system;
        modules = defaultModules
          ++ [
          ./hosts/slim-lair/slim-lair.nix
          #impermanence.nixosModules.impermanence
        ];
        inherit specialArgs;
      };
    };
}
