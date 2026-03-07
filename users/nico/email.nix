_:
let
  mailserver = "mail.garudalinux.net";
  mailserverNws = "mail.nextweb-software.com";
  mailserverProtonBridge = "100.100.1.12";

  mkAccount =
    {
      address,
      realName,
      gpgKey ? null,
      primary ? false,
      server ? mailserver,
      imapPort ? 993,
      smtpPort ? 465,
    }:
    let
      base = {
        inherit address;
        inherit realName;
        imap = {
          host = server;
          port = imapPort;
        };
        smtp = {
          host = server;
          port = smtpPort;
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
    accounts.main = mkAccount {
      primary = true;
      address = "nico@dr460nf1r3.org";
      server = mailserverProtonBridge;
      realName = "Nico Jensch";
      imapPort = 1143;
      smtpPort = 1025;
    };

    accounts.garuda-personal = mkAccount {
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
