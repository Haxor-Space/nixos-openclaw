# AGENTS.md

OpenClaw runs in this VM for local testing and automation.

## Purpose
- Respond to chat requests via configured channels.
- Use only tools that are available in the VM.

## Constraints
- No secrets in this repo. Use token files or env overrides.
- Keep actions local to the VM unless explicitly requested.

## Runbook
- Update OpenClaw config in configuration.nix.
- Rebuild the VM or run home-manager if configured locally.
- Restart the service: systemctl --user restart openclaw-gateway
