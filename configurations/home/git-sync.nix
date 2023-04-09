{ ... }: {
  # Enable the git-sync service
  services.git-sync.enable = true;

  # Chaotic-AUR
  services.git-sync.repositories."chaotic-packages" = {
    interval = 10000;
    path = "/home/nico/Documents/chaotic/packages";
    uri = "git@github.com:chaotic-aur/packages.git";
  };
  services.git-sync.repositories."chaotic-interfere" = {
    interval = 10000;
    path = "/home/nico/Documents/chaotic-aur/interfere";
    uri = "git@github.com:chaotic-aur/packages.git";
  };
  services.git-sync.repositories."chaotic-uptimes" = {
    interval = 10000;
    path = "/home/nico/Documents/chaotic-aur/chaotic-uptimes";
    uri = "git@github.com:chaotic-aur/packages.git";
  };
  services.git-sync.repositories."chaotic-mirrorlist" = {
    interval = 10000;
    path = "/home/nico/Documents/chaotic-aur/chaotic-mirrorlist";
    uri = "git@github.com:chaotic-aur/notes.git";
  };
  services.git-sync.repositories."chaotic-aur.github.io" = {
    interval = 10000;
    path = "/home/nico/Documents/chaotic-aur/chaotic-aur.github.io";
    uri = "git@github.com:chaotic-aur/chaotic-aur.github.io.git";
  };
  services.git-sync.repositories."chaotic-router" = {
    interval = 10000;
    path = "/home/nico/Documents/chaotic-aur/router";
    uri = "git@github.com:chaotic-aur/router.git";
  };
  services.git-sync.repositories."chaotic-toolbox" = {
    interval = 10000;
    path = "/home/nico/Documents/chaotic-aur/toolbox";
    uri = "git@github.com:chaotic-aur/toolbox.git";
  };

  # Garuda Linux
  services.git-sync.repositories."garuda-dr460nized" = {
    interval = 10000;
    path = "/home/nico/Documents/garuda/garuda-dr460nized";
    uri = "git@gitlab.com:garuda-linux/themes-and-settings/settings/garuda-dr460nized.git";
  };
  services.git-sync.repositories."garuda-infra-nix" = {
    interval = 10000;
    path = "/home/nico/Documents/garuda/infra-nix";
    uri = "git@gitlab.com:garuda-linux/infra-nix.git";
  };
  services.git-sync.repositories."garuda-garuda-tools" = {
    interval = 10000;
    path = "/home/nico/Documents/garuda/garuda-tools";
    uri = "git@gitlab.com:garuda-linux/tools/garuda-tools.git";
  };
  services.git-sync.repositories."garuda-iso-profiles" = {
    interval = 10000;
    path = "/home/nico/Documents/garuda/iso-profiles";
    uri = "git@gitlab.com:garuda-linux/tools/iso-profiles.git";
  };
  services.git-sync.repositories."garuda-changelogs" = {
    interval = 10000;
    path = "/home/nico/Documents/garuda/changelogs";
    uri = "git@gitlab.com:garuda-linux/changelogs.git";
  };

  # Misc repos
  services.git-sync.repositories."misc-device-configurations" = {
    interval = 10000;
    path = "/home/nico/Documents/misc/device-configurations";
    uri = "git@github.com:dr460nf1r3/device-configurations.git";
  };
  services.git-sync.repositories."misc-website" = {
    interval = 10000;
    path = "/home/nico/Documents/misc/website";
    uri = "git@github.com:dr460nf1r3/website.git";
  };
  services.git-sync.repositories."misc-dr460nf1r3" = {
    interval = 10000;
    path = "/home/nico/Documents/misc/dr460nf1r3";
    uri = "git@github.com:dr460nf1r3/dr460nf1r3.git";
  };

  # Browser stuff
  services.git-sync.repositories."browser-firedragon-settings" = {
    interval = 10000;
    path = "/home/nico/Documents/browser/firedragon-settings";
    uri = "git@github.com:dr460nf1r3/firedragon-browser.git";
  };
  services.git-sync.repositories."browser-firedragon-common" = {
    interval = 10000;
    path = "/home/nico/Documents/browser/firedragon-common";
    uri = "git@github.com:dr460nf1r3/firedragon-design.git";
  };
  services.git-sync.repositories."browser-firedragon" = {
    interval = 10000;
    path = "/home/nico/Documents/browser/firedragon";
    uri = "ssh://aur@aur.archlinux.org/firedragon.git";
  };
}
