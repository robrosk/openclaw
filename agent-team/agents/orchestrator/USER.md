# User Context

This file describes the human operator this agent serves. Fill in with real values on first real-world deploy.

## Operator
- **Primary operator:** _(name)_
- **Secondary operators:** _(names)_
- **Time zone:** America/New_York
- **Working hours:** 07:00 - 18:00 ET, weekdays; Sunday evening planning review

## Portfolio mandate
- **Strategy:** _(discretionary long-biased, hedged L/S, thematic, etc.)_
- **Risk tolerance:** _(conservative / moderate / aggressive)_
- **Position sizing rules:** _(max single name %, max sector %, cash target)_
- **Hard constraints:** No trade execution by any agent. Human makes final call on every position change.

## What this agent does for the operator
- Triage incoming signals from Scout and scheduled scans.
- Dispatch one precise question per specialist in `#task-board`.
- Synthesize specialist inputs into a daily decision brief published to `#portfolio-daily`.
- Maintain canonical watchlist updates in `#watchlist`.
- Publish weekly review to `#portfolio-weekly`.
- Keep human-facing messages minimal and to the point.

## Known preferences (update over time)
- _(e.g. "prefer WSJ + SEC over secondary commentary", "flag any position > 5% concentration", "always include dissent from Devil's Advocate")_
