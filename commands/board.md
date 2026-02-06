---
name: panel:board
description: Monorepo-level cross-module board review with rounds
user-invocable: true
---

# panel:board — Monorepo-Level Board Review

Assembles a 7-member board to review all modules across the monorepo, producing `REVIEW_BOARD.md` with cross-module synthesis, rankings, and per-module revision plans (B1/B2/B3).

## Three-Tier Context

```
panel:board   — monorepo level (cross-module) ← this command
panel:panel   — module level (cross-portfolio)
panel:paper   — paper level (individual reviews)
```

Board reviews consume module-level panel reviews (bubble up) and produce per-module revision plans that flow back down through `panel:panel` to individual papers.

## Arguments

- `--status` — Show board status: module registry, board composition, revision progress
- `--review` — Run or re-run the board review
- `--update <section>` — Targeted refresh of a specific section (see Update Sections below)
- `--member <name>` — Regenerate one board member's assessment (preserves others)
- `--revisions` — Show B1/B2/B3 progress across all modules
- `--repo <path>` — Monorepo root path (default: auto-detect via shared/board-utils.resolve_repo)
- `--dry-run` — Preview what would happen without writing files

## Repo Path Resolution

The board operates at the monorepo level. Path resolution (via shared/board-utils.resolve_repo):

1. `--repo <path>` explicit flag (highest priority)
2. Walk up from cwd looking for `REVIEW_BOARD.md`
3. Walk up from cwd looking for directory with 2+ `RESEARCH.md` subdirectories
4. Check sibling directories of current plugin
5. Fail with guidance message

## Prerequisites

Before `panel:board --review` can run:
1. At least 2 modules must have completed `REVIEW_PANEL.md` (via `panel:panel`)
2. Panel reviews must be substantive (not placeholders)

Use `panel:board --status` to check readiness.

## Behavior

### --status

1. Resolve repo path
2. Discover modules via shared/board-utils.discover_modules()
3. Display:
   - Module registry table (name, papers, panel status, score, tier)
   - Board composition (if board exists)
   - Current round and date
   - B item progress summary
   - Modules ready vs not ready for board review

### --review

1. **Resolve repo**: Find monorepo root
2. **Discover modules**: Scan for modules with completed panels
3. **Select board**: Choose 7 members via shared/board-utils.select_board()
   - On round 1: fresh selection
   - On round 2+: retain 5 core members, rotate 2
4. **Generate assessments**: Each board member reviews all module panels:
   - Read each module's `REVIEW_PANEL.md`
   - Assess module quality on 10-point scale
   - Identify cross-module themes and synergies
   - Rank modules within the program
5. **Synthesize**: Consolidate 7 assessments into `REVIEW_BOARD.md`:
   - Program score and tier
   - Module rankings with consensus and agreement matrix
   - Cross-module themes
   - Per-module assessments
6. **Generate revision plans**: Create per-module `BOARD-REVISION-PLAN-{module}.md`:
   - B1/B2/B3 items specific to each module
   - Derived from cross-module themes and board findings
7. **Snapshot round**: Archive to `board-reviews/round-{N}/`

### --update <section>

Targeted refresh without full re-review. Sections:

| Section | What it updates |
|---------|----------------|
| `registry` | Re-scan modules, update panel status |
| `board` | Re-select board members |
| `synthesis` | Re-run cross-module synthesis from existing assessments |
| `rankings` | Re-calculate module rankings and tiers |
| `themes` | Re-extract cross-module themes |
| `strategy` | Re-generate strategic recommendations |
| `revisions` | Re-generate per-module revision plans |
| `all` | Full refresh (equivalent to --review) |

### --member <name>

1. Load existing `REVIEW_BOARD.md`
2. Regenerate only the named member's assessment
3. Re-run synthesis with updated assessment
4. Overwrite `REVIEW_BOARD.md` (no new round — same round, updated)

### --revisions

1. Scan for `BOARD-REVISION-PLAN-*.md` files
2. Parse checkbox status for B1/B2/B3 items per module
3. Display progress:
   ```
   B1 Progress — Blocking Items
   ═══════════════════════════════════════
    #  Item                    Modules    Status
    ── ─────────────────────── ────────── ──────
    1  No competitive baselines merit,waves 0/2
    2  Inconsistent methodology panel      1/1 ✓
   ```

## Round Cycle

```
panel:board --review (round 1)
  → Writes REVIEW_BOARD.md (canonical, repo root)
  → Writes BOARD-REVISION-PLAN-{module}.md per module (repo root)
  → Archives to board-reviews/round-1/
  → B1/B2/B3 items created per module

Modules revise via panel:panel → panel:paper (addresses B1 items)

panel:board --review (round 2)
  → Checks B1 items addressed
  → Re-evaluates modules with updated panels
  → Updates REVIEW_BOARD.md
  → Archives to board-reviews/round-2/
  → If all B1 addressed + program score >= target → board signs off
```

## Bubble-Up: Module → Program

Module panel findings aggregate to program-level themes:

| Module-Level Pattern | Program-Level Result |
|----------------------|----------------------|
| PP1 theme in 2+ modules | B1 program theme |
| PP1 theme in 1 module | B2 program theme |
| PP2 theme in 3+ modules | B2 program theme |
| Common strength across modules | Program strength |
| Score pattern across modules | Program theme |

Cross-module synergies are also identified:
- "Panel module's methodology paper validates the process used across all modules"
- "Merit and waves share evaluation framework components"

## File Layout

```
{repo}/
├── REVIEW_BOARD.md                      ← always the latest/canonical
├── BOARD-REVISION-PLAN-merit.md         ← per-module revision plan
├── BOARD-REVISION-PLAN-waves.md
├── BOARD-REVISION-PLAN-panel.md
├── board-reviews/
│   ├── round-1/
│   │   ├── REVIEW_BOARD.md              ← snapshot
│   │   ├── BOARD-REVISION-PLAN-merit.md
│   │   └── BOARD-REVISION-PLAN-waves.md
│   └── round-2/
│       ├── REVIEW_BOARD.md
│       ├── BOARD-REVISION-PLAN-merit.md
│       ├── BOARD-REVISION-PLAN-waves.md
│       └── BOARD-REVISION-PLAN-panel.md
├── merit/
│   ├── REVIEW_PANEL.md
│   └── research/
├── waves/
│   └── ...
└── panel/
    └── ...
```

## Completion Criteria

The board review is complete when:
1. All B1 items are addressed across all modules
2. Program score >= 7.0/10 (Tier A- or above)
3. No individual module scores below 6.0/10
4. Board consensus is at least Moderate (avg Spearman's rho > 0.6)

## Dependencies

- shared/board-utils.md — Board-specific utilities
- shared/panel-utils.md — Panel data parsing
- shared/reviewer-selector.md — Board member selection
- shared/score-utils.md — Score aggregation, tier mapping, agreement
- shared/display-utils.md — Terminal formatting
- config/scoring.yaml — 10-point scale, tier definitions
