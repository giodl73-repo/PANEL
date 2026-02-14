---
name: panel:convene
description: Module-level cross-portfolio panel review with rounds
user-invocable: true
---

# panel:convene — Module-Level Cross-Portfolio Panel Review

Assembles a 7-member cross-portfolio panel to review all papers within a module, producing `REVIEW_PANEL.md` with consolidated findings, rankings, and per-paper revision items (PP1/PP2/PP3).

## Module Resolution

```javascript
// @import ../shared/project-config.md

const projectConfig = loadProjectConfig();
const researchDir = path.join(process.cwd(), projectConfig.researchPath);
const moduleName = projectConfig.projectName;
```

The "module" is the current project's research directory. All papers within `researchDir` are part of this module's cross-portfolio panel.

## Three-Tier Context

```
panel:board   — monorepo level (cross-module)
panel:convene   — module level (cross-portfolio) ← this command
panel:review   — paper level (individual reviews)
```

Panel reviews consume paper-level reviews (bubble up) and produce revision items that flow back down to individual papers. Panel findings also bubble up to `panel:board`.

## Arguments

- `--status` — Show panel status for current module: paper readiness, panel composition, round info
- `--review` — Run or re-run the cross-portfolio panel review
- `--member <name>` — Regenerate one panel member's assessment (preserves others)
- `--revisions` — Show PP1/PP2/PP3 progress across all papers in the module
- `--apply` — Apply PP1/PP2/PP3 revision items across all papers (edits LaTeX source)
- `--dry-run` — Preview what would happen without writing files

## Prerequisites

Before `panel:convene --review` can run:
1. The module must contain 2+ papers (single-paper modules skip panel tier)
2. At least 2 papers must have reached `recheck` stage or beyond
3. Those papers must have passing scores (avg >= 2.5/4, min >= 2/4)

Use `panel:convene --status` to check readiness.

## Behavior

**Execution flow**:

1. **Parse arguments**: Determine which flag was provided
2. **Dispatch to handler**: Execute the appropriate behavior based on the flag
3. **Default**: If no flag provided, run `--status`

**Available handlers**:

### --status

1. Discover all papers in `researchDir` via shared/state-loader.md
2. Assess readiness of each paper via shared/panel-utils.md
3. Display:
   - Module name (`moduleName`) and research path
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
8. **Offer to apply revisions**: After generating the revision plan, offer to apply PP1/PP2 items immediately (runs the `--apply` behavior inline). Use AskUserQuestion:

   ```
   question: "Panel review complete. Apply {N} PP1 and {M} PP2 revision items now?"
   header: "Apply revisions"
   options:
     - label: "Yes, apply all revisions (Recommended)"
       description: "Edits paper LaTeX source across all papers to address panel findings"
     - label: "Apply PP1 only (blocking items)"
       description: "Only addresses items blocking submission"
     - label: "No, I'll apply later"
       description: "Run panel:convene --apply when ready"
   ```

   If user selects apply: execute the `--apply` behavior (see below) inline.

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

### --apply

Drives the PANEL-REVISION-PLAN.md items across all papers in the module, editing LaTeX source to address PP1 and PP2 items.

1. **Load revision plan**: Read `PANEL-REVISION-PLAN.md` from the module root
2. **Assess scope**: Count unaddressed PP1 and PP2 items, group by paper
3. **Prompt**: Use AskUserQuestion:

   ```
   question: "Panel revision plan has {N} PP1 items and {M} PP2 items across {K} papers. Apply revisions?"
   header: "Panel revisions"
   options:
     - label: "Apply PP1 + PP2 across all papers (Recommended)"
       description: "Edits sections/*.tex in each paper to address panel-level findings"
     - label: "Apply PP1 only (blocking items)"
       description: "Only addresses the items blocking submission"
     - label: "Apply to specific paper"
       description: "Choose which paper(s) to revise"
     - label: "No, I'll revise manually"
       description: "Shows the revision plan and stops"
   ```

4. **If "specific paper"**: Follow up with AskUserQuestion listing papers with unaddressed items, `multiSelect: true`

5. **Apply revisions per paper**: For each paper in scope, in ranking order (highest-ranked first):

   a. Read the paper's `sections/*.tex` files and `_panel.yaml`
   b. Read the relevant PP items from PANEL-REVISION-PLAN.md
   c. For **module-level items** (e.g., "cross-paper references across all 5 papers"):
      - Apply the same type of revision to each affected paper
      - Ensure consistency (e.g., same framing of the research program across papers)
   d. For **paper-specific items** (e.g., "stratify reliability metric in P5"):
      - Read the paper's SYNTHESIS.md for additional context
      - Edit the target section(s) to address the item
   e. Mark items as addressed: check off `- [ ]` boxes in PANEL-REVISION-PLAN.md
   f. Update the paper's `_panel.yaml` to note panel revision applied

6. **Report**: Show summary after all revisions:

   ```
   Panel Revisions Applied — craft
   ═══════════════════════════════════════════════════════════════════════

   PP1 items (blocking):
     ✓ PP1.1  Cross-paper references          5 papers updated
     ✓ PP1.2  Stratify reliability metric      panel-shared-generator-framework

   PP2 items (important):
     ✓ PP2.1  Differentiate evaluation         3 papers updated
     ✓ PP2.2  Calibrate generalizability       4 papers updated
     ✓ PP2.3  Single-ecosystem derivation      5 papers updated
     ✓ PP2.4  Methodology uniformity           2 papers updated
     ✓ PP2.5  Model sensitivity for P5         panel-shared-generator-framework

   All PP1 items addressed — ready for panel:convene --review (round 2)
   or panel:board if other modules are also ready.
   ```

7. **Auto-commit**: Commit all changes across all affected papers

**Revision principles** (same as panel:review):
- Address the specific concern raised — don't rewrite sections unnecessarily
- Add content rather than remove
- When a PP item applies to multiple papers, maintain consistent framing across all
- For cross-paper items (like "add research program context"), use a shared paragraph adapted to each paper's introduction
- Preserve existing `\label{}` and `\ref{}` references

## Round Cycle

```
panel:convene --review (round 1)
  → Writes REVIEW_PANEL.md (canonical, module root)
  → Writes PANEL-REVISION-PLAN.md (module root)
  → Archives to panel-reviews/round-1/
  → PP1/PP2/PP3 items created per paper
  → Offers to apply revisions immediately (--apply behavior)

panel:convene --apply (if not applied during --review)
  → Reads PANEL-REVISION-PLAN.md
  → Edits sections/*.tex across all affected papers
  → Marks PP1/PP2 items as addressed

panel:convene --review (round 2)
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

When complete, individual papers can advance past `ready` stage in `panel:review`.

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
