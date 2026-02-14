# Quick Reference Card

## Essential Commands

### Building

```bash
# Build VM (recommended)
make build

# Or using Nix directly
nix build .#nixosConfigurations.openclaw-vm.config.system.build.toplevel

# Build QCOW2 for GNOME Boxes
make qcow
```

### Running

```bash
# Run VM locally
make run

# Or using script
./run-vm.sh
```

### Maintenance

```bash
# Update dependencies
make update

# Clean build artifacts
make clean

# Check configuration
make check
```

## Default VM Credentials

- **Username:** openclaw
- **Password:** openclaw

## Key Files

| File | Purpose |
|------|---------|
| `flake.nix` | Nix flake configuration |
| `configuration.nix` | Main NixOS config (without openclaw) |
| `configuration-with-openclaw.nix` | Alternative config with openclaw |
| `hardware-configuration.nix` | VM hardware settings |
| `openclaw.nix` | Custom openclaw package |
| `build-vm.sh` | Build script |
| `run-vm.sh` | Run script |

## Common Issues

| Problem | Solution |
|---------|----------|
| OpenClaw not found | See OPENCLAW_NOTES.md |
| Build fails | See TROUBLESHOOTING.md |
| Can't run VM | Check virtualization enabled |
| Out of memory | Increase RAM in configuration.nix |

## Customization Quick Tips

### Add a package
Edit `configuration.nix`:
```nix
environment.systemPackages = with pkgs; [
  # ... existing packages
  yourpackage
];
```

### Increase RAM
Edit `configuration.nix`:
```nix
virtualisation.vmVariant = {
  virtualisation.memorySize = 8192;  # 8GB
};
```

### Disable auto-login
Edit `configuration.nix`, comment out:
```nix
# services.displayManager.autoLogin = {
#   enable = true;
#   user = "openclaw";
# };
```

## Keyboard Shortcuts in VM

- **Ctrl+Alt+G** - Release mouse/keyboard from VM
- **Ctrl+Alt+F** - Toggle fullscreen
- **Ctrl+Alt+Delete** - Send Ctrl+Alt+Delete to VM

## Links

- [Full Documentation](README.md)
- [Troubleshooting](TROUBLESHOOTING.md)
- [OpenClaw Notes](OPENCLAW_NOTES.md)
- [Contributing](CONTRIBUTING.md)

## GitHub Actions

The repository automatically builds the VM on:
- Push to main/master
- Pull requests
- Manual trigger

Artifacts are available on the Actions page.
