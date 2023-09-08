{ pkgs, ... }: {
  services.searx = {
    enable = true;
    package = pkgs.searxng;
    settings = {
      server.bind_address = "0.0.0.0";
      server.default_theme = "simple";
      server.secret_key = "thisisasupersecretkeylol";
    };
  };
}
