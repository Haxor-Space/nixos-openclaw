# OpenClaw AI Notes

This VM uses the OpenClaw AI chatbot gateway via the nix-openclaw flake input.

## Configuration Requirements

OpenClaw needs a gateway token and at least one channel configured. The defaults in
configuration.nix are placeholders and will not work until you update them.

### Required Updates

1. Set a real gateway token in `programs.openclaw.config.gateway.auth.token`.
2. Add a channel config (Telegram or Discord) and point to a valid token file.

## Service Commands (Linux)

```bash
# Check status
systemctl --user status openclaw-gateway

# Follow logs
journalctl --user -u openclaw-gateway -f

# Restart after config changes
systemctl --user restart openclaw-gateway
```

## References

- https://github.com/openclaw/nix-openclaw
- https://github.com/openclaw/openclaw
