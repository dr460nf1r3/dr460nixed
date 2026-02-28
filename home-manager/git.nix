{
  lib,
  config,
  ...
}:
let
  cfg = config.dr460nixed.hm.git;
  userCfg = config.dr460nixed.hm.user;
in
{
  options.dr460nixed.hm.git = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = userCfg.enable;
      description = "Enable Git configuration";
    };
    userName = lib.mkOption {
      type = lib.types.str;
      default = userCfg.name;
      description = "The name to use for git commits";
    };
    userEmail = lib.mkOption {
      type = lib.types.str;
      default = userCfg.email;
      description = "The email to use for git commits";
    };
    signingKey = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = userCfg.signingKey;
      description = "The GPG key to use for signing commits";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings = {
        user = {
          email = cfg.userEmail;
          name = cfg.userName;
        };
        color.ui = "auto";
        help.autocorrect = 10;
        pull.rebase = true;
        push.autoSetupRemote = true;
      };
      signing = lib.mkIf (cfg.signingKey != null) {
        key = cfg.signingKey;
        signByDefault = true;
      };
    };
    programs.difftastic.enable = true;
  };
}
