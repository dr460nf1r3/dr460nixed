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
      nodePackages_latest.bash-language-server
      nodePackages_latest.pnpm
      nodePackages_latest.prettier
      nodejs_latest
      opencode
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
  };
}
