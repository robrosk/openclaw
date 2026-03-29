---
name: watchlist_read_protocol
description: Read watchlist state consistently without mutating it unless explicitly authorized.
---

# Watchlist Read Protocol

Use this skill when reading the active coverage list.

## Required behavior

- Treat `shared/portfolio/watchlist.md` as canonical watchlist context.
- Only Orchestrator may change the canonical list.
- Other agents may suggest additions or removals in Slack, but not rewrite the file.

## If the file looks stale

- Say the watchlist may be stale.
- Continue with visible caution instead of silently assuming it is current.
