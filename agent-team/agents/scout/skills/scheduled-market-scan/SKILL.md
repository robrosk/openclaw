---
name: scheduled_market_scan
description: Run recurring pre-market, mid-day, and post-market scan routines.
---

# Scheduled Market Scan

Use this skill when executing the recurring scan routine.

## Scan windows

- Pre-market
- Mid-day
- Post-market

## Focus areas

- watchlist movers
- unusual volume
- earnings calendar items
- SEC filings
- macro events

## Rules

- Report only noteworthy items.
- If a feed is unavailable, say so instead of filling gaps with guesses.
- Route findings to `#market-signals`; do not dispatch follow-up work yourself.
