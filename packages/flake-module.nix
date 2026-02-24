{
  perSystem =
    {
      pkgs,
      config,
      ...
    }:
    {
      packages =
        let
          # Source repl.nix for pre-setup "nix repl"
          replPath = toString ./.;
        in
        {
          # Builds the documentation
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

          # Installs a basic dr460nixed template
          installer = pkgs.writeShellApplication {
            name = "dr460nixed-installer";
            runtimeInputs = with pkgs; [
              coreutils
              git
              nixos-install-tools
            ];
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

          # Generate GitHub Action workflows
          workflows = pkgs.runCommand "copy-workflows" { } ''
            mkdir -p $out/.github/workflows
            cp -r ${config.githubActions.workflowsDir}/* $out/.github/workflows/
          '';

          # Write GitHub Action workflows to the repository
          write-workflows = pkgs.writeShellApplication {
            name = "write-workflows";
            text = ''
              dest=".github/workflows"
              mkdir -p "$dest"
              # Ensure we are in the flake root or can find the .github directory
              if [ ! -d ".github" ]; then
                echo "Error: .github directory not found. Please run this from the project root."
                exit 1
              fi
              cp -v ${config.githubActions.workflowsDir}/* "$dest/"
              chmod +w "$dest"/*
            '';
          };
        };
    };
}
