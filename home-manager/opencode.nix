{ lib, config, ... }:
let
  cfg = config.dr460nixed.hm.opencode;
in
{
  options.dr460nixed.hm.opencode = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.dr460nixed.hm.development.enable;
      description = "Enable OpenCode configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.opencode = {
      enable = true;
      enableMcpIntegration = true;

      settings = {
        theme = "catppuccin";
        model = "google/gemini-3-flash-preview";
        autoshare = false;
        autoupdate = true;
        plugin = [ "opencode-gemini-auth@latest" ];
        provider = {
          google = {
            models = {
              "gemini-3-flash-preview" = {
                options = {
                  thinkingConfig = {
                    thinkingLevel = "high";
                    includeThoughts = true;
                  };
                };
              };
              "gemini-3.1-pro-preview" = {
                options = {
                  thinkingConfig = {
                    thinkingLevel = "high";
                    includeThoughts = true;
                  };
                };
              };
            };
          };
        };
      };

      commands = {
        commit = ''
          # Commit Command
          Create a git commit with proper message formatting. Follow conventional commits if possible.
          Usage: /commit [message]
        '';
        explain = ''
          # Explain Command
          Provide a detailed explanation of the code or concept.
          Usage: /explain [context]
        '';
      };

      rules = "";

      agents = {
        nix-expert = ''
          # Nix Expert Agent
          You are an expert Nix/NixOS developer. Focus on idiomatic Nix code, flake-parts patterns, and efficient module design.
        '';
      };
    };
  };
}
