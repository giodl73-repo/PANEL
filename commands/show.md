---
name: panel:show
description: Detailed view of one paper — reviews, synthesis, score history, stage timeline
user-invocable: true
---

# panel:show — Detailed Paper View

Shows comprehensive information about a single paper's review lifecycle.

## Arguments

- `<paper>` — Paper directory name (required, or auto-detect from cwd)
- `--reviews` — Show individual review summaries
- `--history` — Show full stage transition history
- `--scores` — Show score progression across rounds

## Behavior

1. **Load state**: Read `_panel.yaml` from the paper directory.
2. **Gather artifacts**: Scan for review files, synthesis, revision plan.
3. **Compute metrics**: Score trends, reviewer consensus, P1 completion rate.
4. **Display**: Render detailed view using shared/display-utils.md.

## Output Format

```
Panel — panel-review-methodology
═══════════════════════════════════════════════════════════════════════

Title:  AI-Simulated Expert Review: A Methodology for Pre-Submission Paper Assessment
Venue:  CHI 2026
Stage:  synthesis (round 1)
Mode:   full (3,245 words) — complete paper, publication-ready review

Reviewers (5):
  Percy Liang          Stanford (HELM)           Score: 3/4  Accept
  Harrison Chase       LangChain                 Score: 2/4  Weak Accept
  Ben Shneiderman      UMD                       Score: 3/4  Accept
  Saleema Amershi      Microsoft Research        Score: 2/4  Weak Accept
  Matei Zaharia        Databricks/Stanford       Score: 3/4  Accept

Score Summary:
  Round 1:  avg 2.6/4  |  ████████████░░░░  |  3 Accept, 2 Weak Accept
  Consensus: Moderate (σ = 0.55)

Synthesis: reviews/SYNTHESIS.md
  P1 items: 3 (0 addressed)
  P2 items: 5
  P3 items: 4

Stage History:
  2026-02-05  draft      Paper initialized
  2026-02-05  panel      5 reviewers assigned
  2026-02-05  synthesis  Round 1 reviews complete
```

## With --scores flag

```
Score Progression:
  Round 1:  2.6/4  ████████████░░░░  (5 reviews)
  Round 2:  3.0/4  ███████████████░  (5 reviews)  Δ +0.4
  Threshold: 2.5/4 ─── PASS
```

## Dependencies

- shared/state-loader.md — Read _panel.yaml
- shared/score-utils.md — Score trends, consensus
- shared/display-utils.md — Terminal formatting
