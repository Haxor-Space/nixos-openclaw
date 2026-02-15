#!/usr/bin/env bash
set -euo pipefail

# Source Nix profile if present
if [[ -f /etc/profile.d/nix.sh ]]; then
  # shellcheck source=/etc/profile.d/nix.sh
  . /etc/profile.d/nix.sh
elif [[ -f "$HOME/.nix-profile/etc/profile.d/nix.sh" ]]; then
  # shellcheck source=/dev/null
  . "$HOME/.nix-profile/etc/profile.d/nix.sh"
fi

# Enable flakes
if command -v sudo >/dev/null 2>&1; then
  sudo mkdir -p /etc/nix
  if [[ ! -f /etc/nix/nix.conf ]] || ! grep -q "nix-command flakes" /etc/nix/nix.conf; then
    echo "experimental-features = nix-command flakes" | sudo tee /etc/nix/nix.conf >/dev/null
  fi
else
  mkdir -p "$HOME/.config/nix"
  if [[ ! -f "$HOME/.config/nix/nix.conf" ]] || ! grep -q "nix-command flakes" "$HOME/.config/nix/nix.conf"; then
    echo "experimental-features = nix-command flakes" > "$HOME/.config/nix/nix.conf"
  fi
fi

# Install sops and age
if ! command -v sops >/dev/null 2>&1 || ! command -v age >/dev/null 2>&1; then
  echo "Installing sops and age..."
  nix profile install nixpkgs#sops nixpkgs#age
fi

echo "✓ Tools ready: nix ($(nix --version | head -n1)), sops, age"
echo ""
echo "To use nix in this shell, run:"
echo "  source ~/.nix-profile/etc/profile.d/nix.sh"
echo ""
echo "Or add this to your ~/.bashrc to make it permanent:"
echo '  [[ -f ~/.nix-profile/etc/profile.d/nix.sh ]] && source ~/.nix-profile/etc/profile.d/nix.sh'
