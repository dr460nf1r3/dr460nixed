{
  osConfig ? { },
  lib,
  dr460nixedUserConfig,
  ...
}:
let
  userCfg = dr460nixedUserConfig.nico or { };
  isDesktop = osConfig.dr460nixed.desktops.enable or true;
in
{
  imports = [
    ./email.nix
    ../../home-manager/default.nix
  ];

  dr460nixed.hm = {
    development.enable = isDesktop;
    email.enable = isDesktop;
    shell.enable = true;
    kde.enable = isDesktop;
    sync.nextcloud = isDesktop;
    user = lib.mkIf (userCfg.enable or false) {
      enable = true;
      name = userCfg.git.userName;
      email = userCfg.git.userEmail;
      username = "nico";
      inherit (userCfg.git) signingKey;
      inherit (userCfg) stateVersion;
      inherit (userCfg) shellAliases;
      inherit (userCfg) fishAbbreviations;
    };
  };
}
