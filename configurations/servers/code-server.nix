{pkgs, ...}: {
  services.code-server = {
    auth = "none";
    enable = true;
    extraPackages = with pkgs; [
      alejandra
      ansible
      bash
      bind.dnsutils
      code-server
      fish
      git
      heroku
      hugo
      nixos-generators
      nodejs
      nur.repos.yes.archlinux.asp
      nur.repos.yes.archlinux.devtools
      nur.repos.yes.archlinux.paru
      python3
      shellcheck
      shfmt
      yarn
    ];
    extraArguments = [
      "--disable-telemetry"
      "--proxy-domain=code.dr460nf1r3.org"
    ];
    #hashedPassword = "";
    host = "127.0.0.1";
    port = 4444;
    user = "nico";
  };

  # Set the extensions gallery to the Visual Studio Marketplace
  environment.sessionVariables = {
    EXTENSIONS_GALLERY = "https://marketplace.visualstudio.com/_apis/public/gallery";
  };
}
