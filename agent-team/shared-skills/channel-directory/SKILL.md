---
name: channel_directory
description: Look up the Slack channel ID for a named channel before sending or reading with the `message` tool. Trigger on any Slack post/read where only the `#channel-name` is known.
---

# Channel Directory

Use this skill to look up Slack channel IDs. The `message` tool needs channel IDs, not `#names`. Always refer to channels by `#name` in human-readable text, but pass the resolved ID to the tool.

**Zero hardcoded IDs live in this skill.** Every channel below is resolved from an environment variable in `~/.openclaw/.env` via `${VAR_NAME}` interpolation. If a lookup returns an empty string, the operator has not filled in that variable — refuse to post and surface the missing variable name in your reply.

## Channels

| Channel | Env var | Canonical owner |
|---------|---------|-----------------|
| `#task-board` | `${SLACK_CHANNEL_TASK_BOARD}` | Orchestrator (work queue) |
| `#research` | `${SLACK_CHANNEL_RESEARCH}` | Analyst |
| `#quant-signals` | `${SLACK_CHANNEL_QUANT_SIGNALS}` | Quant |
| `#portfolio-daily` | `${SLACK_CHANNEL_PORTFOLIO_DAILY}` | Orchestrator (canonical decisions) |
| `#portfolio-weekly` | `${SLACK_CHANNEL_PORTFOLIO_WEEKLY}` | Orchestrator |
| `#contrarian` | `${SLACK_CHANNEL_CONTRARIAN}` | Devil's Advocate |
| `#market-signals` | `${SLACK_CHANNEL_MARKET_SIGNALS}` | Scout |
| `#agents` | `${SLACK_CHANNEL_AGENTS}` | any |
| `#themes` | `${SLACK_CHANNEL_THEMES}` | any |
| `#watchlist` | `${SLACK_CHANNEL_WATCHLIST}` | Orchestrator canonical + Scout morning build |
| `#weekly-outlook` | `${SLACK_CHANNEL_WEEKLY_OUTLOOK}` | Scout |

## How resolution works at runtime

1. The gateway loads `~/.openclaw/.env` on boot.
2. `openclaw.json` references each channel as `${SLACK_CHANNEL_*}`.
3. When you invoke the `message` tool, the harness substitutes the env value and you pass the resolved ID (e.g. `C0APBP5MS4B`) through.
4. If the env var is unset at boot, the gateway logs a warning and refuses to allow that channel — posts to it will error.

## Usage

Send:

```
message(action: "send", target: "<resolved channel id>", text: "...")
```

Read:

```
message(action: "read", target: "<resolved channel id>")
```

In your human-readable text always use the `#name` form (e.g. "posting to #task-board"), never the raw ID.

## Canonical state channels (read on startup)

- `#watchlist` — current active coverage list. Read the last ~20 messages on startup.
- `#portfolio-daily` — most recent portfolio decisions. Read the last ~10 messages on startup.

These channels replace the old `shared/portfolio/watchlist.md` and `shared/portfolio/recent-decisions.md` files.

## Rename note

The former `#dispatch` channel has been renamed `#task-board`. The concept is unchanged — it is the Orchestrator's work queue where assignments are posted and specialists reply. If you see legacy references to `#dispatch` or `SLACK_CHANNEL_DISPATCH` anywhere, treat them as the same as `#task-board` / `SLACK_CHANNEL_TASK_BOARD` and flag the stale reference for cleanup.
