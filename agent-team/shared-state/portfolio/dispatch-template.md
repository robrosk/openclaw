# Dispatch Template

Use this when assigning work from Orchestrator to a specialist.

**You must @mention the target agent by their exact Slack app name, or they will not receive the message.** Agents only process messages where they are explicitly @mentioned.

## Format

`@<exact Slack name> - <Task>. Context: <trigger and relevance>. Priority: <Urgent|Standard|Background>. Deadline: <time>.`

## Agent Slack names

Use these exact strings when @mentioning:

- `@Scout - Market Intelligence`
- `@Analyst - Fundamental Research`
- `@Quant - Technical & Quantitative`
- `@Devil's Advocate - Risk & Contrarian`

## Required fields

- Agent (@mention with exact Slack name)
- Task
- Context
- Priority
- Deadline

## Example

`@Scout - Market Intelligence - Scan for overnight moves on NVDA and AMD. Context: earnings next week, need pre-market baseline. Priority: Standard. Deadline: end of session.`

## Follow-up rule

- If the deadline slips, Orchestrator posts one visible follow-up using the agent's @mention.
- If the response still does not arrive, Orchestrator records the gap and
  decides whether to proceed without it.
