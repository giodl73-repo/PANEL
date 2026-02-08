---
name: panel:review
description: Per-paper review lifecycle — moves a paper through all 8 stages
user-invocable: true
---

# panel:review — Per-Paper Review Lifecycle

**Purpose**: AI-simulated feedback for quality improvement. This generates synthetic assessments to help strengthen your work before actual submission.

**Important**: This is NOT peer review. Use suggestions to improve your work, not as "reviewer responses." These are AI-generated insights based on domain expert personas, not actual human judgments.

Moves a single paper through all 8 lifecycle stages, reading `_panel.yaml` for re-entrancy. This is the paper-level tier of the three-tier review architecture.

## Three-Tier Context

```
panel:board   — monorepo level (cross-module)
panel:convene — module level (cross-portfolio)
panel:review  — paper level (individual reviews) ← this command
```

Paper-level reviews bubble up to `panel:convene`. Panel-level revision items (PP1/PP2/PP3) flow down to individual papers.

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
6. ready      → REVIEW_PANEL.md completed by panel:convene
7. submit     → Paper submitted to target venue
8. accepted   → Paper accepted at venue
```

## Behavior

1. **Read state**: Load `_panel.yaml` from the paper directory. If missing, start at `draft`.
2. **Determine current stage**: Read `stage` field.
3. **Content mode detection** (first time only): If `content_mode` is not set in `_panel.yaml`:
   - Run content analysis using `shared/content-analyzer.md`
   - Show analysis results (word count, section files, inferred mode)
   - Ask user to confirm or override the inferred mode
   - Save confirmed mode to `_panel.yaml` with `content_mode_confirmed: true`
   - Include mode in reviewer context for all subsequent reviews
4. **Execute stage logic**: Run the appropriate stage handler (see shared/stage-machine.md). **The handler MUST complete all its work, including any interactive prompts, before returning.**
5. **Check gate**: Verify the stage's gate condition is met (see config/stages.yaml). Gate checks happen AFTER the handler completes. **Gates are mode-aware** (see Mode-Aware Gates section).
6. **Advance**: If gate passes, update `_panel.yaml` stage + history, move to next stage.
7. **Loop detection**: If at `recheck` and gate fails (avg < 2.5/4 or any < 2/4), loop back to `synthesis`.
8. **Stop conditions**: Reached `--until` stage, or `accepted`, or gate requires user input (submit/accepted), or reached terminal stage for content mode.

## Content Modes

Papers are reviewed at three content maturity levels:

| Mode | Content Level | Word Count | Review Focus | Max Stage |
|------|--------------|------------|--------------|-----------|
| `abstract` | Abstract/outline only | <500 words | Concept viability, novelty, scope | `synthesis` |
| `draft` | Incomplete paper | 500-3000 words | Structure, feasibility, approach | `revision` |
| `full` | Complete paper | 3000+ words | Publication readiness, rigor | `accepted` |

### Content Analysis

On first run, if `content_mode` is not set in `_panel.yaml`, the command:

1. **Analyzes** paper directory:
   - Checks `main.tex` for abstract
   - Counts section files and estimates word count
   - Looks for bibliography, figures
   - Infers mode based on total content

2. **Shows analysis**:
   ```
   📄 Content Analysis
      main.tex: ✓ 65 lines
      Abstract: ✓ ~250 words
      Sections: 0 files (empty directory)
      Bibliography: ✗ not found
      Total: ~250 words

   ⚙️ Inferred Content Mode: abstract (high confidence)

   Expected review behavior:
   • Focus on concept viability and novelty
   • Evaluate research question significance
   • Assess feasibility of proposed approach
   • No critique of missing implementation details
   • Terminal stage: synthesis (won't advance to submission)
   ```

3. **Asks for confirmation**:
   ```
   Does this match your expectations?
   [a] Abstract mode (concept review)
   [d] Draft mode (structure + feasibility)
   [f] Full mode (publication ready)
   [Enter] Accept inferred mode
   ```

4. **Saves confirmed mode** to `_panel.yaml`

### Mode-Aware Gates

Content mode affects stage advancement:

**Abstract mode**:
- Terminal stage: `synthesis`
- Cannot advance to `revision`, `recheck`, `ready`, `submit`, or `accepted`
- Synthesis verdict: "Concept Approved" or "Concept Rejected"
- Intended for early-stage idea validation

**Draft mode**:
- Terminal stage: `revision`
- Cannot advance to `recheck`, `ready`, `submit`, or `accepted`
- After addressing P1 items, verdict: "Ready for Full Review" (upgrade to full mode)
- Intended for structural feedback on incomplete papers

**Full mode**:
- No terminal stage restrictions
- Full lifecycle through `accepted`
- Standard review criteria and gates

### Mode Transitions

Users can upgrade content mode by editing `_panel.yaml`:
```yaml
content_mode: full  # changed from abstract
content_mode_confirmed: true
```

After upgrading, run `panel:review` again to continue lifecycle with new expectations.

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

**Phase 2: Interactive improvement application (MUST happen in this handler, before gate check)**

Immediately after creating the improvement plan, offer to apply the suggestions. Use AskUserQuestion:

```
question: "Quality improvement plan created with {N} high-impact items, {M} medium-impact items. Apply improvements now?"
header: "Improvements"
options:
  - label: "Yes, apply suggested improvements (Recommended)"
    description: "Enhances sections/*.tex based on P1 and P2 suggestions, strengthening the work"
  - label: "Apply P1 only (high-impact items)"
    description: "Applies only the highest-impact improvements"
  - label: "No, I'll improve manually"
    description: "Stops here — run panel:review again after making your own edits"
```

**If user selects apply:**

1. Read IMPROVEMENT-PLAN.md (or REVISION-PLAN.md for backward compatibility) to get P1 (and optionally P2) items with target sections
2. For each item, in priority order (P1 first, then P2):
   a. Read the target `sections/*.tex` file
   b. Read the relevant simulated feedback from quality assessment for context
   c. Apply the improvement: edit the LaTeX source to strengthen that aspect
   d. Preserve the paper's existing voice, structure, and formatting
   e. Mark the item as addressed: check off the `- [ ]` boxes in plan file
   f. Update `_panel.yaml.p1_items` with `addressed: true` for P1 items
3. After all improvements applied, show a summary:

   ```
   Improvements Applied — panel-transactional-feature-upgrade
   ═══════════════════════════════════════════════════════════════════════

   P1 items (high impact):
     ✓ P1.1  Formalize transaction properties     sections/03-methodology.tex
     ✓ P1.2  Scope claims to craft ecosystem      sections/01-introduction.tex, 05-discussion.tex
     ✓ P1.3  Add wall-clock performance data       sections/04-evaluation.tex

   P2 items (medium impact):
     ✓ P2.1  Expand related work comparison        sections/02-related-work.tex
     ✓ P2.2  Add failure mode discussion            sections/05-discussion.tex

   High-impact improvements applied — ready for next quality check.
   ```

4. Auto-commit the improvements

**Improvement principles:**
- Strengthen the specific aspect identified in simulated feedback — don't rewrite unnecessarily
- Add content and depth rather than remove
- When adding empirical data (performance numbers, comparisons), use realistic placeholder values marked with `% TODO: verify` LaTeX comments if actual data isn't available
- When strengthening claims, add qualifiers and citations rather than removing the claim
- Preserve existing `\label{}` and `\ref{}` references

**If user declines**: Set `_panel.yaml.revision_declined: true` and stop at revision stage. Report the P1 items that need addressing and the command to resume: `panel:review --paper {name}`

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
- Gate: `REVIEW_PANEL.md` exists and is completed (produced by `panel:convene`)
- `panel:review` does NOT generate the panel review — it waits for `panel:convene` to produce it
- If `REVIEW_PANEL.md` is missing or placeholder: report that `panel:convene --review` must be run first
- Also checks for any unaddressed PP1 items from the panel revision plan

### submit → accepted
- Gate: User confirms acceptance

## PP Item Integration

When `panel:convene` generates PP1/PP2/PP3 items for this paper, they appear in `PANEL-REVISION-PLAN.md` in the paper's directory. During the `revision` and `recheck` stages, `panel:review` checks both:
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
panel:review

# Run until synthesis only
panel:review --until synthesis

# Target specific paper
panel:review --paper panel-review-methodology

# Dry run to see what would happen
panel:review --dry-run

# Force round 3 recheck
panel:review --round 3
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
