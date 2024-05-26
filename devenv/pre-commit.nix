{pkgs, ...}: {
  pre-commit.hooks = {
    actionlint.enable = true;
    alejandra-quiet = {
      description = "Run Alejandra in quiet mode";
      enable = true;
      entry = ''
        ${pkgs.alejandra}/bin/alejandra --quiet
      '';
      files = "\\.nix$";
      name = "alejandra";
    };
    commitizen.enable = true;
    deadnix.enable = true;
    detect-private-keys.enable = true;
    # editorconfig-checker.enable = true;
    flake-checker.enable = true;
    markdownlint.enable = true;
    nil.enable = true;
    prettier.enable = true;
    statix.enable = true;
    typos.enable = true;
    yamllint.enable = true;
  };
}
