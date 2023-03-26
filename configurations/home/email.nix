{pkgs, ...}: let
  mailserver = "mail.garudalinux.net";
  key = "D245D484F3578CB17FD6DA6B67DB29BFF3C96757";
in {
  accounts.email = {
    accounts.main = {
      address = "nico@dr460nf1r3.org";
      gpg = {
        key = key;
        signByDefault = true;
      };
      imap = {
        host = mailserver;
        port = 993;
      };
      primary = true;
      realName = "Nico Jensch";
      signature = {
        text = ''
          Sent from NixOS
        '';
        showSignature = "append";
      };
      passwordCommand = "secret-tool lookup email nico@dr460nf1r3.org";
      thunderbird.enable = true;
      smtp = {
        host = mailserver;
      };
      userName = "nico@dr460nf1r3.org";
    };
    accounts.garuda-personal = {
      address = "dr460nf1r3@garudalinux.org";
      gpg = {
        key = key;
        signByDefault = true;
      };
      imap = {
        host = mailserver;
        port = 993;
      };
      realName = "Nico (dr460nf1r3)";
      thunderbird.enable = true;
      signature = {
        text = ''
          Sent from NixOS
        '';
        showSignature = "append";
      };
      passwordCommand = "secret-tool lookup email dr460nf1r3@garudalinux.org";
      smtp = {
        host = mailserver;
      };
      userName = "dr460nf1r3@garudalinux.org";
    };
    accounts.garuda-team = {
      address = "team@garudalinux.org";
      gpg = {
        key = key;
        signByDefault = true;
      };
      imap = {
        host = mailserver;
        port = 993;
      };
      realName = "Garuda Team";
      signature = {
        text = ''
          Sent from NixOS
        '';
        showSignature = "append";
      };
      passwordCommand = "secret-tool lookup email team@garudalinux.org";
      thunderbird.enable = true;
      smtp = {
        host = mailserver;
      };
      userName = "team@garudalinux.org";
    };
  };
}
