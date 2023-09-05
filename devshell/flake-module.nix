_:
{
  # imports = [
  #   inputs.treefmt-nix.flakeModule
  # ];

  perSystem = { pkgs, ... }:
    {
      # The default development shell spawned by "nix develop"
      devshells.default = {
        commands = [
          {
            package = "treefmt";
            category = "formatter";
          }
          {
            package = "pre-commit";
            category = "formatter";
          }
          {
            package = "manix";
            category = "tools";
          }
          {
            package = "age";
            category = "tools";
          }
          {
            package = "commitizen";
            category = "tools";
          }
          {
            package = "gnupg";
            category = "tools";
          }
          {
            package = "rsync";
            category = "tools";
          }
          {
            package = "sops";
            category = "tools";
          }
        ];
        motd = ''
          {202}🔨 Welcome to the dr460nixed shell ❄️{reset}
          $(type -p menu &>/dev/null && menu)
        '';
        name = "dr460nixed";
      };

      # Pre-commit linters & formatters
      pre-commit = {
        check.enable = true;
        inherit pkgs;
        settings = {
          hooks = {
            actionlint.enable = true;
            commitizen.enable = true;
            deadnix.enable = true;
            markdownlint.enable = true;
            nil.enable = true;
            nixpkgs-fmt.enable = true;
            pre-commit-hook-ensure-sops.enable = true;
            prettier.enable = true;
            shellcheck.enable = true;
            shfmt.enable = true;
            statix.enable = true;
            yamllint.enable = true;
          };
          settings.deadnix = {
            edit = true;
            hidden = true;
            noLambdaArg = true;
          };
          src = ../.;
        };
      };
    };
}
