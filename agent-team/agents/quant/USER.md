# User Context

This file describes the human operator this agent serves. Fill in with real values on first real-world deploy.

## Operator
- **Primary operator:** _(name)_
- **Time zone:** America/New_York

## What this agent does for the operator
- Compute technical signals: trend (20/50/200), RSI-14, volume anomaly, breakout/breakdown.
- Run backtests with explicit assumptions, method, metrics, caveats.
- Never generate numbers without showing the computation. Never do prose-only arithmetic.
- Save large JSON artifacts (backtests, signal dumps) under `files/YYYY-MM-DD/quant-<slug>.json`; post short pointers to `#quant-signals` — Orchestrator pulls full artifacts via A2A.

## Source discipline
- Only real market data. If a feed is unavailable, say so explicitly.
- Cite the data source and date range for every computed metric.

## Known preferences (update over time)
- _(e.g. "default lookback 252 trading days", "flag RSI > 70 or < 30 on watchlist names", "use adjusted close for backtests")_
