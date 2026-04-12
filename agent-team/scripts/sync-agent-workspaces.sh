#!/usr/bin/env bash
#
# sync-agent-workspaces.sh
#
# Deploy the agent-team/ folder into ~/.openclaw/ as live agent workspaces.
#
# Usage:
#   ./sync-agent-workspaces.sh             # sync (additive, legacy behavior)
#   ./sync-agent-workspaces.sh --clean     # wipe workspace-*/skills/ first, then sync
#   ./sync-agent-workspaces.sh --no-build  # skip pnpm install + pnpm build (use only if dist/ is already current)
#   ./sync-agent-workspaces.sh --help
#
# Safe-by-default: never touches ~/.openclaw/.env or ~/.openclaw/openclaw.json
# unless --clean is passed with openclaw.json being rewritten from source.
#
# Script now lives at agent-team/scripts/sync-agent-workspaces.sh.
# Repo root is resolved as the parent of agent-team/.

set -euo pipefail

CLEAN=0
BUILD=1
for arg in "$@"; do
  case "$arg" in
    --clean)
      CLEAN=1
      ;;
    --no-build)
      BUILD=0
      ;;
    --help|-h)
      sed -n '3,17p' "$0"
      exit 0
      ;;
    *)
      echo "Unknown arg: $arg"
      echo "Use --help for usage."
      exit 1
      ;;
  esac
done

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEAM_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
REPO_ROOT="$(cd "$TEAM_ROOT/.." && pwd)"
AGENTS_ROOT="$TEAM_ROOT/agents"
CONFIG_ROOT="$TEAM_ROOT/config"
SHARED_SKILLS_ROOT="$TEAM_ROOT/shared-skills"
SHARED_STATE_ROOT="$TEAM_ROOT/shared-state"
OPENCLAW_ROOT="${OPENCLAW_ROOT:-$HOME/.openclaw}"

# Resolve the absolute path to `openclaw` up front so the gateway relaunch at
# the bottom of this script does not depend on PATH being inherited into
# `nohup` / `env -u` subshells. Non-interactive shells and sandbox runners
# (e.g. the snap codex sandbox) often strip npm/pnpm global bin from PATH, and
# "nohup: failed to run command 'openclaw': No such file or directory" is the
# usual symptom. Fail loudly here instead of silently losing the gateway.
OPENCLAW_BIN="$(command -v openclaw || true)"
if [ -z "$OPENCLAW_BIN" ]; then
  echo "ERROR: 'openclaw' is not on PATH for this shell." >&2
  echo "  PATH=$PATH" >&2
  echo "  Run this script from an interactive login shell where 'which openclaw' succeeds," >&2
  echo "  or set OPENCLAW_BIN=/absolute/path/to/openclaw before invoking." >&2
  exit 1
fi

echo "Repo root:   $REPO_ROOT"
echo "Team root:   $TEAM_ROOT"
echo "Target root: $OPENCLAW_ROOT"
echo "Clean mode:  $CLEAN"
echo "Build mode:  $BUILD"
echo "OpenClaw:    $OPENCLAW_BIN"
echo ""

# Source-checkout preflight: warn the operator that the gateway and any
# subsequent CLI invocation must NOT inherit a cwd inside this repo. See the
# launch block at the bottom of this script for the rationale.
if [ -d "$REPO_ROOT/.git" ] && [ -d "$REPO_ROOT/src" ] && [ -d "$REPO_ROOT/extensions" ]; then
  echo "Source checkout detected at: $REPO_ROOT"
  echo "Gateway will be launched from \$HOME with bundled-plugin env vars stripped."
  echo ""
fi

