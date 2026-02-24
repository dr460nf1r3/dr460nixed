{
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  cfg = config.dr460nixed.hm.standalone;
  configDir = ".config";
  jamesdsp = inputs.self.dragonLib.jamesdsp pkgs;
in
{
  options.dr460nixed.hm.standalone = {
    enable = lib.mkEnableOption "standalone Home Manager configuration";
  };

  config = lib.mkIf cfg.enable {
    dr460nixed.hm = {
      common.enable = true;
      misc.enable = true;
      shell.enable = true;
    };

    home.file = {
      "${configDir}/jamesdsp/irs/game.irs".source = jamesdsp.game;
      "${configDir}/jamesdsp/irs/movie.irs".source = jamesdsp.movie;
      "${configDir}/jamesdsp/irs/music.irs".source = jamesdsp.music;
      "${configDir}/jamesdsp/irs/voice.irs".source = jamesdsp.voice;
    };

    dconf.enable = true;

    nixpkgs.config.allowUnfree = true;

    nix.settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = [
        "auto-allocate-uids"
        "flakes"
        "nix-command"
      ];
    };

    services = {
      gpg-agent = {
        enableExtraSocket = lib.mkForce false;
        enableScDaemon = lib.mkForce false;
      };
      syncthing = {
        enable = lib.mkForce false;
      };
    };
    programs.mangohud.enable = lib.mkForce false;

    home.sessionVariables = {
      ALSOFT_DRIVERS = "pipewire";
      EDITOR = "micro";
      GTK_THEME = "Sweet-Dark";
      MOZ_USE_XINPUT2 = "1";
      QT_STYLE_OVERRIDE = "kvantum";
      SDL_AUDIODRIVER = "pipewire";
      VISUAL = "micro";
    };

    programs = {
      home-manager.enable = true;
      nix-index.enable = true;
    };

    home.packages = with pkgs; [
      age
      alejandra
      ansible
      appimage-run
      asciinema
      bind
      bind.dnsutils
      btop
      cached-nix-shell
      cloudflared
      deadnix
      duf
      eza
      gh
      heroku
      hugo
      jq
      killall
      manix
      micro
      mongodb-compass
      mosh
      nerdctl
      nettools
      nix-prefetch-git
      nixd
      nixos-generators
      nixpkgs-lint
      nixpkgs-review
      nmap
      nodePackages_latest.prettier
      nodejs
      nvd
      ruff
      shellcheck
      shfmt
      sops
      sqlite
      statix
      tldr
      tmux
      traceroute
      ugrep
      vulnix
      wget
      whois
      yarn
    ];
  };
}
