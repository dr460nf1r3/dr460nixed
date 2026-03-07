{ lib, config, ... }:
let
  cfg = config.dr460nixed.hm.mcp;
in
{
  options.dr460nixed.hm.mcp = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.dr460nixed.hm.development.enable;
      description = "Enable MCP configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.mcp = {
      enable = true;
      servers = {
        context7 = {
          url = "https://mcp.context7.com/mcp";
          headers = {
            CONTEXT7_API_KEY = "{env:CONTEXT7_API_KEY}";
          };
        };
        deepwiki = {
          url = "https://mcp.deepwiki.com/mcp";
        };
        nixos = {
          command = "nix";
          args = [
            "run"
            "github:utensils/mcp-nixos"
            "--"
          ];
        };
      };
    };
  };
}