# --- Rebuild dist/ so compiled core matches src/ + extensions/ ---
# On VMs where the installed `openclaw` CLI is a pnpm-global link into this
# source checkout, every `git pull` invalidates dist/. If dist/ is not
# rebuilt, the CLI loads stale compiled core against jiti-loaded `.ts`
# extensions and every provider plugin throws TypeError on registration
# (e.g. "_providerModelShared.buildProviderReplayFamilyHooks is not a
# function", "api.registerVideoGenerationProvider is not a function"). The
# resulting plugin-discovery cascade also surfaces as the misleading
# "plugin manifest not found: <repo>/extensions/openclaw.plugin.json".
# Rebuilding before relaunching the gateway is the durable fix.
# Pass --no-build to skip this if you have already rebuilt manually.
if [ "$BUILD" -eq 1 ] && [ -d "$REPO_ROOT/.git" ] && [ -d "$REPO_ROOT/src" ]; then
  if command -v pnpm >/dev/null 2>&1; then
    echo "Rebuilding OpenClaw from source ($REPO_ROOT) ..."
    ( cd "$REPO_ROOT" && pnpm install --frozen-lockfile && pnpm build )
    echo "Rebuild complete."
    echo ""
  else
    echo "WARNING: pnpm not found on PATH; skipping rebuild." >&2
    echo "  dist/ may drift from src/ and provider plugins may fail to load." >&2
    echo "  Install pnpm or rerun with --no-build to silence this warning." >&2
    echo "" >&2
  fi
fi

mkdir -p "$OPENCLAW_ROOT"

# --- Clean mode: wipe workspaces + shared skills, preserve .env + openclaw.json ---
if [ "$CLEAN" -eq 1 ]; then
  echo "Cleaning stale workspace-*/ and skills/ from $OPENCLAW_ROOT ..."
  find "$OPENCLAW_ROOT" -maxdepth 1 -type d -name 'workspace-*' -print0 \
    | xargs -0 -r rm -rf
  rm -rf "$OPENCLAW_ROOT/skills"
  echo "Clean complete. (.env and openclaw.json preserved.)"
  echo ""
fi

# --- Copy config ---
cp "$CONFIG_ROOT/openclaw.json" "$OPENCLAW_ROOT/openclaw.json"
echo "Copied openclaw.json -> $OPENCLAW_ROOT/openclaw.json"

# --- Copy scheduled-jobs.json if present ---
if [ -f "$CONFIG_ROOT/scheduled-jobs.json" ]; then
  cp "$CONFIG_ROOT/scheduled-jobs.json" "$OPENCLAW_ROOT/scheduled-jobs.json"
  echo "Copied scheduled-jobs.json -> $OPENCLAW_ROOT/scheduled-jobs.json"
fi

# --- .env: first-run only; never overwrite real tokens ---
if [ -f "$OPENCLAW_ROOT/.env" ]; then
  echo "Skipped .env copy because $OPENCLAW_ROOT/.env already exists."
else
  ENV_SRC="$CONFIG_ROOT/.env"
  [ -f "$ENV_SRC" ] || ENV_SRC="$CONFIG_ROOT/.env.example"
  if [ -f "$ENV_SRC" ]; then
    cp "$ENV_SRC" "$OPENCLAW_ROOT/.env"
    echo "Copied $(basename "$ENV_SRC") -> $OPENCLAW_ROOT/.env (fill in real tokens before starting)"
  fi
fi

