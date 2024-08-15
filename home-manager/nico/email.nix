_: let
  mailserver = "mail.garudalinux.net";
in {
  accounts.email = {
    accounts.main = {
      address = "nico@dr460nf1r3.org";
      gpg = {
        key = "0x9F59CE4A11034C67";
        signByDefault = true;
      };
      imap = {
        host = mailserver;
        port = 993;
      };
      primary = true;
      realName = "Nico Jensch";
      thunderbird.enable = true;
      smtp = {
        host = mailserver;
        port = 465;
      };
      userName = "nico@dr460nf1r3.org";
    };
    accounts.garuda-personal = {
      address = "dr460nf1r3@garudalinux.org";
      imap = {
        host = mailserver;
        port = 993;
      };
      realName = "Nico (dr460nf1r3)";
      thunderbird.enable = true;
      smtp = {
        host = mailserver;
        port = 465;
      };
      userName = "dr460nf1r3@garudalinux.org";
    };
    accounts.garuda-team = {
      address = "team@garudalinux.org";
      imap = {
        host = mailserver;
        port = 993;
      };
      realName = "Garuda Team";
      thunderbird.enable = true;
      smtp = {
        host = mailserver;
        port = 465;
      };
      userName = "team@garudalinux.org";
    };
  };
}
