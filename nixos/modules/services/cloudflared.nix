{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.services.cloudflared.enable {
    # Make cloudflared happy (https://github.com/lucas-clemente/quic-go/wiki/UDP-Receive-Buffer-Size)
    boot.kernel.sysctl = {
      "net.core.rmem_max" = 7500000;
      "net.core.wmem_max" = 7500000;
    };
  };
}
