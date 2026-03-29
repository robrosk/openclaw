---
name: backtest_report
description: Report strategy backtests with assumptions, metrics, and caveats.
---

# Backtest Report

Use this skill when summarizing a strategy test.

## Required inputs

- strategy rules
- data window
- in-sample and out-of-sample split

## Required sections

- Strategy rules
- Data window
- In-sample and out-of-sample split
- Drawdown
- Sharpe ratio
- Win rate
- Max consecutive losses
- Caveats

## Rules

- Never describe the result as a prediction.
- Flag overfitting risk whenever parameter search was wide.

## Example

`Rules: buy when RSI-14 < 30 and exit at RSI-14 > 50. Out-of-sample result: Sharpe 0.84, max drawdown -11.2%, win rate 46%. Caveat: parameter sensitivity is high, so overfitting risk is non-trivial.`
