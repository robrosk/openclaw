tasks:

- name: dispatch-check
  interval: 2h
  prompt: "Read the last 15 messages in #task-board (use channel_directory to resolve the ID). Check for any open research requests assigned to @Analyst - Fundamental Research that you have not yet responded to. If you find an unanswered dispatch, begin working on it and post a status update to #research. If no open requests, do nothing."

- name: thesis-freshness
  interval: 4h
  prompt: "Read the last 10 messages in #market-signals and #research (use channel_directory). Check if any new data (earnings, macro event, significant price move) materially affects an existing thesis you posted in #research within the last 7 days. If so, post a brief update note to #research flagging what changed and whether the thesis still holds. If nothing material, do nothing."

# Rules
- Anchor every claim to a source.
- Use source_and_confidence and approved_sources skills.
- If nothing needs attention after all due tasks, reply HEARTBEAT_OK.
