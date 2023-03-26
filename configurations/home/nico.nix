{...}: {
  # Import individual configuration snippets
  imports = [./shells.nix];

  # Always needed home-manager settings - don't touch!
  home.homeDirectory = "/home/nico";
  home.stateVersion = "22.11";
  home.username = "nico";

  # I'm working with git a lot
  programs.git = {
    enable = true;
    extraConfig = {
      core = {editor = "micro";};
      init = {defaultBranch = "main";};
      pull = {rebase = true;};
    };
    signing = {
      key = "D245D484F3578CB17FD6DA6B67DB29BFF3C96757";
      signByDefault = true;
    };
    userEmail = "root@dr460nf1r3.org";
    userName = "Nico Jensch";
  };

  # GPG for signing commits mostly
  programs.gpg = {
    enable = true;
    settings = {
      cert-digest-algo = "SHA512";
      charset = "utf-8";
      default-preference-list = "SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed";
      fixed-list-mode = true;
      keyid-format = "0xlong";
      list-options = "show-uid-validity";
      no-comments = true;
      no-emit-version = true;
      no-greeting = true;
      no-symkey-cache = true;
      personal-cipher-preferences = "AES256 AES192 AES";
      personal-compress-preferences = "ZLIB BZIP2 ZIP Uncompressed";
      personal-digest-preferences = "SHA512 SHA384 SHA256";
      require-cross-certification = true;
      s2k-cipher-algo = "AES256";
      s2k-digest-algo = "SHA512";
      throw-keyids = true;
      verify-options = "show-uid-validity";
      with-fingerprint = true;
    };
  };

  # Enable dircolors
  programs.dircolors.enable = true;

  # Show home-manager news
  news.display = "notify";

  # Disable manpages
  manual.manpages.enable = false;
}
