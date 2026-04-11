# Operating Protocol

This team runs on channel-visible coordination. Every meaningful handoff must be
auditable from the shared channels and Orchestrator's synthesis.

## Backbone rules

- No direct agent-to-agent tasking.
- No hidden specialist dependencies.
- Orchestrator is the only dispatcher.
- Specialists may raise observations, blockers, or escalation requests, but they
  do not assign work to each other.
- Slack channels are the working surface; shared portfolio files are the durable
  canonical context.

## Allowed coordination

- Scout -> `#market-signals`
- Analyst -> `#research`
- Quant -> `#quant-signals`
- Devil's Advocate -> `#contrarian`
- Orchestrator -> `#task-board`, `#portfolio-daily`, `#portfolio-weekly`

## Not allowed

- Analyst asking Quant privately for a calculation
- Quant asking Devil's Advocate privately to review a result
- Scout expanding scope without routing through Orchestrator
- Any specialist publishing a human-facing synthesis brief

## Audit rule

If a handoff affects a decision, it must be visible either in the owned channel
or in Orchestrator's downstream synthesis.
