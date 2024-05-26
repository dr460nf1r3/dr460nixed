{
  perSystem = {pkgs, ...}: {
    packages = let
      # Source repl.nix for pre-setup "nix repl"
      replPath = toString ./.;
    in
      with pkgs; {
        # Builds the documentation
        docs =
          runCommand "dr460nixed-docs"
          {nativeBuildInputs = [bash mdbook];} ''
            bash -c "errors=$(mdbook build -d $out ${../.}/docs |& grep ERROR)
            if [ \"$errors\" ]; then
              exit 1
            fi"
          '';

        # Installs a basic dr460nixed template
        installer = writeShellApplication {
          name = "dr460nixed-installer";
          runtimeInputs = [coreutils git nixos-install-tools];
          text = builtins.readFile ./installer.sh;
        };

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
