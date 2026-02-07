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
3. **Execute stage logic**: Run the appropriate stage handler (see shared/stage-machine.md). **The handler MUST complete all its work, including any interactive prompts, before returning.**
4. **Check gate**: Verify the stage's gate condition is met (see config/stages.yaml). Gate checks happen AFTER the handler completes.
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

**This stage handler includes both planning AND interactive revision application.** The gate only checks if planning is complete and user has either applied revisions or declined.

**Phase 1: Create revision plan**
- Create `REVISION-PLAN.md` in the paper root directory from synthesis P1/P2/P3 items using `${CLAUDE_PLUGIN_ROOT}/templates/revision-plan-template.md`
- **MUST always produce this file** — if it already exists (from setup), update it with current P1/P2/P3 items
- Track P1 item completion in `_panel.yaml.p1_items`

**Phase 2: Interactive revision application (MUST happen in this handler, before gate check)**

Immediately after creating the revision plan, offer to apply the revisions. Use AskUserQuestion:

```
question: "Revision plan created with {N} P1 items, {M} P2 items. Apply revisions now?"
header: "Revisions"
options:
  - label: "Yes, apply all revisions (Recommended)"
    description: "Edits sections/*.tex to address P1 and P2 items, then marks them complete"
  - label: "Apply P1 only (blocking items)"
    description: "Addresses only the blocking items needed to advance to recheck"
  - label: "No, I'll revise manually"
    description: "Stops here — run panel:paper again after making your own edits"
```

**If user selects apply:**

1. Read REVISION-PLAN.md to get the full list of P1 (and optionally P2) items with target sections
2. For each item, in priority order (P1 first, then P2):
   a. Read the target `sections/*.tex` file
   b. Read the relevant reviewer feedback from SYNTHESIS.md for context
   c. Apply the revision: edit the LaTeX source to address the issue
   d. Preserve the paper's existing voice, structure, and formatting
   e. Mark the item as addressed: check off the `- [ ]` boxes in REVISION-PLAN.md
   f. Update `_panel.yaml.p1_items` with `addressed: true` for P1 items
3. After all revisions applied, show a summary:

   ```
   Revisions Applied — panel-transactional-feature-upgrade
   ═══════════════════════════════════════════════════════════════════════

   P1 items (blocking):
     ✓ P1.1  Formalize transaction properties     sections/03-methodology.tex
     ✓ P1.2  Scope claims to craft ecosystem      sections/01-introduction.tex, 05-discussion.tex
     ✓ P1.3  Add wall-clock performance data       sections/04-evaluation.tex

   P2 items (important):
     ✓ P2.1  Expand related work comparison        sections/02-related-work.tex
     ✓ P2.2  Add failure mode discussion            sections/05-discussion.tex

   All P1 items addressed — ready to advance to recheck.
   ```

4. Auto-commit the revisions

**Revision principles:**
- Address the specific concern raised by reviewers — don't rewrite sections unnecessarily
- Add content rather than remove (reviewers want more depth, not less)
- When adding empirical data (performance numbers, comparisons), use realistic placeholder values marked with `% TODO: verify` LaTeX comments if actual data isn't available
- When strengthening claims, add qualifiers and citations rather than removing the claim
- Preserve existing `\label{}` and `\ref{}` references

**If user declines**: Set `_panel.yaml.revision_declined: true` and stop at revision stage. Report the P1 items that need addressing and the command to resume: `panel:paper --paper {name}`

**Gate**: The revision stage gate checks:
- `REVISION-PLAN.md` exists, AND
- Either: all P1 items marked `addressed: true` in `_panel.yaml`
- Or: user explicitly declined (`revision_declined: true` flag set)

If gate fails (revision plan not created or no decision made), the stage cannot advance. The handler MUST complete both Phase 1 and Phase 2 before the gate is checked.

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

## Auto-Commit

After each stage transition that writes files, auto-commit all changes in the paper directory:

1. Call `auto_commit()` from shared/git-utils.md
2. Scope: the paper directory (`{paper_dir}/` — includes `_panel.yaml`, `reviews/`, `REVISION-PLAN.md`)
3. Message: `[panel] {paper}: advance to {stage} (round {round})`
4. Skipped when `--dry-run` is set or not in a git repo

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

- shared/git-utils.md — Auto-commit after stage transitions
- shared/stage-machine.md — Stage progression logic
- shared/state-loader.md — Read/write _panel.yaml
- shared/reviewer-selector.md — Match reviewers to papers
- shared/synthesis-engine.md — Consolidate reviews
- shared/score-utils.md — Score aggregation
- shared/panel-utils.md — PP item integration, panel readiness checks
- config/stages.yaml — Stage definitions
- config/scoring.yaml — Scoring rubrics
- templates/review-template.md — Review structure (via `${CLAUDE_PLUGIN_ROOT}/templates/`)
- templates/synthesis-template.md — Synthesis structure
- templates/revision-plan-template.md — Revision plan structure
