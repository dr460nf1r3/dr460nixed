{
  config,
  pkgs,
  ...
}: {
  # Enable our own GitHub runner
  services.github-runners.oracle-dragon = {
    enable = true;
    extraLabels = ["aarch64" "oracle"];
    extraPackages = with pkgs; [
      colmena
      nix
    ];
    name = "oracle-dragon";
    tokenFile = config.sops.secrets."api_keys/github-runner".path;
    url = "https://github.com/dr460nf1r3/device-configurations";
    user = "github-runner";
  };

  # The custom GitHub runner group & user
  users.users."github-runner" = {
    group = "github-runner";
    description = "GitHub runner";
    createHome = false;
    isSystemUser = true;
  };
  users.groups.github-runner = {};

  sops.secrets."api_keys/github-runner" = {
    mode = "0600";
    owner = "github-runner";
    path = "/run/secrets/api_keys/github-runner";
  };
}
