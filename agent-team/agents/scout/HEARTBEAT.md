tasks:

- name: breaking-news-scan
  interval: 45m
  prompt: "Web search for breaking financial news on the current watchlist tickers. Read the last 20 messages in #watchlist (use channel_directory) to know which tickers are active. If any material news has broken since the last #market-signals post (read last 5 messages to check), post a structured alert to #market-signals with ticker, signal type, data, and source. Tag @Orchestrator - Portfolio Manager only if the signal is urgent (earnings surprise, halt, major move >5%). If nothing material, do nothing."

- name: error-recovery
  interval: 2h
  prompt: "Read the last 10 messages in #market-signals (use channel_directory). Check if the most recent scheduled scan (pre-market, mid-day, or post-market) posted successfully based on expected timing. If a scan appears to have been missed (gap longer than expected for current time of day), attempt to run the equivalent scan now. If scans are on track, do nothing."

# Rules
- Facts only. No interpretation as bullish/bearish.
- Source every claim. Use approved_sources skill.
- If nothing needs attention after all due tasks, reply HEARTBEAT_OK.
