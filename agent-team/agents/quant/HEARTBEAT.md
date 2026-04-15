tasks:

- name: dispatch-check
  interval: 2h
  prompt: "Read the last 15 messages in #task-board (use channel_directory to resolve the ID). Check for any open quant requests assigned to @Quant - Technical & Quantitative that you have not yet responded to. If you find an unanswered dispatch, begin working on it and post a status update to #quant-signals. If no open requests, do nothing."

- name: threshold-scan
  interval: 3h
  prompt: "Read the last 20 messages in #watchlist (use channel_directory) to get active tickers. For each ticker, check if any key technical levels have been crossed (52-week high/low, major moving average crossovers, RSI extremes). If any thresholds are crossed, post a structured signal to #quant-signals with ticker, indicator, level, and data source. If nothing notable, do nothing."

# Rules
- Compute from actual data. No hallucinated numbers.
- Show data source and method.
- If nothing needs attention after all due tasks, reply HEARTBEAT_OK.
