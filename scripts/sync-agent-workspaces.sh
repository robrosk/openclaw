#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TEAM_ROOT="$REPO_ROOT/agent-team"
AGENTS_ROOT="$TEAM_ROOT/agents"
CONFIG_ROOT="$TEAM_ROOT/config"
SHARED_SKILLS_ROOT="$TEAM_ROOT/shared-skills"
SHARED_STATE_ROOT="$TEAM_ROOT/shared-state"
OPENCLAW_ROOT="${OPENCLAW_ROOT:-$HOME/.openclaw}"

# --- Copy config + env ---
mkdir -p "$OPENCLAW_ROOT"
cp "$CONFIG_ROOT/openclaw.json" "$OPENCLAW_ROOT/openclaw.json"
echo "Copied openclaw.json -> $OPENCLAW_ROOT/openclaw.json"

if [ -f "$OPENCLAW_ROOT/.env" ]; then
  echo "Skipped .env copy because $OPENCLAW_ROOT/.env already exists."
else
  cp "$CONFIG_ROOT/.env" "$OPENCLAW_ROOT/.env"
  echo "Copied .env template -> $OPENCLAW_ROOT/.env (fill in real tokens before starting)"
fi

# --- Copy workspace files for each agent ---
for agent_dir in "$AGENTS_ROOT"/*/; do
  agent="$(basename "$agent_dir")"
  dest="$OPENCLAW_ROOT/workspace-$agent"
  mkdir -p "$dest"
  cp -r "$agent_dir"* "$dest/" 2>/dev/null || true
  # Include hidden files (like .claude)
  cp -r "$agent_dir".* "$dest/" 2>/dev/null || true

  # Copy shared state into each workspace
  mkdir -p "$dest/shared"
  cp -r "$SHARED_STATE_ROOT"/* "$dest/shared/"

  echo "Synced workspace: $agent"
done

# --- Copy shared skills ---
mkdir -p "$OPENCLAW_ROOT/skills"
cp -r "$SHARED_SKILLS_ROOT"/* "$OPENCLAW_ROOT/skills/"
echo "Synced shared skills."

# --- Restart gateway ---
pkill -9 -f openclaw-gateway || true
sleep 1
nohup openclaw gateway run --bind loopback --port 18789 --force > /tmp/openclaw-gateway.log 2>&1 &
echo "Gateway restarted. Logs at /tmp/openclaw-gateway.log"
echo ""
echo "Verify with: openclaw channels status --probe"
