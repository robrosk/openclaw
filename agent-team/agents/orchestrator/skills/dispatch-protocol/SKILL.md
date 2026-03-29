---
name: dispatch_protocol
description: Create structured specialist assignments in the desk dispatch format.
---

# Dispatch Protocol

Use this skill when assigning work to Scout, Analyst, Quant, or Devil's
Advocate.

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
