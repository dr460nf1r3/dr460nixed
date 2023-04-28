{
  imports = [
    ./users.nix
    ../../overlays/default.nix
  ];

  # This is the default sops file that will be used for all secrets
  sops = {
    age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
    defaultSopsFile = ../../secrets/global.yaml;
  };
}
