{ pkgs, ... }: {
  # List the packages I need for school but nowhere else
  environment.systemPackages = with pkgs; [
    speedcrunch
    teams-for-linux
    virt-manager
  ];
}
