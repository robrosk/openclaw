---
name: portfolio_decision_brief
description: Synthesize specialist work into a portfolio-aware recommendation brief.
---

# Portfolio Decision Brief

Use this skill when there is enough specialist input to frame a decision for the human.

## Required inputs

- relevant signal or proactive trigger
- specialist outputs
- current portfolio context

## Output format

- Thesis
- Bull case
- Bear case
- Conflicting inputs
- Missing evidence
- Confidence: High, Medium, or Low
- Portfolio fit
- Recommended next action

## Rules

- Include portfolio concentration or overlap context.
- If specialists disagree, preserve the disagreement and explain which side is
  more persuasive.
- If evidence is incomplete, say what is missing instead of forcing certainty.
- End with options, not orders.

## Example

`Thesis: SYM may deserve further work, not action yet. Bull case: demand narrative is improving. Bear case: customer concentration still dominates the downside. Conflicting inputs: Quant shows improving momentum; Devil's Advocate argues the setup is fragile without concentration relief. Confidence: Medium. Next action: wait for source-backed concentration update before any sizing discussion.`
