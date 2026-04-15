tasks:

- name: task-board-sweep
  interval: 15m
  prompt: "Read the last 15 messages in #task-board (use channel_directory to resolve the ID). Check for dispatched tasks older than 2 hours with no specialist response. If any are stale, post a single follow-up @mention to the assigned specialist in #task-board. If all tasks have responses or no open tasks exist, do nothing."

- name: synthesis-check
  interval: 30m
  prompt: "Read the last 10 messages in #market-signals, #research, #quant-signals, and #contrarian (use channel_directory to resolve IDs). If there is new specialist output since the last #portfolio-daily post that has not been synthesized, post a brief synthesis note to #portfolio-daily summarizing what is new and any action items. If nothing new, do nothing."

- name: watchlist-drift
  interval: 1h
  prompt: "Read the last 10 messages in #market-signals. Check if any watchlist names have significant price movements or breaking news that warrant a watchlist update. If so, post an update to #watchlist. If not, do nothing."

# Rules
- Use channel_directory skill to resolve all channel names before reading/sending.
- Keep posts concise and structured.
- If nothing needs attention after all due tasks, reply HEARTBEAT_OK.
