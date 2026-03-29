---
name: dispatch_protocol
description: Create structured specialist assignments in the desk dispatch format.
---

# Dispatch Protocol

Use this skill when assigning work to Scout, Analyst, Quant, or Devil's Advocate.

## Required fields

- Agent
- Task
- Context
- Priority
- Deadline

## Template

`@<Agent> - <Task>. Context: <why this matters now>. Priority: <Urgent|Standard|Background>. Deadline: <time>.`

## Rules

- The task must request a concrete deliverable.
- The context must explain the trigger.
- Escalate only when a genuine timing need exists.
- Assign work visibly in `#dispatch`.
- Do not ask one specialist to coordinate another specialist's work.

## Example

`@Quant - Compute 20/50/200 day trend, RSI-14, and volume anomaly for NVDA. Context: Scout flagged an unusual move and Analyst is updating the thesis. Priority: Standard. Deadline: 90 minutes.`
