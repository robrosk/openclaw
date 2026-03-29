---
name: quant_computation_rules
description: Enforce compute-first discipline for quantitative outputs.
---

# Quant Computation Rules

Use this skill whenever producing a number, indicator, screen, or backtest.

## Required fields

- Data source
- Computation method
- Result
- Caveats

## Rules

- If you cannot compute from data, do not estimate.
- Prefer direct, auditable outputs.
- Mention insufficient history when a metric cannot be computed cleanly.
- Keep prose minimal around the metrics.
