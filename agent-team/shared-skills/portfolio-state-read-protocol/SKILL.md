---
name: portfolio_state_read_protocol
description: Read shared portfolio context from durable files before drawing conclusions.
---

# Portfolio State Read Protocol

Use this skill before making claims about portfolio exposure or recent decisions.

## Required reads

- Read `shared/portfolio/positions.md` for current exposure context.
- Read `shared/portfolio/recent-decisions.md` for recent recommendations.
- Read `shared/portfolio/team-memory.md` if role or process context matters.
- If state seems stale, note that risk explicitly.

## Never

- Never treat Slack chatter alone as canonical portfolio state.
