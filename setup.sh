#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "=== OpenClaw Team Orchestrator Setup ==="

mkdir -p ~/.openclaw/skills ~/.openclaw/vault

# Copy skills
for skill in "$PROJECT_DIR/skills/"*/; do
  name=$(basename "$skill")
  mkdir -p ~/.openclaw/skills/"$name"
  cp "$skill"SKILL.md ~/.openclaw/skills/"$name"/
done

# Copy vault
cp -r "$PROJECT_DIR/vault/"* ~/.openclaw/vault/ 2>/dev/null || true

# Generate config from template with a unique gateway token
if [ ! -f ~/.openclaw/openclaw.json ]; then
  TOKEN=$(node -e "console.log(require('crypto').randomBytes(20).toString('hex'))")
  sed "s/\"token\": \"\"/\"token\": \"$TOKEN\"/" "$PROJECT_DIR/config/openclaw.template.json" > ~/.openclaw/openclaw.json
  echo "Config created with random gateway token."
else
  echo "Config already exists, skipping."
fi

# Run openclaw onboard for auth
if command -v openclaw &>/dev/null; then
  echo "Running onboard..."
  openclaw onboard --auth-choice opencode-zen --accept-risk --non-interactive 2>/dev/null || true
fi

echo ""
echo "=== Setup complete ==="
echo "Skills installed:"
ls ~/.openclaw/skills/*/SKILL.md 2>/dev/null || echo "  (none)"
echo "Vault: $(find ~/.openclaw/vault -name '*.md' 2>/dev/null | wc -l) notes"
echo ""
echo "Commands:"
echo "  openclaw chat       # Launch TUI"
echo "  openclaw status     # Check status"
echo "  openclaw gateway run  # Start the gateway"
echo ""
echo "GitHub: https://github.com/Klurien/openclaw-team"
