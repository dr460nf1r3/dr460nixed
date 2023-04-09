{ ... }: {
  # Basic chromium settings (system-wide)
  programs.chromium = {
    defaultSearchProviderEnabled = true;
    defaultSearchProviderSearchURL = "https://search.dr460nf1r3.org/search?q=%s";
    defaultSearchProviderSuggestURL = "https://search.dr460nf1r3.org/autocomplete?q=%s";
    enable = true;
    extensions = [
      "ajhmfdgkijocedmfjonnpjfojldioehi" # Privacy Pass
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" # uBlock origin
      "hipekcciheckooncpjeljhnekcoolahp" # Tabliss
      "kbfnbcaeplbcioakkpcpgfkobkghlhen" # Grammarly
      "mdjildafknihdffpkfmmpnpoiajfjnjd" # Consent-O-Matic
      "mnjggcdmjocbbbhaepdhchncahnbgone" # SponsorBlock
      "njdfdhgcmkocbgbhcioffdbicglldapd" # LocalCDN
      "nngceckbapebfimnlniiiahkandclblb" # Bitwarden
    ];
    extraOpts = {
      "HomepageLocation" = "https://search.dr460nf1r3.org";
      "QuicAllowed" = true;
      "RestoreOnStartup" = true;
      "ShowHomeButton" = true;
    };
  };

  # SUID Sandbox
  security.chromiumSuidSandbox.enable = true;
}
