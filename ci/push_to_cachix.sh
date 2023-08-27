#!/usr/bin/env bash
set -euo pipefail

FLAKE_DIR="$(pwd)"
TARGETS_X86=("dragons-ryzen" "tv-nixos")
TARGETS_AARCH64=("oracle-dragon" "rpi-dragon")

# Build every variation of the flake
cd "$FLAKE_DIR"

# Determine system architecture
if [[ "$1" == "x86_64" ]]; then
    TARGETS=("${TARGETS_X86[@]}")
elif [[ "$1" == "aarch64" ]]; then
    TARGETS=("${TARGETS_AARCH64[@]}")
else
    echo "Unsupported architecture: $(uname -m)"
    exit 1
fi

# Build the corresponding system configurations
for system in "${TARGETS[@]}"; do
    echo "Started building variation $system ❄️!"
    echo ""
    nix build -L ".#nixosConfigurations.$system.config.system.build.toplevel"
    echo ""
    echo "Done building variation $system ❄️!"
    echo ""
done
