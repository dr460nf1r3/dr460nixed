#!/usr/bin/env bash
set -euo pipefail

FLAKE_DIR="$(pwd)"
TARGETS_X86=("tv" "main")
TARGETS_AARCH64=("oracle" "rpi")

# Build every variation of the flake
cd "$FLAKE_DIR"

# Activate devshell
nix develop

# Stolen from https://github.com/easimon/maximize-build-space
# Save about 50GB of space by removing things we don't need anyways
sudo rm -rf /usr/share /usr/local /opt || true

# Determine system architecture
if [[ "$(uname -m)" == "x86_64" ]]; then
    TARGETS=("${TARGETS_X86[@]}")
elif [[ "$(uname -m)" == "aarch64" ]]; then
    TARGETS=("${TARGETS_AARCH64[@]}")
else
    echo "Unsupported architecture: $(uname -m)"
    exit 1
fi

# Build the corresponding system configurations
for system in "${TARGETS[@]}"; do
    colmena build --on "$system"
    echo ""
    echo "Done building variation $system ❄️!"
    echo ""
done
