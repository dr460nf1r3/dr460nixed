{ lib
, pkgs
, ...
}:
let
  initscript = pkgs.writeShellScript "motdscript" ''
    ${pkgs.fancy-motd}/bin/motd
    echo -e ""
    echo -e "              Welcome to the dragon's infra! 🐉              "
  '';
in
{
  # Add fancy MOTD to shell logins
  environment.interactiveShellInit = "${initscript}";

  # Override init to not show fastfetch
  programs.fish.shellInit = lib.mkForce ''
    set fish_greeting
  '';
}
