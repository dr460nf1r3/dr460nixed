{
  services.code-server = {
    auth = "none";
    enable = true;
    extraArguments = [
      "--disable-telemetry"
      "--proxy-domain=code.dr460nf1r3.org"
    ];
    host = "127.0.0.1";
    port = 4444;
    user = "nico";
  };

  # Set the extensions gallery to the Visual Studio Marketplace
  environment.sessionVariables = {
    EXTENSIONS_GALLERY = "https://marketplace.visualstudio.com/_apis/public/gallery";
  };
}
