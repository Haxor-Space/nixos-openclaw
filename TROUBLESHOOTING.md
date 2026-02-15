# Troubleshooting Guide

## Common Build Issues

### 1. OpenClaw Package Not Found

**Error:**

```
error: attribute 'openclaw' missing
```

**Solution:**
The OpenClaw AI package comes from the nix-openclaw flake overlay. Make sure it is wired in.

#### Option A: Verify flake inputs and overlay

1. Confirm `flake.nix` includes the nix-openclaw input and home-manager.
2. Confirm `configuration.nix` sets `nixpkgs.overlays = [ nix-openclaw.overlays.default ];`.
3. Run `nix flake update` and rebuild.

#### Option B: Pin a known-good nixpkgs channel

Try a different nixpkgs channel in `flake.nix`:

```nix
nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
```

### 2. Flake Evaluation Errors

**Error:**

```
error: getting status of '/nix/store/...': No such file or directory
```

**Solution:**
Make sure all files are committed to git (Nix flakes only see tracked files):

```bash
git add .
git commit -m "Update configuration"
```

Also ensure `flake.lock` exists and is committed, because this project builds with `--no-write-lock-file`:

```bash
nix flake update
git add flake.lock
git commit -m "Lock flake inputs"
```

### 3. Build Timeout or Memory Issues

**Error:**

```
error: build of '...' timed out
```

**Solution:**

- Increase build timeout: `nix build --option timeout 7200`
- Or build specific components: `nix build .#nixosConfigurations.openclaw-vm.config.system.build.toplevel`

### 4. QCOW2 Build Fails

**Error:**

```
error: builder for 'qcow-openclaw-vm' failed
```

**Solution:**
The QCOW2 build requires additional disk space and may fail on GitHub Actions. You can:

- Build only the VM: `nix build .#nixosConfigurations.openclaw-vm.config.system.build.vm`
- Build locally with more resources
- Use the VM directly without creating a QCOW2 image

## Runtime Issues

### 1. VM Won't Boot

**Symptoms:**

- Black screen
- No GRUB menu
- Immediate crash

**Solutions:**

1. Check virtualization is enabled:

   ```bash
   egrep -c '(vmx|svm)' /proc/cpuinfo  # Should be > 0
   ```

2. Try different display options:

   ```bash
   QEMU_OPTS="-vga std" ./run-vm.sh
   ```

3. Check disk space:
   ```bash
   df -h
   ```

### 2. Graphics Issues

**Symptoms:**

- Slow rendering
- No OpenGL acceleration
- Black/corrupted display

**Solutions:**

1. Update QEMU options in `configuration.nix`:

   ```nix
   virtualisation.qemu.options = [
     "-vga std"  # Change from virtio
     "-display sdl"  # Change from gtk
   ];
   ```

2. Disable OpenGL:
   ```nix
   hardware.opengl.enable = false;
   ```

### 3. Auto-login Not Working

**Symptoms:**

- Asked for password on boot
- GDM shows login screen

**Solutions:**
Already fixed in current configuration with:

```nix
systemd.services."getty@tty1".enable = false;
systemd.services."autovt@tty1".enable = false;
```

If still not working, check:

```bash
systemctl status display-manager
```

### 4. Network Not Working

**Symptoms:**

- No internet connection
- Can't ping external hosts

**Solutions:**

1. Check NetworkManager status:

   ```nix
   networking.networkmanager.enable = true;
   ```

2. Or use simpler networking:
   ```nix
   networking.useDHCP = true;
   ```

### 5. Sound Not Working

**Symptoms:**

- No audio output
- PulseAudio/PipeWire errors

**Solutions:**

1. Make sure PipeWire is enabled (already in config):

   ```nix
   services.pipewire.enable = true;
   services.pipewire.pulse.enable = true;
   ```

2. Check audio settings in GNOME Sound Settings

## Performance Tuning

### Increase VM Resources

Edit `configuration.nix`:

```nix
virtualisation.vmVariant = {
  virtualisation.memorySize = 8192;  # 8GB instead of 4GB
  virtualisation.cores = 4;          # 4 cores instead of 2
};
```

### Enable KVM Acceleration

Make sure KVM is available:

```bash
ls -la /dev/kvm
```

Should show: `crw-rw---- 1 root kvm`

If not available, load the module:

```bash
sudo modprobe kvm_intel  # For Intel CPUs
# OR
sudo modprobe kvm_amd    # For AMD CPUs
```

## GitHub Actions Issues

### 1. Workflow Not Triggering

**Check:**

- Branch name matches workflow pattern
- `.github/workflows/build-vm.yml` is committed
- Actions are enabled in repository settings

### 2. Nix Installation Fails

**Error:**

```
Error: cachix/install-nix-action failed
```

**Solution:**

- Usually temporary - try re-running the workflow
- Check GitHub Actions status page

### 3. Build Runs Out of Disk Space

**Error:**

```
error: No space left on device
```

**Solution:**

- GitHub runners have limited disk space (~14GB free)
- Add cleanup step before build:
  ```yaml
  - name: Free disk space
    run: |
      sudo rm -rf /usr/share/dotnet
      sudo rm -rf /opt/ghc
      df -h
  ```

### 4. Cachix Upload Fails

If you see Cachix errors but don't use it:

- This is expected and non-fatal (workflow uses `continue-on-error: true`)
- To disable, remove the Cachix step from workflow

## Development Tips

### Quick Rebuild

After making changes:

```bash
# Quick syntax check
nix flake check

# Build without running
nix build .#nixosConfigurations.openclaw-vm.config.system.build.toplevel

# Build and run
./run-vm.sh
```

### Test Single Package

```bash
# Test if a package exists
nix search nixpkgs chromium

# Try to build single package
nix build nixpkgs#chromium
```

### Debug Build

```bash
# Build with verbose output
nix build .#nixosConfigurations.openclaw-vm.config.system.build.toplevel -L -v

# Show what would be built
nix build --dry-run .#nixosConfigurations.openclaw-vm.config.system.build.toplevel
```

## Getting Help

1. Check NixOS manual: https://nixos.org/manual/nixos/stable/
2. NixOS Discourse: https://discourse.nixos.org/
3. NixOS Reddit: https://reddit.com/r/NixOS
4. IRC/Matrix: #nixos on libera.chat or Matrix

## Useful Commands

```bash
# Update flake inputs
nix flake update

# Check flake outputs
nix flake show

# List all available packages
nix search nixpkgs ''

# Clean old build artifacts
nix-collect-garbage

# Check configuration syntax
nixos-rebuild dry-build -I nixos-config=./configuration.nix
```
