.PHONY: help build run clean update check

# Default target
help:
	@echo "NixOS OpenClaw VM - Available targets:"
	@echo "  make build      - Build the VM image"
	@echo "  make run        - Run the VM locally"
	@echo "  make clean      - Clean build artifacts"
	@echo "  make update     - Update flake dependencies"
	@echo "  make check      - Check flake configuration"
	@echo "  make qcow       - Build QCOW2 image for GNOME Boxes"

# Build the VM
build:
	@echo "Building NixOS OpenClaw VM..."
	nix build .#nixosConfigurations.openclaw-vm.config.system.build.toplevel -L

# Run the VM
run:
	@echo "Running VM..."
	@./run-vm.sh

# Build QCOW2 image
qcow:
	@echo "Building QCOW2 image..."
	nix build .#nixosConfigurations.openclaw-vm.config.system.build.qcow -L

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	rm -rf result result-* *.qcow2 *.img

# Update flake dependencies
update:
	@echo "Updating flake inputs..."
	nix flake update

# Check flake configuration
check:
	@echo "Checking flake configuration..."
	nix flake check
