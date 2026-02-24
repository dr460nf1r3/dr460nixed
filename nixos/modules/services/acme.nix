{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.services.nginx.enable {
    # SSL certs for the server
    security.acme = {
      acceptTerms = true;
      defaults = {
        group = "nginx";
        email = "root@dr460nf1r3.org";
      };
    };

    sops.secrets."api_keys/cloudflare" = {
      mode = "0400";
      owner = "acme";
      path = "/run/secrets/api_keys/cloudflare";
    };
  };
}
