{
  lib,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  options.dr460nixed.hm.user = {
    enable = mkOption {
      type = types.bool;
      default = false;
      description = "Enable user-specific home-manager configuration";
    };

    name = mkOption {
      type = types.str;
      default = "";
      description = "User's real name for git and email";
    };

    email = mkOption {
      type = types.str;
      default = "";
      description = "User's primary email address";
    };

    username = mkOption {
      type = types.str;
      default = "";
      description = "Username (for shell aliases, etc.)";
    };

    signingKey = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "GPG signing key for git";
    };

    stateVersion = mkOption {
      type = types.str;
      default = "26.05";
      description = "Home-manager state version";
    };

    shellAliases = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Shell aliases to set for the user";
    };

    fishAbbreviations = mkOption {
      type = types.attrsOf types.str;
      default = { };
      description = "Fish shell abbreviations";
    };

    gpgKey = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "GPG key for email encryption";
    };
  };
}
