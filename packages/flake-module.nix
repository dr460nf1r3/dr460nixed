{
  perSystem = {pkgs, ...}: {
    packages = let
      # Source repl.nix for pre-setup "nix repl"
      replPath = toString ./.;
    in {
      # Builds the documentation
      docs =
        pkgs.runCommand "dr460nixed-docs"
        {nativeBuildInputs = with pkgs; [bash mdbook];} ''
          bash -c "errors=$(mdbook build -d $out ${../.}/docs |& grep ERROR)
          if [ \"$errors\" ]; then
            exit 1
          fi"
        '';

      # Installs a basic dr460nixed template
      installer = pkgs.writeShellApplication {
        name = "dr460nixed-installer";
        runtimeInputs = with pkgs; [coreutils git nixos-install-tools];
        text = builtins.readFile ./installer.sh;
      };

      # Builds the ISO
      iso = pkgs.writeShellScriptBin "dr460nixed-iso" ''
        nix build .#nixosConfigurations.dr460nixed-desktop.config.formats.install-iso
      '';

      # Sets up repl environment with access to the flake
      repl = pkgs.writeShellScriptBin "dr460nixed-repl" ''
        source /etc/set-environment
        nix repl --file "${replPath}/repl.nix" "$@"
      '';

      # Builds the virtualbox image
      vbox = pkgs.writeShellScriptBin "dr460nixed-vbox" ''
        nix build .#nixosConfigurations.dr460nixed-base.config.formats.virtualbox
      '';
    };
  };
}
