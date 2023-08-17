#!/usr/bin/env bash
set -euo pipefail

# Explicitly allow aarch64 builds
export NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM=1

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
PATH=$(build_system live-usb install-iso | grep dr460nixed-live.iso/iso/dr460nixed-live.iso)
cp "$PATH" .
