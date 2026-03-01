_:
let
  mailserver = "mail.garudalinux.net";
  mailserverNws = "mail.nextweb-software.com";

  mkAccount =
    {
      address,
      realName,
      gpgKey ? null,
      primary ? false,
      server ? mailserver,
    }:
    let
      base = {
        inherit address;
        inherit realName;
        imap = {
          host = server;
          port = 993;
        };
        smtp = {
          host = server;
          port = 465;
        };
        thunderbird.enable = true;
        userName = address;
        inherit primary;
      };
    in
    if gpgKey != null then
      base
      // {
        gpg = {
          key = gpgKey;
          signByDefault = true;
        };
      }
    else
      base;

in
{
  accounts.email = {
    accounts.garuda-personal = mkAccount {
      primary = true;
      address = "dr460nf1r3@garudalinux.org";
      realName = "Nico (dr460nf1r3)";
    };

    accounts.garuda-team = mkAccount {
      address = "team@garudalinux.org";
      realName = "Garuda Team";
    };

    accounts.chaotic-personal = mkAccount {
      address = "dr460nf1r3@chaotic.cx";
      realName = "Nico (dr460nf1r3)";
    };

    accounts.chaotic-h = mkAccount {
      address = "h@chaotic.cx";
      realName = "Nico (dr460nf1r3)";
    };

    accounts.nws = mkAccount {
      address = "n.jensch@nextweb-software.com";
      realName = "Nico Jensch";
      server = mailserverNws;
    };
  };
}
