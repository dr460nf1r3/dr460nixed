{ pkgs, ... }: {
  # Disable coredumps
  systemd.coredump.enable = false;

  # Disable root login & password authentication on sshd
  services.openssh = {
    extraConfig = ''
      ChallengeResponseAuthentication no
      ClientAliveInterval 600
      LoginGraceTime 15
      MaxStartups 30:30:60
      Protocol 2
    '';
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
    };
  };

  # The hardening profile enables Apparmor by default, we don't want this to happen
  security.apparmor.enable = false;

  # Enable Firejail - currently disabled
  programs.firejail.enable = true;

  # Timeout TTY after 1 hour
  programs.bash.interactiveShellInit = "if [[ $(tty) =~ /dev\\/tty[1-6] ]]; then TMOUT=3600; fi";

  # Don't lock kernel modules, this is also enabled by the hardening profile by default
  security.lockKernelModules = false;

  # Run security analysis
  environment.systemPackages = with pkgs; [ lynis ];

  # Prevent TOFU MITM
  programs.ssh.knownHosts = {
    github-rsa.hostNames = [ "github.com" ];
    github-rsa.publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAq2A7hRGmdnm9tUDbO9IDSwBK6TbQa+PXYPCPy6rbTrTtw7PHkccKrpp0yVhp5HdEIcKr6pLlVDBfOLX9QUsyCOV0wzfjIJNlGEYsdlLJizHhbn2mUjvSAHQqZETYP81eFzLQNnPHt4EVVUh7VfDESU84KezmD5QlWpXLmvU31/yMf+Se8xhHTvKSCZIFImWwoG6mbUoWf9nzpIoaSjB+weqqUUmpaaasXVal72J+UX2B+2RPW3RcT0eOzQgqlJL3RKrTJvdsjE3JEAvGq3lGHSZXy28G3skua2SmVi/w4yCE6gbODqnTWlg7+wC604ydGXA8VJiS5ap43JXiUFFAaQ==";
    github-ed25519.hostNames = [ "github.com" ];
    github-ed25519.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOMqqnkVzrm0SdG6UOoqKLsabgH5C9okWi0dh2l9GKJl";

    gitlab-rsa.hostNames = [ "gitlab.com" ];
    gitlab-rsa.publicKey = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCsj2bNKTBSpIYDEGk9KxsGh3mySTRgMtXL583qmBpzeQ+jqCMRgBqB98u3z++J1sKlXHWfM9dyhSevkMwSbhoR8XIq/U0tCNyokEi/ueaBMCvbcTHhO7FcwzY92WK4Yt0aGROY5qX2UKSeOvuP4D6TPqKF1onrSzH9bx9XUf2lEdWT/ia1NEKjunUqu1xOB/StKDHMoX4/OKyIzuS0q/T1zOATthvasJFoPrAjkohTyaDUz2LN5JoH839hViyEG82yB+MjcFV5MU3N1l1QL3cVUCh93xSaua1N85qivl+siMkPGbO5xR/En4iEY6K2XPASUEMaieWVNTRCtJ4S8H+9";
    gitlab-ed25519.hostNames = [ "gitlab.com" ];
    gitlab-ed25519.publicKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAfuCHKVTjquxvt6CM6tdG4SLp1Btn/nOeHHE5UOzRdf";
  };
}
