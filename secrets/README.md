# Secrets setup

This repo uses sops-nix with age keys. Secrets are decrypted only at activation time and are never stored in the Nix store.

## Create the age key

```bash
sudo mkdir -p /var/lib/sops-nix
sudo age-keygen -o /var/lib/sops-nix/key.txt
```

## Extract the public key

```bash
sudo age-keygen -y /var/lib/sops-nix/key.txt
```

Copy the public key into `.sops.yaml` under `age` recipients.

## Create or edit secrets

```bash
sops secrets/secrets.yaml
```

## Validate decrypt on switch

```bash
sudo nixos-rebuild switch --flake .#nixclaw-scout
```
