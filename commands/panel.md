---
name: panel:panel
description: Module-level cross-portfolio panel review with rounds
user-invocable: true
---

# panel:panel — Module-Level Cross-Portfolio Panel Review

Assembles a 7-member cross-portfolio panel to review all papers within a module, producing `REVIEW_PANEL.md` with consolidated findings, rankings, and per-paper revision items (PP1/PP2/PP3).

## Three-Tier Context

```
panel:board   — monorepo level (cross-module)
panel:panel   — module level (cross-portfolio) ← this command
panel:paper   — paper level (individual reviews)
```

Panel reviews consume paper-level reviews (bubble up) and produce revision items that flow back down to individual papers. Panel findings also bubble up to `panel:board`.

## Arguments

- `--status` — Show panel status for current module: paper readiness, panel composition, round info
- `--review` — Run or re-run the cross-portfolio panel review
- `--member <name>` — Regenerate one panel member's assessment (preserves others)
- `--revisions` — Show PP1/PP2/PP3 progress across all papers in the module
- `--dry-run` — Preview what would happen without writing files

## Prerequisites

Before `panel:panel --review` can run:
1. The module must contain 2+ papers (single-paper modules skip panel tier)
2. At least 2 papers must have reached `recheck` stage or beyond
3. Those papers must have passing scores (avg >= 2.5/4, min >= 2/4)

Use `panel:panel --status` to check readiness.

## Behavior

### --status

1. Discover all papers in the module via shared/state-loader.md
2. Assess readiness of each paper via shared/panel-utils.md
3. Display:
   - Paper readiness table (name, stage, round, score, ready?)
   - Current panel composition (if panel exists)
   - Current round number and date
   - PP item progress summary

### --review

1. **Assess readiness**: Check papers via shared/panel-utils.assess_paper_readiness()
2. **Select panel**: Choose 7 reviewers via shared/panel-utils.select_cross_portfolio_panel()
   - On round 1: fresh selection
   - On round 2+: retain 5 core members, rotate 2
3. **Generate assessments**: Each panel member reviews all ready papers:
   - Read individual paper reviews and syntheses
   - Assess each paper on the 10-point scale (config/scoring.yaml)
   - Identify cross-paper themes and patterns
   - Rank papers within the module
4. **Synthesize**: Consolidate 7 assessments into `REVIEW_PANEL.md`:
   - Module score and tier
   - Paper rankings with consensus
   - Cross-paper themes
   - Per-paper assessments
5. **Generate revision items**: Create PP1/PP2/PP3 items:
   - Module-level `PANEL-REVISION-PLAN.md` in module root
   - Per-paper PP items noted in each paper's assessment
6. **Snapshot round**: Archive to `panel-reviews/round-{N}/`
7. **Update state**: Set round number, update history

### --member <name>

1. Load existing `REVIEW_PANEL.md`
2. Regenerate only the named member's assessment
3. Re-run synthesis with updated assessment
4. Overwrite `REVIEW_PANEL.md` (no new round — same round, updated)

### --revisions

1. Scan all papers in the module for `PANEL-REVISION-PLAN.md`
2. Parse checkbox status for PP1/PP2/PP3 items
3. Display progress table:
   ```
   PP1 Progress — Blocking Items
   ═══════════════════════════════════════
    #  Item                    Papers     Status
    ── ─────────────────────── ────────── ──────
    1  Missing benchmarks      3 papers   1/3 ✓
    2  Weak threat models      2 papers   0/2
   ```

## Round Cycle

```
panel:panel --review (round 1)
  → Writes REVIEW_PANEL.md (canonical, module root)
  → Writes PANEL-REVISION-PLAN.md (module root)
  → Archives to panel-reviews/round-1/
  → PP1/PP2/PP3 items created per paper

Papers revise via panel:paper (addresses PP1 items)

panel:panel --review (round 2)
  → Checks PP1 items addressed
  → Re-evaluates papers with fresh round
  → Updates REVIEW_PANEL.md
  → Archives to panel-reviews/round-2/
  → If all PP1 addressed and module score target met → panel complete
```

## Bubble-Up: Paper → Module

Findings aggregate from paper-level reviews to module-level themes:

| Paper-Level Pattern | Module-Level Result |
|---------------------|---------------------|
| P1 issue on 3+ papers | PP1 module theme |
| P1 issue on 2 papers | PP2 module theme |
| P2 issue on 3+ papers | PP2 module theme |
| Common strength on 3+ papers | Module strength |
| Score pattern (e.g., weak evaluation) | Module theme |

These module-level signals are captured in `REVIEW_PANEL.md` and visible to `panel:board`.

## File Layout

```
{module}/
├── REVIEW_PANEL.md              ← always the latest/canonical
├── PANEL-REVISION-PLAN.md       ← latest revision plan
├── panel-reviews/
│   ├── round-1/
│   │   ├── REVIEW_PANEL.md      ← snapshot
│   │   └── PANEL-REVISION-PLAN.md
│   └── round-2/
│       ├── REVIEW_PANEL.md
│       └── PANEL-REVISION-PLAN.md
├── paper-1/
│   ├── _panel.yaml
│   ├── reviews/
│   └── ...
└── paper-2/
    └── ...
```

## Completion Criteria

The panel review is complete when:
1. All PP1 items are addressed across all papers
2. Module score >= 6.5/10 (Tier B+ or above)
3. No individual paper scores below 5.0/10
4. Panel consensus is at least Moderate

When complete, individual papers can advance past `ready` stage in `panel:paper`.

## Auto-Commit

After `--review` or `--member` completes (modes that write files), auto-commit:

1. Call `auto_commit()` from shared/git-utils.md
2. Scope: module directory (REVIEW_PANEL.md, PANEL-REVISION-PLAN.md, panel-reviews/)
3. Message: `[panel] {module}: panel review round {round}`
4. For `--member`: `[panel] {module}: update panel member {name}`
5. Skipped for `--status`, `--revisions` (read-only), and `--dry-run`

## Dependencies

- shared/git-utils.md — Auto-commit after panel reviews
- shared/panel-utils.md — Panel-specific utilities
- shared/state-loader.md — Paper discovery, state loading
- shared/reviewer-selector.md — Panel member selection
- shared/synthesis-engine.md — Consolidation patterns
- shared/score-utils.md — Score aggregation, tier mapping
- shared/display-utils.md — Terminal formatting
- config/scoring.yaml — 10-point scale, tier definitions
