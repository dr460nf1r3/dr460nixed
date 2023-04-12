{ pkgs, ... }: {
  # Create system-wide executables firefox and chromium
  programs.firejail.wrappedBinaries = {
    chromium = {
      executable = "${pkgs.lib.getBin pkgs.chromium}/bin/chromium";
      profile = "${pkgs.firejail}/etc/firejail/chromium.profile";
      extraArgs = [
        "--ignore=private-dev"
        "--env=GTK_THEME=Sweet-dark:dark"
        "--dbus-user.talk=org.freedesktop.Notifications"
      ];
    };
  };
}
