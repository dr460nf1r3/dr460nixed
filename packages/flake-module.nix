{
  perSystem =
    {
      pkgs,
      ...
    }:
    {
      packages =
        let
          replPath = toString ./.;
        in
        {
          docs =
            pkgs.runCommand "dr460nixed-docs"
              {
                nativeBuildInputs = with pkgs; [
                  mdbook
                ];
              }
              ''
                mdbook build -d $out ${../.}/docs
              '';

          installer = pkgs.writeShellApplication {
            name = "dr460nixed-installer";
            runtimeInputs = with pkgs; [
              coreutils
              git
              nixos-install-tools
            ];
            text = builtins.readFile ./installer.sh;
          };

          iso = pkgs.writeShellScriptBin "dr460nixed-iso" ''
            nix build .#nixosConfigurations.dr460nixed-desktop.config.formats.install-iso
          '';

          repl = pkgs.writeShellScriptBin "dr460nixed-repl" ''
            source /etc/set-environment
            nix repl --file "${replPath}/repl.nix" "$@"
          '';

          vbox = pkgs.writeShellScriptBin "dr460nixed-vbox" ''
            nix build .#nixosConfigurations.dr460nixed-base.config.formats.virtualbox
          '';
        };
    };
}
