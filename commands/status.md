<command-name>panel:status</command-name>

# panel:status — Portfolio Overview

Shows a summary table of all papers in the current project with their review lifecycle status.

## Arguments

- `--module <name>` — Filter to a specific module (default: all)
- `--stage <stage>` — Filter to papers at a specific stage

## Behavior

1. **Discover papers**: Find all directories containing `_panel.yaml` in the current project.
2. **Load state**: Read each `_panel.yaml` using shared/state-loader.md.
3. **Compute metrics**: For each paper, calculate current score, round, and next action.
4. **Display table**: Render a formatted status table using shared/display-utils.md.

## Output Format

```
Panel Status — [Project Name]
═══════════════════════════════════════════════════════════════════════

 #  Paper                        Stage      Round  Score   Venue        Next Action
 ── ──────────────────────────── ────────── ───── ─────── ──────────── ──────────────────
 1  panel-review-methodology     synthesis  1     2.2/4   CHI 2026     Generate SYNTHESIS.md
 2  panel-reviewer-calibration   draft      0     —       EMNLP 2026   Set venue, select reviewers
 3  panel-revision-dynamics      recheck    2     2.6/4   NeurIPS D&B  Reviews pass threshold ✓
 4  panel-portfolio-assessment   ready      2     3.1/4   JCDL 2026    Cross-portfolio panel
 5  panel-synthesis-methods      panel      1     —       AAAI 2026    3/5 reviews complete

Summary: 5 papers | 1 ready | 2 in review | 1 revising | 1 drafting
```

## Next Action Logic

The "Next Action" column is determined by stage + gate status:

| Stage | Next Action |
|-------|-------------|
| draft | "Set venue, select reviewers" or "main.tex missing" |
| panel | "{N}/5 reviews complete" |
| synthesis | "Generate SYNTHESIS.md" |
| revision | "{N}/{total} P1 items addressed" |
| recheck | "Avg {score}/4 — {pass/fail}" |
| ready | "Cross-portfolio panel" or "Ready for submission" |
| submit | "Awaiting acceptance" |
| accepted | "Complete" |

## Dependencies

- shared/state-loader.md — Read _panel.yaml files
- shared/score-utils.md — Score aggregation
- shared/display-utils.md — Terminal formatting
