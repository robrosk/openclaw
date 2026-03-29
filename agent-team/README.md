# Investment Agent Team

This folder is the canonical source for the multi-agent investment team
workspace files that get synced into OpenClaw runtime workspaces.

## Layout

- `agents/<agentId>/`
  - Versioned workspace files for one OpenClaw agent.
- `shared-skills/`
  - Reusable `SKILL.md` packages shared across all agents.
- `shared-state/portfolio/`
  - Small canonical files with portfolio context and Slack conventions.
  - Includes protocol docs for lifecycle, conflict, and failure handling.
  - Includes `team-memory.md` as the compact role-and-handoff reference.
- `config/`
  - `openclaw.json` - Production config with `${ENV_VAR}` interpolation for all secrets and channel IDs.
  - `.env` - Environment variable template (gitignored, real tokens only on VM).
  - `slack-app-manifest.example.json` - Generic Socket Mode manifest template for each bot.
  - `slack-rollout-checklist.md` - Five-bot, seven-channel rollout steps.
  - `openclaw.multi-agent.example.json5` - Original reference config skeleton.

## Runtime mapping

The deploy script (`scripts/sync-agent-workspaces.sh`) places these into `~/.openclaw`:

- `config/openclaw.json` -> `~/.openclaw/openclaw.json`
- `config/.env` -> `~/.openclaw/.env` (first run only, never overwrites)
- `agents/orchestrator/*` -> `~/.openclaw/workspace-orchestrator`
- `agents/scout/*` -> `~/.openclaw/workspace-scout`
- `agents/analyst/*` -> `~/.openclaw/workspace-analyst`
- `agents/quant/*` -> `~/.openclaw/workspace-quant`
- `agents/devils-advocate/*` -> `~/.openclaw/workspace-devils-advocate`
- `shared-skills/*` -> `~/.openclaw/skills/*`
- `shared-state/` -> each workspace's `shared/` directory

## Config approach

All secrets (Slack bot tokens, app tokens, gateway token) and Slack channel IDs
are referenced in `openclaw.json` via `${ENV_VAR}` interpolation. The `.env`
file holds the actual values and is gitignored. Real tokens live only on the VM
at `~/.openclaw/.env`.

Environment variables used:

| Variable | Purpose |
|----------|---------|
| `OPENCLAW_GATEWAY_TOKEN` | Gateway auth token |
| `SLACK_<AGENT>_BOT_TOKEN` | Per-agent Slack bot token (5 agents) |
| `SLACK_<AGENT>_APP_TOKEN` | Per-agent Slack app token (5 agents) |
| `SLACK_CHANNEL_MARKET_SIGNALS` | Channel ID for #market-signals |
| `SLACK_CHANNEL_RESEARCH` | Channel ID for #research |
| `SLACK_CHANNEL_QUANT_SIGNALS` | Channel ID for #quant-signals |
| `SLACK_CHANNEL_CONTRARIAN` | Channel ID for #contrarian |
| `SLACK_CHANNEL_DISPATCH` | Channel ID for #dispatch |
| `SLACK_CHANNEL_PORTFOLIO_DAILY` | Channel ID for #portfolio-daily |
| `SLACK_CHANNEL_PORTFOLIO_WEEKLY` | Channel ID for #portfolio-weekly |

## Deploy

```bash
./scripts/sync-agent-workspaces.sh
```

PowerShell alternative (Windows):

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/sync-agent-workspaces.ps1 -All -IncludeSharedSkills -IncludeSharedState -IncludeConfig
```

## Notes

- `SOUL.md` carries the primary persona and boundaries.
- `AGENTS.md` carries startup rules, channel ownership, and collaboration rules.
- `skills/` is intentionally lean. Built-in OpenClaw tools still handle web
  search, file access, and Slack usage.
- No workspace or skill in this tree should ever grant trade execution.
- Cross-agent coordination is channel-visible by design; specialists do not
  dispatch hidden work to each other.

For the full setup walkthrough, see [SETUP.md](SETUP.md).
