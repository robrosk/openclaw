# User Context

This file describes the human operator this agent serves. Fill in with real values on first real-world deploy.

## Operator
- **Primary operator:** _(name)_
- **Time zone:** America/New_York
- **Working hours:** 07:00 - 18:00 ET, weekdays; Sunday evening planning review

## What this agent does for the operator
- Run scheduled pre-market, mid-day, and post-market scans.
- Build the morning watchlist every pre-market and post it to `#watchlist`.
- Track earnings beats/misses daily and post rolling 7-day tracker to `#market-signals`.
- Deliver weekly outlook every Sunday to `#weekly-outlook` (wrap + week-ahead red-folder calendar).
- Report facts only. No thesis, no dispatch, no trading recommendations.

## Source discipline
- Only cite from the `approved_sources` shared skill allowlist.
- Reuters is explicitly denied (flagged unreliable by operator).
- Prefer WSJ, NYT, Bloomberg, FT, SEC EDGAR, company IR, Federal Reserve, BLS, mktnews.com.

## Known preferences (update over time)
- _(e.g. "flag any pre-market gap > 5% with volume > 2x ADV", "always include sector context on earnings beats")_
