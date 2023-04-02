{
  # Import the Chaotic module
  imports = [./chaotic/chaotic.nix];

  # Enable Chaotic-AUR building
  services.chaotic.enable = true;
  services.chaotic.cluster-name = "dragons-ryzen";
  services.chaotic.extraConfig = ''
    export CAUR_SIGN_KEY=BF773B6877808D28
    export CAUR_SIGN_USER=root
    export CAUR_PACKAGER="Nico Jensch <dr460nf1r3@chaotic.cx>"
    export CAUR_TYPE=cluster
    export CAUR_URL="https://builds.garudalinux.org/repos/chaotic-aur/x86_64"

    export CAUR_DEPLOY_LABEL="Dragons Ryzen 🐉"
    export CAUR_TELEGRAM_TAG="@dr460nf1r3"

    export CAUR_REPOCTL_DB_URL=https://builds.garudalinux.org/repos/chaotic-aur/x86_64/chaotic-aur.db.tar.zst
    export CAUR_REPOCTL_DB_FILE=/tmp/chaotic/db.tar.zst
    export REPOCTL_CONFIG=/etc/xdg/repoctl/config_auto.toml
    export CAUR_DEPLOY_HOST="dragons-ryzen@builds.garudalinux.org"
  '';
  services.chaotic.db-name = "chaotic-aur";
  services.chaotic.cluster = true;

  # Let my user build packages
  users.users.nico = {
    extraGroups = ["chaotic-op"];
  };
}
