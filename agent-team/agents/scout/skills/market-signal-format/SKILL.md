---
name: market_signal_format
description: Format market alerts for the Scout channel with facts, context, and source.
---

# Market Signal Format

Use this skill for every alert posted to `#market-signals`.

## Required fields

- Ticker
- Signal type
- Data
- Context
- Source

## Rules

- Keep the alert factual.
- Prefer ratios and comparisons over adjectives.
- If evidence is weak, label the alert low confidence.

## Example

`Ticker: SYM | Signal type: Volume anomaly | Data: volume 3.2x 20-day average, price +7.2% intraday | Context: no matching company release found yet | Source: market feed + news scan`