# --- Copy workspace files for each agent ---
for agent_dir in "$AGENTS_ROOT"/*/; do
  agent="$(basename "$agent_dir")"
  dest="$OPENCLAW_ROOT/workspace-$agent"
  mkdir -p "$dest"
  cp -r "$agent_dir"* "$dest/" 2>/dev/null || true
  cp -r "$agent_dir".* "$dest/" 2>/dev/null || true

  # Copy shared state into each workspace
  mkdir -p "$dest/shared"
  cp -r "$SHARED_STATE_ROOT"/* "$dest/shared/"

  # Ensure per-agent files/ tree exists (day-categorized artifacts live here)
  mkdir -p "$dest/files"
  if [ ! -f "$dest/files/index.md" ]; then
    cat > "$dest/files/index.md" <<'INDEXEOF'
# Files Index

Append one line per artifact written, format: `YYYY-MM-DD HH:MM  filename  one-line summary`.
This index is the agent's own history of what it produced and when. Scan the tail at session start.
INDEXEOF
  fi

  echo "Synced workspace: $agent"
done

# --- Copy shared skills ---
mkdir -p "$OPENCLAW_ROOT/skills"
cp -r "$SHARED_SKILLS_ROOT"/* "$OPENCLAW_ROOT/skills/"
echo "Synced shared skills."

# --- Distribute auth credentials to all agent dirs ---
# `openclaw models auth login` writes OAuth credentials (auth-profiles.json)
# only to the default agent's dir (e.g. ~/.openclaw/agents/orchestrator/agent/).
# Non-default agents load from their own agentDir and find nothing, causing
# "Model login failed" on every request. Find whichever agent dir has the
# credentials and copy to all others so every agent can auth.
SOURCE_AUTH="$(find "$OPENCLAW_ROOT/agents" -name 'auth-profiles.json' -path '*/agent/auth-profiles.json' 2>/dev/null | head -1)"
if [ -f "$SOURCE_AUTH" ]; then
  for agent_dir in "$OPENCLAW_ROOT/agents"/*/agent/; do
    target="$agent_dir/auth-profiles.json"
    if [ "$target" != "$SOURCE_AUTH" ] && [ -d "$agent_dir" ]; then
      cp "$SOURCE_AUTH" "$target"
    fi
  done
  echo "Auth credentials distributed to all agent dirs."
  echo ""
fi

# --- Restart gateway ---
# IMPORTANT: launch the gateway from $HOME, not from this script's cwd.
# resolveBundledPluginsDir() walks process.cwd() looking for an OpenClaw
# package root. If the operator runs this script from inside a clone of the
# openclaw source repo (e.g. /home/clawadmin/openclaw/), cwd will look like
# a "source checkout" (.git + src + extensions all present), and the gateway
# will resolve its bundled plugins dir to <repo>/extensions instead of the
# globally-installed npm package's dist tree. That mismatch surfaces as
# "plugin manifest not found: <repo>/extensions/openclaw.plugin.json" on
# every boot. Launching from $HOME (which is not a checkout) and stripping
# any stale OPENCLAW_* env overrides (including OPENCLAW_PLUGINS, which can
# inject the source extensions/ tree as a load path) keeps the resolver
# pointed at the globally-installed openclaw package.
pkill -9 -f openclaw-gateway || true
sleep 1
# CODEX_HOME isolates the gateway's Codex OAuth credentials from the Codex CLI.
# Without this, running `codex` on the same machine overwrites ~/.codex/auth.json
# with API-key mode, which breaks the gateway's OAuth refresh flow.
( cd "$HOME" && \
  env -u OPENCLAW_BUNDLED_PLUGINS_DIR \
      -u OPENCLAW_PLUGINS \
      -u OPENCLAW_STATE_DIR \
      -u OPENCLAW_CONFIG_PATH \
      CODEX_HOME="$HOME/.openclaw-codex" \
    nohup "$OPENCLAW_BIN" gateway run --bind loopback --port 18789 --force \
    > /tmp/openclaw-gateway.log 2>&1 & )
echo "Gateway restarted from \$HOME. Logs at /tmp/openclaw-gateway.log"
echo ""
cat <<BANNER
Verify from a clean shell (do NOT run with \$PWD inside $REPO_ROOT):

  ( cd "\$HOME" && \\
      env -u OPENCLAW_BUNDLED_PLUGINS_DIR \\
          -u OPENCLAW_PLUGINS \\
          -u OPENCLAW_STATE_DIR \\
          -u OPENCLAW_CONFIG_PATH \\
        openclaw channels status --probe )

If \`openclaw channels status --probe\` is run from inside the source
checkout, the CLI process re-triggers the same cwd trap as the gateway and
prints "plugin manifest not found: $REPO_ROOT/extensions/openclaw.plugin.json".
That is an environment leak, NOT a malformed openclaw.json.
BANNER
