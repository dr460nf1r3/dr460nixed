{ lib
, pkgs
, ...
}:
with lib;
{
  # Basic chromium settings (system-wide)
  programs.chromium = {
    defaultSearchProviderEnabled = true;
    defaultSearchProviderSearchURL = "https://searx.dr460nf1r3.org/search?q=%s";
    defaultSearchProviderSuggestURL = "https://searx.dr460nf1r3.org/autocomplete?q=%s";
    enable = true;
    extensions = [
      "ajhmfdgkijocedmfjonnpjfojldioehi" # Privacy Pass
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock origin
      "doojmbjmlfjjnbmnoijecmcbfeoakpjm" # NoScript
      "edibdbjcniadpccecjdfdjjppcpchdlm" # I Still Don't Care About Cookies
      "fhnegjjodccfaliddboelcleikbmapik" # Tab Counter
      "hipekcciheckooncpjeljhnekcoolahp" # Tabliss
      "kbfnbcaeplbcioakkpcpgfkobkghlhen" # Grammarly
      "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
      "oladmjdebphlnjjcnomfhhbfdldiimaf;https://raw.githubusercontent.com/libredirect/libredirect/master/src/updates/updates.xml" # Libredirect
    ];
    extraOpts = {
      "HomepageLocation" = "https://searx.dr460nf1r3.org";
      "QuicAllowed" = true;
      "RestoreOnStartup" = true;
      "ShowHomeButton" = true;
    };
  };

  # These are the GUI packages I always need
  environment.systemPackages = with pkgs; [
    chromium
    gparted
    hexedit
    speedcrunch
    tdesktop
    tor-browser-bundle-bin
    yubikey-manager-qt
    yubioath-flutter
  ];
}
