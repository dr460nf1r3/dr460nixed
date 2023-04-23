_:
let
  template = import ./template.nix "nixos";
in
{
  environment = {
    etc = {
      inherit (template) pythonrc npmrc;
    };
    sessionVariables = template.sysEnv;
    variables = template.glEnv;
  };
}
