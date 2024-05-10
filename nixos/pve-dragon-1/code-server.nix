{pkgs, ...}: {
  services.code-server = {
    auth = "none";
    enable = true;
    extraArguments = [
      "--disable-telemetry"
      "--proxy-domain=code.dr460nf1r3.org"
    ];
    host = "127.0.0.1";
    package = pkgs.vscode-with-extensions.override {
      vscode = pkgs.code-server;
      vscodeExtensions = with pkgs.vscode-extensions;
        [
          bbenoist.nix
          catppuccin.catppuccin-vsc
          catppuccin.catppuccin-vsc-icons
          charliermarsh.ruff
          davidanson.vscode-markdownlint
          eamodio.gitlens
          esbenp.prettier-vscode
          foxundermoon.shell-format
          github.codespaces
          github.copilot
          github.vscode-github-actions
          github.vscode-pull-request-github
          jnoortheen.nix-ide
          kamadorueda.alejandra
          ms-azuretools.vscode-docker
          ms-python.python
          ms-python.vscode-pylance
          ms-vscode-remote.remote-ssh
          ms-vsliveshare.vsliveshare
          redhat.vscode-xml
          redhat.vscode-yaml
          timonwong.shellcheck
          tyriar.sort-lines
          wakatime.vscode-wakatime
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            # Available in nixpkgs, but outdated (0.4.0) at the time of adding
            name = "vscode-tailscale";
            publisher = "tailscale";
            sha256 = "sha256-MKiCZ4Vu+0HS2Kl5+60cWnOtb3udyEriwc+qb/7qgUg=";
            version = "1.0.0";
          }
        ];
    };
    port = 4444;
    user = "nico";
  };
}
