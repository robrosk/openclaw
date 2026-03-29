# Dispatch Template

Use this when assigning work from Orchestrator to a specialist.

`@<Agent> - <Task>. Context: <trigger and relevance>. Priority: <Urgent|Standard|Background>. Deadline: <time>.`

## Required fields

- Agent
- Task
- Context
- Priority
- Deadline

## Follow-up rule

- If the deadline slips, Orchestrator posts one visible follow-up.
- If the response still does not arrive, Orchestrator records the gap and
  decides whether to proceed without it.
