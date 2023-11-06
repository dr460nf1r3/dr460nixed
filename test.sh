TEST=$(nix run nixpkgs#commitizen -- changelog --dry-run)
git add .
git commit -m "fix: test" -m "$TEST"
