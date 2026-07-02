#!/usr/bin/env bash
set -euo pipefail

PROJECT_DIR="$(cd "$(dirname "$0")" && pwd)"
echo "=== OpenClaw Team Orchestrator Setup ==="

mkdir -p ~/.openclaw/skills

# Copy config
cp "$PROJECT_DIR/config/openclaw.json" ~/.openclaw/openclaw.json

# Copy skills
for skill in "$PROJECT_DIR/skills/"*/; do
  name=$(basename "$skill")
  mkdir -p ~/.openclaw/skills/"$name"
  cp "$skill"SKILL.md ~/.openclaw/skills/"$name"/
done

# Copy vault
cp -r "$PROJECT_DIR/vault" ~/.openclaw/vault

echo "Setup complete! Skills installed:"
ls ~/.openclaw/skills/*/SKILL.md
echo "Vault: $(find ~/.openclaw/vault -name '*.md' | wc -l) notes"
echo ""
echo "Commands:"
echo "  openclaw chat       # Launch TUI"
echo "  openclaw status     # Check status"
echo "  openclaw gateway start  # Start the gateway"
