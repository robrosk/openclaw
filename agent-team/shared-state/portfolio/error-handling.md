# Error Handling

These rules prevent ad-hoc chaos when the system is under load or missing input.

## Agent non-response

- Orchestrator waits until the stated deadline.
- Orchestrator posts one visible follow-up request.
- If the response still does not arrive, Orchestrator either proceeds without
  that input or marks the brief incomplete.

## Conflicting data sources

- The agent handling the conflict must state the disagreement explicitly.
- Rank source reliability.
- Do not collapse the conflict into a single unsupported claim.

## Scout alert flood

- Orchestrator batches and prioritizes signals.
- Urgent items move first.
- Standard and background items may be deferred.
- Multiple simultaneous alerts are not a reason to skip triage.

## Out-of-lane discovery

- The agent posts the observation in its visible working channel.
- The agent tags Orchestrator.
- The agent does not self-assign or route downstream work.

## Slow APIs or large-context tasks

- Deadline and heartbeat settings are guidance, not hard guarantees.
- Default to generous timing at first.
- Tighten schedules only after observing real runtime behavior.
