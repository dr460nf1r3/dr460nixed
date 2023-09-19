{
  perSystem = {pkgs, ...}: {
    packages = let
      # Source repl.nix for pre-setup "nix repl"
      replPath = toString ./.;
    in
      with pkgs; {
        # Builds the ISO
        iso = writeShellScriptBin "dr460nixed-iso" ''
          nix build .#nixosConfigurations.dr460nixed-desktop.config.formats.install-iso
        '';

        # Sets up repl environment with access to the flake
        repl = writeShellScriptBin "dr460nixed-repl" ''
          source /etc/set-environment
          nix repl --file "${replPath}/repl.nix" "$@"
        '';

        # Builds the virtualbox image
        vbox = writeShellScriptBin "dr460nixed-vbox" ''
          nix build .#nixosConfigurations.dr460nixed-base.config.formats.virtualbox
        '';
      };
  };
}
