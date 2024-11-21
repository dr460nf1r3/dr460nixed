{config, ...}: {
  services.nginx = {
    virtualHosts = {
      "reddit.dr460nf1r3.org" = {
        forceSSL = true;
        http3 = true;
        http3_hq = true;
        kTLS = true;
        locations."/".proxyPass = "http://localhost:${toString config.services.redlib.port}";
        quic = true;
        useACMEHost = "dr460nf1r3.org";
      };
    };
  };

  services.redlib = {
    address = "127.0.0.1";
    enable = true;
    port = 8081;
  };
}
