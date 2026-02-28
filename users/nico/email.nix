_:
let
  mailserver = "mail.garudalinux.net";

  mkAccount =
    {
      address,
      realName,
      gpgKey ? null,
      primary ? false,
    }:
    let
      base = {
        inherit address;
        inherit realName;
        imap = {
          host = mailserver;
          port = 993;
        };
        smtp = {
          host = mailserver;
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
  };
}
