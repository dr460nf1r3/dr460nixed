{
  eval = {
    target.args = ["-f" "default.nix"];
  };
  formatting.command = "alejandra";
  options = {
    enable = true;
    target = {
      args = [];
      installable = ".#nixosConfigurations.nixos.options";
    };
  };
}
