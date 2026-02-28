{
  config,
  lib,
  ...
}:
let
  cfg = config.dr460nixed.development;
in
{
  imports = [
    ./docker.nix
    ./vms.nix
    ./tools.nix
    ./jetbrains.nix
  ];

  options.dr460nixed.development = with lib; {
    enable = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc ''
        Enables commonly used development tools.
      '';
    };
    docker = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc "Enable Docker and containers";
    };
    vms = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc "Enable VM support (VirtualBox, KVM)";
    };
    tools = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc "Enable development tools";
    };
    jetbrains = mkOption {
      default = false;
      type = types.bool;
      description = mdDoc "Enable JetBrains IDEs and Android Studio";
    };
    user = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = mdDoc "The user to configure development tools for.";
    };
  };

  config = lib.mkIf cfg.enable {
    dr460nixed.development = {
      docker = true;
      tools = true;
      vms = true;
      jetbrains = true;
    };
  };
}
