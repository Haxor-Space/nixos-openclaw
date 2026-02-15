# Secrets setup

This repo uses sops-nix with age keys. Secrets are optional; if you do not provide a secrets file, NixClaw will skip secrets setup entirely.

For a public repo, keep secrets in a private repository and clone it into `secrets/` so the encrypted file exists locally but is not committed.

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

If your secrets repo lives elsewhere, set `nixclaw.secretsFile` in a host file to point at the encrypted file path.

## Validate decrypt on switch

```bash
sudo nixos-rebuild switch --flake .#nixclaw-scout
```
