#!/usr/bin/env bash

# Build script for NixOS OpenClaw VM
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

NIX_FLAGS=(--extra-experimental-features "nix-command flakes" --accept-flake-config)
CI_MODE="${CI:-}"

echo "Building NixOS OpenClaw VM..."

# Check if Nix is installed
if ! command -v nix &> /dev/null; then
    echo "Error: Nix is not installed. Please install Nix first:"
    echo "  curl -L https://nixos.org/nix/install | sh"
    exit 1
fi

# Ensure flake.lock exists for reproducible builds.
# In local/dev runs, generate it if missing.
# In CI, require it to be present and committed.
if [[ ! -f flake.lock ]]; then
    if [[ -n "$CI_MODE" ]]; then
        echo "Error: flake.lock is missing in CI. Commit flake.lock before running CI builds."
        exit 1
    fi

    echo "flake.lock not found. Generating lock file for local build..."
    nix "${NIX_FLAGS[@]}" flake lock
fi

# Build the VM configuration
echo "Building VM toplevel configuration..."
nix "${NIX_FLAGS[@]}" build .#nixosConfigurations.openclaw-vm.config.system.build.toplevel -L --no-write-lock-file

# Build QCOW2 image for gnome-boxes
echo "Building QCOW2 image..."
nix "${NIX_FLAGS[@]}" build .#nixosConfigurations.openclaw-vm.config.system.build.qcow -L --no-write-lock-file || {
    echo "Warning: QCOW2 build failed, but toplevel succeeded."
    echo "You can still run the VM using the run-vm.sh script."
}

echo ""
echo "Build complete!"
echo ""
echo "To run the VM:"
echo "  ./run-vm.sh"
echo ""
echo "To import into gnome-boxes:"
echo "  If QCOW2 was built successfully, import result-qcow/nixos.qcow2"
echo ""
