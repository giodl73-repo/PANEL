---
name: panel:go
description: The one command — moves paper through all 8 lifecycle stages
user-invocable: true
---

# panel:go — Stage-Driven Review Lifecycle

The one command. Moves a paper through all 8 lifecycle stages, reading `_panel.yaml` for re-entrancy.

## Arguments

- `--paper <name>` — Target paper directory (default: auto-detect from cwd)
- `--until <stage>` — Stop at this stage (default: run through all stages)
- `--round N` — Force a specific review round number
- `--dry-run` — Show what would happen without making changes

## Stages

```
1. draft      → Paper exists, venue identified
2. panel      → 5+ reviewers assigned, individual reviews generated
3. synthesis  → Reviews consolidated → SYNTHESIS.md with P1/P2/P3 tiering
4. revision   → Author revises based on synthesis (P1 items addressed)
5. recheck    → Round N reviews; loops to synthesis if scores insufficient
6. ready      → All reviewers Accept; cross-portfolio panel complete
7. submit     → Paper submitted to target venue
8. accepted   → Paper accepted at venue
```

## Behavior

1. **Read state**: Load `_panel.yaml` from the paper directory. If missing, start at `draft`.
2. **Determine current stage**: Read `stage` field.
3. **Execute stage logic**: Run the appropriate stage handler (see shared/stage-machine.md).
4. **Check gate**: Verify the stage's gate condition is met (see config/stages.yaml).
5. **Advance**: If gate passes, update `_panel.yaml` stage + history, move to next stage.
6. **Loop detection**: If at `recheck` and gate fails (avg < 2.5/4 or any < 2/4), loop back to `synthesis`.
7. **Stop conditions**: Reached `--until` stage, or `accepted`, or gate requires user input (submit/accepted).

## Stage Handlers

### draft → panel
- Verify `main.tex` exists and `venue` is set in `_panel.yaml`
- Select 5 reviewers from REVIEWER-DATABASE.md using shared/reviewer-selector.md
- Write reviewer assignments to `_panel.yaml`

### panel → synthesis
- For each reviewer, generate `reviews/REVIEW-{NAME}.md` using templates/review-template.md
- Each review includes: overall assessment, score (1-4), major issues, minor issues, recommendations
- Gate: 5+ review files exist

### synthesis → revision
- Consolidate all reviews into `reviews/SYNTHESIS.md` using shared/synthesis-engine.md
- Classify issues as P1 (blocking), P2 (important), P3 (nice-to-have)
- Gate: SYNTHESIS.md exists with P1/P2/P3 classification

### revision → recheck
- Create `REVISION-PLAN.md` from synthesis P1/P2/P3 items
- Track P1 item completion in `_panel.yaml.p1_items`
- Gate: All P1 items marked `addressed: true`

### recheck → ready (or → synthesis)
- Generate Round N reviews: `reviews/ROUND{N}-REVIEW-{NAME}.md`
- Generate Round N synthesis: `reviews/ROUND{N}-SYNTHESIS.md`
- Calculate average score and check thresholds (config/scoring.yaml)
- Gate: avg >= 2.5/4 AND no score < 2/4
- If gate fails: loop back to `synthesis`, increment round

### ready → submit
- If multi-paper module: verify REVIEW_PANEL.md exists
- Gate: User confirms submission

### submit → accepted
- Gate: User confirms acceptance

## State File Updates

After each stage transition, `_panel.yaml` is updated:
- `stage` field set to new stage
- `round` incremented if entering recheck
- History entry appended with date and note
- Review completion counts updated

## Examples

```bash
# Run full lifecycle on current paper
panel:go

# Run until synthesis only
panel:go --until synthesis

# Target specific paper
panel:go --paper panel-review-methodology

# Dry run to see what would happen
panel:go --dry-run

# Force round 3 recheck
panel:go --round 3
```

## Dependencies

- shared/stage-machine.md — Stage progression logic
- shared/state-loader.md — Read/write _panel.yaml
- shared/reviewer-selector.md — Match reviewers to papers
- shared/synthesis-engine.md — Consolidate reviews
- shared/score-utils.md — Score aggregation
- config/stages.yaml — Stage definitions
- config/scoring.yaml — Scoring rubrics
- templates/review-template.md — Review structure
- templates/synthesis-template.md — Synthesis structure
