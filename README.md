# NixClaw

Reproducible NixOS system definitions for OpenClaw VM workloads. This repo is designed for a fresh NixOS install: clone, configure secrets, and `nixos-rebuild switch` into a stable, repeatable state.

## Fresh NixOS bootstrap (UTC)

1. Install git:

```bash
sudo nix-env -iA nixpkgs.git
```

2. Enable flakes (nix-command + flakes):

```bash
sudo mkdir -p /etc/nix
echo "experimental-features = nix-command flakes" | sudo tee /etc/nix/nix.conf
```

3. Clone the repo:

```bash
git clone https://github.com/Haxor-Space/nixos-openclaw.git
cd nixos-openclaw
```

4. Update the SSH key placeholder for user `captain` in the role file:

```bash
sed -n '1,200p' nixos/roles/openclaw-vm.nix
```

5. Replace the hardware config with your host-specific file:

```bash
sudo cp /etc/nixos/hardware-configuration.nix nixos/hosts/hardware-configuration.nix
```

6. Apply the system configuration (choose one):

```bash
sudo nixos-rebuild switch --flake .#nixclaw-scout
```

Use `nixclaw-cron` or `nixclaw-trader` instead of `nixclaw-scout` if needed.

7. Rollbacks:

```bash
sudo nixos-rebuild switch --rollback
```

## Adding software

Add packages and services via workspace modules or the base role, then run:

```bash
sudo nixos-rebuild switch --flake .#nixclaw-scout
```

## Local CI loop (Codespace)

Install tools once:

```bash
./scripts/setup-tools.sh
```

Run the same checks as the GitHub Actions workflow:

```bash
./scripts/ci-local.sh
```

## Repo layout

```
.
├── flake.nix
├── nixos/
│   ├── hosts/
│   ├── modules/
│   ├── roles/
│   └── workspaces/
├── secrets/
│   └── README.md
└── .sops.yaml
```
