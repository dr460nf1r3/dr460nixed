{ config
, pkgs
, ...
}: {
  # Enable our own GitHub runner
  services.github-runners.oracle-dragon = {
    enable = true;
    extraLabels = [ "aarch64" "oracle" ];
    extraPackages = with pkgs; [
      nix
    ];
    name = "oracle-dragon";
    tokenFile = config.sops.secrets."api_keys/github_runner".path;
    url = "https://github.com/dr460nf1r3/dr460nixed";
    user = "github-runner";
  };

  # The custom GitHub runner group & user
  users.users."github-runner" = {
    group = "github-runner";
    description = "GitHub runner";
    createHome = false;
    isSystemUser = true;
  };
  users.groups.github-runner = { };

  sops.secrets."api_keys/github_runner" = {
    mode = "0600";
    owner = "github-runner";
    path = "/run/secrets/api_keys/github_runner";
  };

  # Needed to allow GitHub runner
  nixpkgs.config.permittedInsecurePackages = [ "nodejs-16.20.2" ];
}
