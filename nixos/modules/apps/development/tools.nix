{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.dr460nixed.development;
in
{
  config = lib.mkIf cfg.tools {
    programs.wireshark.enable = true;

    environment.systemPackages = with pkgs; [
      ansible
      (bash-language-server.override {
        nodejs = pkgs.nodejs_latest;
      })
      bruno
      cloudflared
      cmake
      deadnix
      deno
      distrobox
      docker-compose
      gh
      gnumake
      heroku
      hugo
      mdbook
      nil
      nixfmt
      nixd
      nix-prefetch-git
      nixos-generators
      nixpkgs-lint
      nixpkgs-review
      nmap
      nodejs_latest
      opencode
      opencode-desktop
      (pnpm.override {
        nodejs = pkgs.nodejs_latest;
      })
      (prettier.override {
        nodejs = pkgs.nodejs_latest;
      })
      rust-analyzer
      rustup
      shellcheck
      shfmt
      sops
      traceroute
      vscode.fhs
      (yarn-berry.override {
        nodejs = pkgs.nodejs_latest;
      })
      whois
      zed-editor
    ];

    networking.hosts = {
      "127.0.0.1" = [
        "metrics.chaotic.local"
        "backend.chaotic.local"
      ];
    };

    environment.variables = {
      CARGO_HOME = "$HOME/.cargo";
      PNPM_HOME = "$HOME/.local/share/pnpm";
    };
  };
}
