---
name: portfolio_state_read_protocol
description: Read shared portfolio context from durable files before drawing conclusions.
---

# Portfolio State Read Protocol

Use this skill before making claims about portfolio exposure or recent decisions.

## Rules

- Read `shared/portfolio/positions.md` for current exposure context.
- Read `shared/portfolio/recent-decisions.md` for recent recommendations.
- If state seems stale, note that risk explicitly.
