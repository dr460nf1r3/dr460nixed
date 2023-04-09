{ pkgs, ... }: {
  # Create system-wide executables firefox and chromium
  programs.firejail.wrappedBinaries = {
    firefox = {
      executable = "${pkgs.lib.getBin pkgs.firefox}/bin/firefox";
      profile = "${pkgs.firejail}/etc/firejail/firefox.profile";
      extraArgs = [
        "--ignore=private-dev"
        "--env=GTK_THEME=Sweet-dark:dark"
        "--dbus-user.talk=org.freedesktop.Notifications"
      ];
    };
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
