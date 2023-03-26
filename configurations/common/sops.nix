{sops-nix, ...}: {
  # This is the default sops file that will be used for all secrets
  sops.defaultSopsFile = ../../secrets/global.yaml;
}
