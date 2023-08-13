#!/usr/bin/env bash
set -euo pipefail

# Build functions
build_system() {
    echo Started building variation "$1" ❄️!
    echo Running with flake="$1", format="$2"...
    echo
    nix run nixpkgs#nixos-generators -- --format "$2" --flake .#"$1"
    echo 
    echo Done building variation "$1" ❄️!
    echo 
}

# Build the corresponding system configurations
#build_system live-usb install-iso
build_system rpiImage sd-aarch64
