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

## Runtime mapping

The sync script deploys these folders into `~/.openclaw` by default:

- `agents/orchestrator/*` -> `~/.openclaw/workspace-orchestrator`
- `agents/scout/*` -> `~/.openclaw/workspace-scout`
- `agents/analyst/*` -> `~/.openclaw/workspace-analyst`
- `agents/quant/*` -> `~/.openclaw/workspace-quant`
- `agents/devils-advocate/*` -> `~/.openclaw/workspace-devils-advocate`
- `shared-skills/*` -> `~/.openclaw/skills/*`

The script also copies `shared-state/portfolio/` into each workspace under
`shared/portfolio/` so every agent can read the same durable context.

When `~/.openclaw/openclaw.json` already exists and the `openclaw` CLI is
available, the sync script also applies each workspace `IDENTITY.md` into the
live agent config so outbound identity names stay aligned with the workspace.

## Notes

- `SOUL.md` carries the primary persona and boundaries.
- `AGENTS.md` carries startup rules, channel ownership, and collaboration rules.
- `skills/` is intentionally lean. Built-in OpenClaw tools still handle web
  search, file access, and Slack usage.
- No workspace or skill in this tree should ever grant trade execution.
- Cross-agent coordination is channel-visible by design; specialists do not
  dispatch hidden work to each other.

## Sync usage

Dry run:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/sync-agent-workspaces.ps1 -All -IncludeSharedSkills -IncludeSharedState -WhatIf
```

Real sync:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/sync-agent-workspaces.ps1 -All -IncludeSharedSkills -IncludeSharedState
```

## Config template

See `agent-team/config/openclaw.multi-agent.example.json5` for a starting
OpenClaw config skeleton that matches this workspace layout.

For the Slack-specific rollout:

- `agent-team/config/slack-app-manifest.example.json`
  - Generic Socket Mode manifest template for each bot.
- `agent-team/config/slack-rollout-checklist.md`
  - Exact five-bot, seven-channel rollout steps for this investment team.
