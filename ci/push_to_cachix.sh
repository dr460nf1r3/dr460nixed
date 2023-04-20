#!/usr/bin/env bash
set -euo pipefail

TARGETS_X86=("main" "tv")
TARGETS_AARCH64=("oracle" "rpi")

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
    echo "Started building variation $system ❄️!"
    echo ""
    nix develop -c colmena build --on "@$system"
    echo ""
    echo "Done building variation $system ❄️!"
    echo ""
done
