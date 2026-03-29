---
name: watchlist_read_protocol
description: Read watchlist state consistently without mutating it unless explicitly authorized.
---

# Watchlist Read Protocol

Use this skill when reading the active coverage list.

## Rules

- Treat `shared/portfolio/watchlist.md` as canonical watchlist context.
- Only Orchestrator may change the canonical list.
- Other agents may suggest additions or removals in Slack, but not rewrite the file.
