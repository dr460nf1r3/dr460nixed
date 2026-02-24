{
  config,
  lib,
  ...
}:
let
  cfg = config.dr460nixed.servers;
in
{
  options.dr460nixed.servers = with lib; {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc ''
        Whether this device is a server.
      '';
    };
  };

  config = lib.mkIf cfg.enable {
    # The common used config is not available
    programs.fish.shellInit = lib.mkForce ''
      set fish_greeting
      fastfetch -l nixos
    '';

    # Automatic server upgrades
    dr460nixed.auto-upgrade.enable = lib.mkDefault true;

    # No custom aliases
    dr460nixed.shells.enable = lib.mkDefault false;

    # These aren't needed on servers, but default on GNS
    garuda = {
      audio.pipewire.enable = false;
      hardware.enable = false;
      networking.enable = false;
    };
    boot.plymouth.enable = false;
  };
}
