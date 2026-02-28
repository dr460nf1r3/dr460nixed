{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.services.nginx.enable {
    security.acme = {
      acceptTerms = true;
      defaults = {
        group = "nginx";
        email = "root@dr460nf1r3.org";
      };
    };
  };
}
