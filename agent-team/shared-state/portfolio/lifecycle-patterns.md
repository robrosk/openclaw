# Lifecycle Patterns

These flows define how work begins and how it reaches a human decision.

## 1. Signal-driven

1. Scout detects a signal and posts it to `#market-signals`.
2. Orchestrator triages the signal.
3. Orchestrator dispatches work in `#task-board`.
4. Analyst and Quant execute in parallel when relevant.
5. Devil's Advocate stress-tests the thesis.
6. Orchestrator publishes the decision brief.
7. Human makes the final call.

## 2. Proactive

1. Orchestrator identifies a watchlist gap, portfolio issue, or calendar-driven need.
2. Orchestrator dispatches the required research.
3. Specialists respond in their owned channels.
4. Devil's Advocate reviews if the outcome could lead to a decision.
5. Orchestrator synthesizes to the human.

## 3. Devil's Advocate alert

1. Devil's Advocate discovers a risk, overlap, or kill condition.
2. Devil's Advocate posts it to `#contrarian` and tags Orchestrator.
3. Orchestrator decides whether to request updated work from Analyst or Quant.
4. Orchestrator publishes the updated decision framing.

## 4. Thesis maintenance

1. Orchestrator schedules a refresh of an existing thesis, watchlist name, or position.
2. Specialists provide updates through their owned channels.
3. Devil's Advocate reassesses invalidation risk if warranted.
4. Orchestrator updates recent decisions and publishes a refreshed summary if needed.
