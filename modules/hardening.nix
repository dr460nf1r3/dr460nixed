{ config
, lib
, pkgs
, ...
}:
with lib;
let
  cfg = config.dr460nixed.hardening;
  cfgDesktops = config.dr460nixed.desktops.enable;
  cfgServers = config.dr460nixed.servers.enable;
in
{
  options.dr460nixed.hardening = {
    enable = mkOption
      {
        default = true;
        type = types.bool;
        description = mdDoc ''
          Whether the operating system should be hardened.
        '';
      };
  };

  config = mkIf cfg.enable {
    boot.kernel.sysctl = {
      # The Magic SysRq key is a key combo that allows users connected to the
      # system console of a Linux kernel to perform some low-level commands.
      # Disable it, since we don't need it, and is a potential security concern.
      "kernel.sysrq" = 0;
      # Restrict ptrace() usage to processes with a pre-defined relationship
      # (e.g., parent/child)
      "kernel.yama.ptrace_scope" = 2;
      # Hide kptrs even for processes with CAP_SYSLOG
      "kernel.kptr_restrict" = 2;
      # Disable ftrace debugging
      "kernel.ftrace_enabled" = false;
    };

    boot.blacklistedKernelModules = [
      # Obscure network protocols
      "ax25"
      "netrom"
      "rose"
      # Old or rare or insufficiently audited filesystems
      "adfs"
      "affs"
      "befs"
      "bfs"
      "btusb"
      "cifs"
      "cramfs"
      "cramfs"
      "efs"
      "erofs"
      "exofs"
      "f2fs"
      "freevxfs"
      "freevxfs"
      "gfs2"
      "hfs"
      "hfsplus"
      "hpfs"
      "jffs2"
      "jfs"
      "ksmbd"
      "minix"
      "nfs"
      "nfsv3"
      "nfsv4"
      "nilfs2"
      "omfs"
      "qnx4"
      "qnx6"
      "sysv"
      "udf"
      "vivid"
    ];

    # Disable coredumps
    systemd.coredump.enable = false;

    # Disable root login & password authentication on sshd
    # also, apply recommendations of ssh-audit.com
    services.openssh = mkDefault {
      extraConfig = ''
        ChallengeResponseAuthentication no
        HostKeyAlgorithms ssh-ed25519,ssh-ed25519-cert-v01@openssh.com,sk-ssh-ed25519@openssh.com,sk-ssh-ed25519-cert-v01@openssh.com,rsa-sha2-256,rsa-sha2-512,rsa-sha2-256-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com
      '';
      settings = {
        Ciphers = [
          "aes128-ctr"
          "aes128-gcm@openssh.com"
          "aes256-ctr,aes192-ctr"
          "aes256-gcm@openssh.com"
          "chacha20-poly1305@openssh.com"
        ];
        KexAlgorithms = [
          "curve25519-sha256"
          "curve25519-sha256@libssh.org"
          "diffie-hellman-group-exchange-sha256"
          "diffie-hellman-group14-sha256"
          "diffie-hellman-group16-sha512"
          "diffie-hellman-group18-sha512"
        ];
        Macs = [
          "hmac-sha2-256-etm@openssh.com"
          "hmac-sha2-512-etm@openssh.com"
          "umac-128-etm@openssh.com"
        ];
        PasswordAuthentication = false;
        PermitRootLogin = "no";
        X11Forwarding = false;
        kbdInteractiveAuthentication = false;
        useDns = false;
      };
    };

    # The hardening profile enables Apparmor by default, we don't want this to happen
    security.apparmor.enable = false;

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

    # Enable Firejail
    programs.firejail = mkIf cfgDesktops {
      enable = true;
      wrappedBinaries = {
        chromium = {
          executable = "${pkgs.chromium-flagged}/bin/chromium";
          profile = "${pkgs.firejail}/etc/firejail/chromium.profile";
          extraArgs = [
            "--dbus-user.talk=org.freedesktop.Notifications"
            "--env=GTK_THEME=Sweet-dark:dark"
            "--ignore=private-dev"
          ];
        };
      };
    };

    # Technically we don't need this as we use pubkey authentication
    services.fail2ban = mkIf cfgServers {
      enable = true;
      ignoreIP = [
        "100.0.0.0/8"
        "127.0.0.1/8"
      ];
    };
  };
}
