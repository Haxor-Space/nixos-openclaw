#!/usr/bin/env bash

# Run the NixOS OpenClaw VM
set -e

echo "Starting NixOS OpenClaw VM..."

# Check if the VM has been built
if [ ! -e result ]; then
    echo "VM not built yet. Building now..."
    ./build-vm.sh
fi

# Run the VM
echo "Launching VM..."
echo "Note: Use Ctrl+Alt+G to release mouse/keyboard from VM"
echo ""

# Run with specific memory and display settings
QEMU_OPTS="-m 4096 -smp 2 -vga virtio -display gtk,gl=on" \
  result/bin/run-openclaw-vm-vm

echo "VM exited."
