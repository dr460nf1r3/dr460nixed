{
  lib,
  pkgs,
  config,
  ...
}:
let
  cfg = config.dr460nixed.hm.standalone;
in
{
  options.dr460nixed.hm.standalone = {
    enable = lib.mkEnableOption "standalone Home Manager configuration (non-NixOS hosts only)";
  };

  config = lib.mkIf cfg.enable {
    # Pull in the shared core; everything else here is standalone-specific
    dr460nixed.hm.core.enable = true;

    # On NixOS, allowUnfree is set globally; here we must opt-in ourselves
    nixpkgs.config.allowUnfree = true;

    # Required when home-manager manages nix.* options outside of NixOS
    nix.package = pkgs.nix;

    # Nix daemon settings that NixOS manages for us on NixOS hosts
    nix.settings = {
      auto-optimise-store = true;
      builders-use-substitutes = true;
      experimental-features = [
        "auto-allocate-uids"
        "flakes"
        "nix-command"
      ];
    };

    # Services that are managed by NixOS modules when running on NixOS;
    # disable or tone down the HM variants so they don't conflict
    services = {
      gpg-agent = {
        enableExtraSocket = lib.mkForce false;
        enableScDaemon = lib.mkForce false;
      };
      syncthing.enable = lib.mkForce false;
    };

    programs = {
      home-manager.enable = true;
      mangohud.enable = lib.mkForce false;
      nix-index.enable = true;
    };
  };
}
