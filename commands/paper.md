---
name: panel:paper
description: Per-paper review lifecycle — moves a paper through all 8 stages
user-invocable: true
---

# panel:paper — Per-Paper Review Lifecycle

Moves a single paper through all 8 lifecycle stages, reading `_panel.yaml` for re-entrancy. This is the paper-level tier of the three-tier review architecture.

## Three-Tier Context

```
panel:board   — monorepo level (cross-module)
panel:panel   — module level (cross-portfolio)
panel:paper   — paper level (individual reviews) ← this command
```

Paper-level reviews bubble up to `panel:panel`. Panel-level revision items (PP1/PP2/PP3) flow down to individual papers.

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
6. ready      → REVIEW_PANEL.md completed by panel:panel
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
- Gate: `REVIEW_PANEL.md` exists and is completed (produced by `panel:panel`)
- `panel:paper` does NOT generate the panel review — it waits for `panel:panel` to produce it
- If `REVIEW_PANEL.md` is missing or placeholder: report that `panel:panel --review` must be run first
- Also checks for any unaddressed PP1 items from the panel revision plan

### submit → accepted
- Gate: User confirms acceptance

## PP Item Integration

When `panel:panel` generates PP1/PP2/PP3 items for this paper, they appear in `PANEL-REVISION-PLAN.md` in the paper's directory. During the `revision` and `recheck` stages, `panel:paper` checks both:
- P1/P2/P3 items from individual reviews (SYNTHESIS.md)
- PP1/PP2/PP3 items from panel review (PANEL-REVISION-PLAN.md)

Both P1 and PP1 items must be addressed before advancing past `revision`.

## State File Updates

After each stage transition, `_panel.yaml` is updated:
- `stage` field set to new stage
- `round` incremented if entering recheck
- History entry appended with date and note
- Review completion counts updated

## Examples

```bash
# Run full lifecycle on current paper
panel:paper

# Run until synthesis only
panel:paper --until synthesis

# Target specific paper
panel:paper --paper panel-review-methodology

# Dry run to see what would happen
panel:paper --dry-run

# Force round 3 recheck
panel:paper --round 3
```

## Dependencies

- shared/stage-machine.md — Stage progression logic
- shared/state-loader.md — Read/write _panel.yaml
- shared/reviewer-selector.md — Match reviewers to papers
- shared/synthesis-engine.md — Consolidate reviews
- shared/score-utils.md — Score aggregation
- shared/panel-utils.md — PP item integration, panel readiness checks
- config/stages.yaml — Stage definitions
- config/scoring.yaml — Scoring rubrics
- templates/review-template.md — Review structure
- templates/synthesis-template.md — Synthesis structure
