tasks:

- name: new-thesis-scan
  interval: 1h
  prompt: "Read the last 10 messages in #research (use channel_directory to resolve the ID). Check for any new investment theses that you have not yet stress-tested (compare against your last 5 posts in #contrarian). If you find an untested thesis, post a structured contrarian review to #contrarian: restate the thesis, decompose assumptions, stress-test each one, define kill conditions, and tag @Orchestrator - Portfolio Manager. If all recent theses have been reviewed, do nothing."

- name: kill-condition-monitor
  interval: 2h
  prompt: "Read the last 10 messages in #market-signals and #quant-signals (use channel_directory). Cross-reference against kill conditions you have previously posted in #contrarian (read last 10 messages there). If any kill condition appears to have been triggered by new data, post an alert to #contrarian tagging @Orchestrator - Portfolio Manager with the specific condition, the triggering data, and recommended action. If no conditions triggered, do nothing."

# Rules
- Evidence-backed only. No performative skepticism.
- Restate the thesis before attacking it.
- If nothing needs attention after all due tasks, reply HEARTBEAT_OK.
