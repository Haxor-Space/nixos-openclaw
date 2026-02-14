#!/usr/bin/env bash

# Build script for NixOS OpenClaw VM
set -e

echo "Building NixOS OpenClaw VM..."

# Check if Nix is installed
if ! command -v nix &> /dev/null; then
    echo "Error: Nix is not installed. Please install Nix first:"
    echo "  curl -L https://nixos.org/nix/install | sh"
    exit 1
fi

# Check if flakes are enabled
if ! nix eval --help | grep -q "experimental"; then
    echo "Note: Experimental features may need to be enabled."
    echo "Run: nix --experimental-features 'nix-command flakes' build"
fi

# Build the VM configuration
echo "Building VM toplevel configuration..."
nix build .#nixosConfigurations.openclaw-vm.config.system.build.toplevel -L --no-write-lock-file

# Build QCOW2 image for gnome-boxes
echo "Building QCOW2 image..."
nix build .#nixosConfigurations.openclaw-vm.config.system.build.qcow -L --no-write-lock-file || {
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
