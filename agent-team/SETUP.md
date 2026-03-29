# Investment Agent Team - Fork Setup Guide

This fork extends OpenClaw with a 5-agent investment team that collaborates through Slack channels. Each agent has a specialized role, its own Slack bot, and isolated workspace with personality files.

## What this fork adds

### The team

| Agent | Role | Primary Channel |
|-------|------|-----------------|
| **Orchestrator** | Portfolio manager. Triages signals, dispatches work, publishes final briefs. | `#portfolio-daily`, `#portfolio-weekly` |
| **Scout** | Market intelligence. Detects and reports high-signal developments. | `#market-signals` |
| **Analyst** | Fundamental research. Builds source-backed investment theses. | `#research` |
| **Quant** | Technical and quantitative analysis. Reproducible data-driven outputs. | `#quant-signals` |
| **Devil's Advocate** | Risk and contrarian. Stress-tests every thesis, surfaces the bear case. | `#contrarian` |

Coordination happens in `#dispatch`. No agent executes trades. All handoffs are channel-visible.

### Files added

```
agent-team/
  agents/                        # Personality files per agent
    orchestrator/                 #   SOUL.md, AGENTS.md, TOOLS.md, skills/
    scout/
    analyst/
    quant/
    devils-advocate/
  shared-skills/                 # Skills shared across all agents
  shared-state/portfolio/        # Shared portfolio context (watchlist, positions, etc.)
  config/
    openclaw.json                # Production config (5 agents, env var references)
    .env                         # Environment variable template (REPLACE_ME placeholders)
    slack-app-manifest.example.json
    slack-rollout-checklist.md
    openclaw.multi-agent.example.json5

scripts/
  sync-agent-workspaces.sh       # Bash deploy script (Linux/macOS VMs)
  sync-agent-workspaces.ps1      # PowerShell deploy script (Windows)
```

### Config approach

All secrets (Slack tokens, gateway token) are referenced in `openclaw.json` via `${ENV_VAR}` interpolation and stored in a `.env` file that never contains real values in the repo. The actual `.env` with real tokens lives only on the VM at `~/.openclaw/.env`.

## Prerequisites

- An Azure VM (or any Linux host) with Node 22+ and OpenClaw installed globally (`sudo npm i -g openclaw@latest`)
- 5 Slack Socket Mode apps (one per agent), each with:
  - Socket Mode enabled
  - An app-level token (`xapp-`) with `connections:write` scope
  - A bot token (`xoxb-`) with scopes: `chat:write`, `app_mentions:read`, `channels:history`, `channels:read`
  - The orchestrator additionally needs: `im:history`, `im:read`, `im:write`
  - Event subscriptions: `message.channels`, `app_mention` (orchestrator also: `message.im`)
- 7 Slack channels created: `#market-signals`, `#research`, `#quant-signals`, `#contrarian`, `#dispatch`, `#portfolio-daily`, `#portfolio-weekly`

See `agent-team/config/slack-app-manifest.example.json` for a ready-to-import manifest template and `agent-team/config/slack-rollout-checklist.md` for the full step-by-step.

## Setup

### 1. Clone and configure

```bash
git clone <your-fork-url>
cd openclaw
```

Edit `agent-team/config/.env` and replace all `REPLACE_ME` values with your real tokens:

```
OPENCLAW_GATEWAY_TOKEN=<openssl rand -hex 24>
SLACK_ORCHESTRATOR_BOT_TOKEN=xoxb-...
SLACK_ORCHESTRATOR_APP_TOKEN=xapp-...
SLACK_SCOUT_BOT_TOKEN=xoxb-...
SLACK_SCOUT_APP_TOKEN=xapp-...
SLACK_ANALYST_BOT_TOKEN=xoxb-...
SLACK_ANALYST_APP_TOKEN=xapp-...
SLACK_QUANT_BOT_TOKEN=xoxb-...
SLACK_QUANT_APP_TOKEN=xapp-...
SLACK_DEVILS_ADVOCATE_BOT_TOKEN=xoxb-...
SLACK_DEVILS_ADVOCATE_APP_TOKEN=xapp-...
```

Replace the placeholder channel IDs (`C_MARKET_SIGNALS`, etc.) in `agent-team/config/openclaw.json` with your real Slack channel IDs.

### 2. Deploy to the VM

SSH into the VM, pull the code, and run the deploy script:

```bash
ssh your-vm
cd /path/to/openclaw
git pull
./scripts/sync-agent-workspaces.sh
```

This script:
- Copies `openclaw.json` to `~/.openclaw/openclaw.json`
- Copies `.env` to `~/.openclaw/.env` (only on first run, never overwrites existing)
- Deploys all 5 agent workspaces to `~/.openclaw/workspace-<agentId>/`
- Copies shared state into each workspace
- Copies shared skills to `~/.openclaw/skills/`
- Restarts the gateway

### 3. Verify

```bash
openclaw channels status --probe
```

All 5 Slack accounts should show as connected.

### 4. Invite bots to channels

In Slack, invite each bot to its channels:

- **Orchestrator**: all 7 channels
- **Scout**: `#market-signals`, `#dispatch`
- **Analyst**: `#research`, `#market-signals`, `#dispatch`
- **Quant**: `#quant-signals`, `#research`, `#dispatch`
- **Devil's Advocate**: `#contrarian`, `#research`, `#quant-signals`, `#market-signals`, `#dispatch`

### 5. Test

DM the Orchestrator in Slack - it will respond with a pairing code. The other 4 agents have DMs disabled by default; interact with them by @mentioning them in their channels.

## Updating

After making changes to workspace files, config, or personality:

```bash
# On the VM
git pull
./scripts/sync-agent-workspaces.sh
```

The script always overwrites `openclaw.json` and workspace files but preserves your existing `.env` (with real tokens).

## Architecture notes

- **No agent-to-agent hidden messaging.** `agentToAgent` is disabled. All coordination happens in Slack channels.
- **No trade execution.** No agent has the ability to execute trades. Humans make all execution decisions.
- **Orchestrator is the only dispatcher.** Specialists never assign work to each other directly.
- **Channel-visible handoffs.** All task assignments go through `#dispatch` so nothing is hidden.
- **Shared portfolio state.** Every agent reads the same `watchlist.md`, `positions.md`, and `recent-decisions.md` from their `shared/portfolio/` directory. Only the Orchestrator updates these files.
