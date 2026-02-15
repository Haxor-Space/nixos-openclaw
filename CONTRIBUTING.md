# Contributing to nixos-openclaw

Thank you for your interest in contributing to nixos-openclaw! This document provides guidelines for contributing to this project.

## How to Contribute

### Reporting Issues

If you encounter any issues with the VM configuration:

1. Check the [TROUBLESHOOTING.md](TROUBLESHOOTING.md) guide first
2. Search existing issues to avoid duplicates
3. Create a new issue with:
   - Clear description of the problem
   - Steps to reproduce
   - Your environment (OS, NixOS version, etc.)
   - Relevant error messages or logs

### Suggesting Enhancements

We welcome suggestions for improvements:

1. Open an issue describing the enhancement
2. Explain why it would be useful
3. Provide examples if possible

### Pull Requests

1. Fork the repository
2. Create a new branch for your feature: `git checkout -b feature/your-feature-name`
3. Make your changes
4. Test your changes:
   ```bash
   nix flake check
   nix build .#nixosConfigurations.openclaw-vm.config.system.build.toplevel
   ```
5. Update documentation if needed
6. Commit your changes with clear commit messages
7. Push to your fork
8. Open a Pull Request

### Coding Guidelines

#### NixOS Configuration

- Follow Nix formatting conventions
- Use comments to explain non-obvious configurations
- Keep the configuration modular and maintainable
- Test changes before submitting

#### Documentation

- Update README.md if adding new features
- Add troubleshooting steps for common issues
- Keep documentation clear and concise
- Use proper markdown formatting

### Adding New Packages

When adding new packages to the VM:

1. Add them to `configuration.nix` in the appropriate section
2. Add comments explaining why the package is included
3. Test that the package builds and works in the VM
4. Update README.md if the package is significant

### Testing

Before submitting a PR:

1. **Syntax Check:**
   ```bash
   nix flake check
   ```

2. **Build Test:**
   ```bash
   nix build .#nixosConfigurations.openclaw-vm.config.system.build.toplevel
   ```

3. **VM Test (if possible):**
   ```bash
   ./run-vm.sh
   ```

4. **Documentation:**
   - Verify all links work
   - Check markdown formatting
   - Ensure examples are correct

### OpenClaw-Specific Contributions

If you're working on OpenClaw AI integration:

1. Validate the nix-openclaw input and overlay wiring
2. Document any required tokens or channel settings
3. Verify the OpenClaw user service starts and logs cleanly
4. Update OPENCLAW_NOTES.md with any new requirements

### Workflow Changes

When modifying `.github/workflows/build-vm.yml`:

1. Test locally if possible using `act` or similar tools
2. Ensure the workflow still builds successfully
3. Keep build times reasonable
4. Add comments for complex workflow steps

## Code Review Process

1. All PRs require review before merging
2. Address reviewer feedback promptly
3. Keep PRs focused on a single feature/fix
4. Squash commits if requested

## Community

- Be respectful and constructive
- Help others with issues when you can
- Share your knowledge and experiences

## Questions?

If you have questions about contributing:

1. Check existing documentation
2. Search closed issues
3. Open a new issue with the `question` label

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

Thank you for contributing! 🎮
