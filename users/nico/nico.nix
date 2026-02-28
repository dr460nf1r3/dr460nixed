{ lib, dr460nixedUserConfig, ... }:
let
  userCfg = dr460nixedUserConfig.nico or { };
in
{
  imports = [
    ./email.nix
    ../../home-manager/default.nix
  ];

  dr460nixed.hm = {
    development.enable = true;
    email.enable = true;
    shell.enable = true;
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
