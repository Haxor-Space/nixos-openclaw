#!/usr/bin/env bash
set -euo pipefail

# Source Nix profile if present
if [[ -f /etc/profile.d/nix.sh ]]; then
  . /etc/profile.d/nix.sh
elif [[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

if ! command -v nix >/dev/null 2>&1; then
  echo "nix not found. Run ./scripts/setup-tools.sh first." >&2
  exit 1
fi

nix flake check --no-write-lock-file
nix build .#nixosConfigurations.nixclaw-scout.config.system.build.toplevel -L --no-write-lock-file
nix eval .#nixosConfigurations.nixclaw-scout.config.system.nixos.label --raw
nix path-info .#nixosConfigurations.nixclaw-scout.config.system.build.toplevel
