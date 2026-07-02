#!/usr/bin/env bash
set -euo pipefail

echo "=== Open Design Setup ==="

# Generate token if needed
TOKEN_FILE="$HOME/.opendesign_token"
if [ ! -f "$TOKEN_FILE" ]; then
  openssl rand -hex 32 > "$TOKEN_FILE"
  chmod 600 "$TOKEN_FILE"
fi

TOKEN=$(cat "$TOKEN_FILE")

# Create .env if not exists
if [ ! -f "$HOME/opendesign/deploy/.env" ]; then
  cat > "$HOME/opendesign/deploy/.env" << EOF
OPEN_DESIGN_IMAGE=docker.io/vanjayak/open-design:latest
OPEN_DESIGN_PORT=7456
OPEN_DESIGN_ALLOWED_ORIGINS=
OPEN_DESIGN_MEM_LIMIT=384m
NODE_OPTIONS=--max-old-space-size=192
OD_API_TOKEN=$TOKEN
EOF
  echo "Created .env with secure token"
fi

# Start the service
bash "$HOME/opendesign/opendesign.sh" up

# Add to .bashrc
grep -q "OD_API_TOKEN" "$HOME/.bashrc" 2>/dev/null || \
  echo "export OD_API_TOKEN=$TOKEN" >> "$HOME/.bashrc"

echo "Open Design running at http://127.0.0.1:7456"
