#!/bin/sh
set -e

# Start tailscaled in the background
tailscaled \
  --state=/var/lib/tailscale/tailscaled.state \
  --socket=/var/run/tailscale/tailscaled.sock &

# Wait until tailscaled is ready
until tailscale status >/dev/null 2>&1; do
  sleep 0.5
done

# Authenticate
tailscale up \
  --authkey="$TAILSCALE_AUTH_KEY" \
  --hostname=openclaw \
  --accept-routes \
  --accept-dns=false

# Enable funnel
tailscale funnel 18789

# Hand off to the main container process
exec "$@"