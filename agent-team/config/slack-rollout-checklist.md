# Slack Rollout Checklist

Use this after syncing the workspaces into `~/.openclaw`.

If `~/.openclaw/openclaw.json` already exists and `openclaw` is on your PATH,
the sync script also applies each workspace `IDENTITY.md` into the live agent
config with `openclaw agents set-identity --from-identity`.

## 1. Create the five Slack apps

Create one Socket Mode Slack app per agent:

- Orchestrator
- Scout
- Analyst
- Quant
- Devil's Advocate

For each app:

- enable Socket Mode
- create an app token with `connections:write`
- install the app and copy the bot token
- enable App Home messages
- subscribe the bot events listed in `slack-app-manifest.example.json`

## 2. Create the seven channels

Create or confirm these channel names:

- `#market-signals`
- `#research`
- `#quant-signals`
- `#contrarian`
- `#task-board`
- `#portfolio-daily`
- `#portfolio-weekly`

Replace the placeholder channel IDs in `openclaw.multi-agent.example.json5` with the real Slack IDs.

## 3. Invite each bot to the right channels

The OpenClaw config allowlists all seven channels globally. Limit each bot in
practice by Slack membership.

Recommended channel membership:

- Orchestrator: all seven channels
- Scout: `#market-signals`, `#task-board`
- Analyst: `#research`, `#market-signals`, `#task-board`
- Quant: `#quant-signals`, `#research`, `#task-board`
- Devil's Advocate: `#contrarian`, `#research`, `#quant-signals`, `#market-signals`, `#task-board`

## 4. Fill the real config

Use `openclaw.multi-agent.example.json5` as the base for `~/.openclaw/openclaw.json`.

Replace:

- all `xoxb-...` bot tokens
- all `xapp-...` app tokens
- all `C_...` Slack channel IDs
- optional Orchestrator DM allowlist entries if you prefer `allowlist` over `pairing`

## 5. Deploy and verify

1. Sync the repo content:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/sync-agent-workspaces.ps1 -All -IncludeSharedSkills -IncludeSharedState
```

2. Start from the config example and save the live config to `~/.openclaw/openclaw.json`.

3. Restart the gateway:

```bash
openclaw gateway restart
```

4. Verify bindings and Slack account health:

```bash
openclaw agents list --bindings
openclaw channels status --probe
```

## 6. Expected first-pass behavior

- Specialists should not accept DMs.
- Only Orchestrator should accept DMs.
- All channel traffic should remain mention-gated.
- Specialist handoffs should stay visible in working channels.
- Only Orchestrator should publish to `#portfolio-daily` and `#portfolio-weekly`.
