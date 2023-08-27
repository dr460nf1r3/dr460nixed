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
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions;
        [
          b4dm4n.vscode-nixpkgs-fmt
          bbenoist.nix
          eamodio.gitlens
          esbenp.prettier-vscode
          foxundermoon.shell-format
          github.codespaces
          github.copilot
          github.vscode-github-actions
          github.vscode-pull-request-github
          jnoortheen.nix-ide
          ms-azuretools.vscode-docker
          # ms-python.python - https://github.com/NixOS/nixpkgs/issues/251045
          ms-python.vscode-pylance
          ms-vscode-remote.remote-ssh
          ms-vscode.hexeditor
          ms-vsliveshare.vsliveshare
          njpwerner.autodocstring
          pkief.material-icon-theme
          redhat.vscode-xml
          redhat.vscode-yaml
          timonwong.shellcheck
          tyriar.sort-lines
        ]
        ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
          {
            name = "sweet-vscode";
            publisher = "eliverlara";
            sha256 = "sha256-kJgqMEJHyYF3GDxe1rnpTEmbfJE01tyyOFjRUp4SOds=";
            version = "1.1.1";
          }
          {
            name = "ruff";
            publisher = "charliermarsh";
            sha256 = "sha256-Qu7olXmRw+uSFbvGoLkUlR/6nHgMMfg5g+ePINjPcYQ=";
            version = "2023.32.0";
          }
          {
            # Available in nixpkgs, but outdated (0.4.0) at the time of adding
            name = "vscode-tailscale";
            publisher = "tailscale";
            sha256 = "sha256-bdCQvD3tKYQGDCo4N06VwKwKhJQARWfnnsnbM6FynnE=";
            version = "0.6.1";
          }
        ];
    })
  ];
}
