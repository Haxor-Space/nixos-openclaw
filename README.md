# NixOS OpenClaw AI VM

A NixOS virtual machine configuration with the OpenClaw AI chatbot gateway pre-installed, designed to run in GNOME Boxes or any QEMU-compatible virtualization platform.

## Overview

This repository provides a complete NixOS configuration that includes:

- **OpenClaw AI** - The OpenClaw chatbot gateway and tools (via nix-openclaw)
- **GNOME Desktop Environment** - Full desktop experience with GNOME
- **Chromium Browser** - For web browsing
- **Essential utilities** - vim, git, htop, and more

## Prerequisites

- **Nix package manager** with flakes support
  - Install: `curl -L https://nixos.org/nix/install | sh`
  - Enable flakes: Add `experimental-features = nix-command flakes` to `~/.config/nix/nix.conf`

OR

- **NixOS system** (if building on NixOS directly)

## Quick Start

### Building the VM

```bash
# Make build script executable (if not already)
chmod +x build-vm.sh

# Generate lock file once (commit this file)
nix flake update

# Build the VM image
./build-vm.sh
```

Builds use `--no-write-lock-file`, so `flake.lock` must exist and be committed.

### Running the VM Locally

```bash
# Run the VM with QEMU
./run-vm.sh
```

**Note:** Use `Ctrl+Alt+G` to release mouse/keyboard from the VM window.

### Importing into GNOME Boxes

1. Build the QCOW2 image: `nix build .#nixosConfigurations.openclaw-vm.config.system.build.qcow`
2. Open GNOME Boxes
3. Click the "+" button to create a new box
4. Select "Import a machine" or "Create from file"
5. Navigate to `result-qcow/nixos.qcow2`
6. Follow the import wizard

## VM Configuration

### Default Credentials

- **Username:** `openclaw`
- **Password:** `openclaw`

**Important:** Change the default password after first login!

### System Specifications

- **RAM:** 4GB (configurable in `configuration.nix`)
- **CPU Cores:** 2 (configurable in `configuration.nix`)
- **Desktop:** GNOME with GDM display manager
- **Auto-login:** Enabled for convenience

### Installed Software

- OpenClaw AI chatbot (gateway + tools)
- Chromium web browser
- GNOME desktop and applications
- Basic utilities (vim, wget, curl, git, htop)
- SSH server (enabled, password authentication allowed)

## Building via CI/CD

This repository includes a GitHub Actions workflow that automatically builds the VM image on every push.

### Workflow Features

- Builds on every push to main/master branches and PRs
- Uses Nix with flakes support
- Optional Cachix integration for faster builds
- Uploads VM artifacts for main/master branch builds
- Can be manually triggered via workflow_dispatch

### Setting up Cachix (Optional)

To speed up builds with caching:

1. Create a cache at [cachix.org](https://cachix.org)
2. Add `CACHIX_AUTH_TOKEN` to repository secrets
3. Update the cache name in `.github/workflows/build-vm.yml`

## Customization

### Adding More Packages

Edit `configuration.nix` and add packages to the `environment.systemPackages` list:

```nix
environment.systemPackages = with pkgs; [
  openclaw
  chromium
  # Add your packages here
  firefox
  libreoffice
];
```

### Configuring OpenClaw AI

Edit `configuration.nix` and set your gateway token plus a channel provider:

```nix
programs.openclaw.config = {
  gateway = {
    mode = "local";
    auth = { token = "REPLACE_ME"; };
  };
  channels.telegram = {
    tokenFile = "/var/lib/openclaw/secrets/telegram-token";
    allowFrom = [ 12345678 ];
  };
};
```

Then rebuild and restart the service:

```bash
systemctl --user restart openclaw-gateway
```

### Changing VM Resources

Edit the `virtualisation.vmVariant` section in `configuration.nix`:

```nix
virtualisation.vmVariant = {
  virtualisation.memorySize = 8192;  # 8GB RAM
  virtualisation.cores = 4;           # 4 CPU cores
};
```

### Disabling Auto-login

Edit `configuration.nix` and remove or comment out:

```nix
services.displayManager.autoLogin = {
  enable = true;
  user = "openclaw";
};
```

## Manual Build Commands

### Build VM configuration only

```bash
nix build .#nixosConfigurations.openclaw-vm.config.system.build.toplevel
```

### Build QCOW2 image

```bash
nix build .#nixosConfigurations.openclaw-vm.config.system.build.qcow
```

### Build and run VM

```bash
nix run .#nixosConfigurations.openclaw-vm.config.system.build.vm
```

## File Structure

```
.
├── flake.nix                  # Nix flake configuration
├── configuration.nix          # NixOS system configuration
├── hardware-configuration.nix # VM hardware configuration
├── build-vm.sh               # Build script
├── run-vm.sh                 # VM run script
├── .github/workflows/        # GitHub Actions workflows
│   └── build-vm.yml         # VM build workflow
└── README.md                 # This file
```

## Troubleshooting

### Build Errors

If you encounter build errors:

1. Ensure Nix is properly installed: `nix --version`
2. Verify flakes are enabled: `nix flake show`
3. Ensure lock file exists and is committed: `nix flake update && git add flake.lock`

### VM Won't Start

1. Check virtualization is enabled in BIOS
2. Ensure QEMU is available: `which qemu-system-x86_64`
3. Try running with more verbose output

### OpenClaw Not Working

If OpenClaw doesn't respond:

1. Verify the user service is running: `systemctl --user status openclaw-gateway`
2. Check logs: `journalctl --user -u openclaw-gateway -f`
3. Ensure `programs.openclaw.config` has a valid gateway token and channel config

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the build
5. Submit a pull request

## License

This configuration is provided as-is. OpenClaw itself is licensed separately - please refer to the OpenClaw project for its license terms.

## References

- [NixOS Manual](https://nixos.org/manual/nixos/stable/)
- [Nix Flakes](https://nixos.wiki/wiki/Flakes)
- [nix-openclaw](https://github.com/openclaw/nix-openclaw)
- [OpenClaw upstream](https://github.com/openclaw/openclaw)
- [GNOME Boxes](https://help.gnome.org/users/gnome-boxes/stable/)
