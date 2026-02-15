# File Schema Review — Three-Tier Architecture

**Date**: 2026-02-15
**Wave**: 260215+galileo-observer+reviewer-profiles
**Status**: Architectural analysis before E3 integration

## Problem Statement

The current three-tier review architecture has **inconsistent file naming, location patterns, and round tracking** across the paper/panel/board levels. This creates confusion, makes the codebase harder to maintain, and complicates integration work like the reviewer profile system.

## Current Schema Analysis

### Tier 1: Paper Level (panel:review)

**Location**: `{paper}/reviews/`

**Files**:
```
reviews/
├── REVIEW-{NAME}.md                  # Round 1 individual reviews
├── SYNTHESIS.md                      # Round 1 synthesis
├── REVISION-PLAN.md                  # Latest revision plan (in paper root, not reviews/)
├── ROUND2-REVIEW-{NAME}.md           # Round 2+ reviews (flat, prefixed)
└── ROUND2-SYNTHESIS.md               # Round 2+ synthesis (flat, prefixed)
```

**State tracking**: `_panel.yaml` in paper root

**Issues**:
- ✗ REVISION-PLAN.md is in paper root, not reviews/
- ✗ Round 2+ uses flat file naming (ROUND2-*) instead of directories
- ✗ Inconsistent with panel/board tiers which use round directories
- ✗ No archive/snapshot pattern for rounds
- ✗ Mixed ALL-CAPS and kebab-case naming

### Tier 2: Module Level (panel:convene)

**Location**: `{module}/` (research directory root)

**Files**:
```
{module}/
├── REVIEW_PANEL.md                   # Latest/canonical panel review
├── PANEL-REVISION-PLAN.md            # Latest revision plan
└── panel-reviews/
    ├── round-1/
    │   ├── REVIEW_PANEL.md           # Round 1 snapshot
    │   └── PANEL-REVISION-PLAN.md    # Round 1 snapshot
    └── round-2/
        ├── REVIEW_PANEL.md           # Round 2 snapshot
        └── PANEL-REVISION-PLAN.md    # Round 2 snapshot
```

**State tracking**: No `_panel.yaml` equivalent — state is implicit in REVIEW_PANEL.md

**Issues**:
- ✓ Round directories (clean)
- ✓ Canonical files at top level
- ✗ No state file tracking round number, completion date, PP item progress
- ✗ `panel-reviews/` directory name is kebab-case but files are ALL-CAPS
- ✗ Inconsistent with paper tier (which doesn't use directories)

### Tier 3: Board Level (panel:board)

**Location**: `{repo}/` (monorepo root)

**Files**:
```
{repo}/
├── REVIEW_BOARD.md                   # Latest/canonical board review
├── BOARD-REVISION-PLAN-{module}.md   # Per-module revision plans (latest)
└── board-reviews/
    ├── round-1/
    │   ├── MANIFEST.md               # Round index
    │   ├── REVIEW_BOARD.md           # Board snapshot
    │   ├── BOARD-REVISION-PLAN-*.md  # Revision plans snapshot
    │   ├── merit/
    │   │   ├── REVIEW_PANEL.md       # Module state snapshot
    │   │   └── RESEARCH.md
    │   └── waves/
    │       ├── REVIEW_PANEL.md
    │       └── RESEARCH.md
    └── round-2/
        └── ... (same structure)
```

**State tracking**: No `_board.yaml` — state is implicit in REVIEW_BOARD.md

**Issues**:
- ✓ Round directories with module snapshots (very clean)
- ✓ MANIFEST.md provides round index
- ✗ No state file tracking round number, completion date, B item progress
- ✗ `board-reviews/` is kebab-case, files are ALL-CAPS
- ✗ Inconsistent revision plan naming: BOARD-REVISION-PLAN-{module}.md vs PANEL-REVISION-PLAN.md vs REVISION-PLAN.md

## Identified Inconsistencies

### 1. Round Tracking Pattern

| Tier | Round 1 | Round 2+ | Pattern |
|------|---------|----------|---------|
| Paper | `reviews/REVIEW-*.md` | `reviews/ROUND2-REVIEW-*.md` | Flat files with prefix |
| Panel | `REVIEW_PANEL.md` | `panel-reviews/round-2/REVIEW_PANEL.md` | Canonical + round dirs |
| Board | `REVIEW_BOARD.md` | `board-reviews/round-2/REVIEW_BOARD.md` | Canonical + round dirs |

**Problem**: Paper tier is the outlier. Should use round directories like panel/board.

### 2. Revision Plan Location

| Tier | Location | Filename |
|------|----------|----------|
| Paper | Paper root | `REVISION-PLAN.md` |
| Panel | Module root | `PANEL-REVISION-PLAN.md` |
| Board | Repo root | `BOARD-REVISION-PLAN-{module}.md` |

**Problem**:
- Inconsistent prefix pattern (none → PANEL- → BOARD-)
- Paper tier has file outside reviews/ directory
- Board tier multiplexes modules in filename rather than directory structure

### 3. State Tracking

| Tier | State File | Location | What It Tracks |
|------|-----------|----------|---------------|
| Paper | `_panel.yaml` | Paper root | Stage, round, reviewers, scores, P1 items |
| Panel | (none) | — | Round implicit in REVIEW_PANEL.md |
| Board | (none) | — | Round implicit in REVIEW_BOARD.md |

**Problem**: Only paper tier has explicit state tracking. Panel/board rely on markdown content parsing.

### 4. Directory Naming

| Tier | Review Archive Dir | Review Files |
|------|-------------------|--------------|
| Paper | `reviews/` | ALL-CAPS |
| Panel | `panel-reviews/` | ALL-CAPS |
| Board | `board-reviews/` | ALL-CAPS |

**Problem**: Mixed kebab-case directories with ALL-CAPS file names creates visual inconsistency.

### 5. Canonical Files vs Snapshots

| Tier | Canonical Location | Snapshot Location | Clear? |
|------|-------------------|-------------------|--------|
| Paper | `reviews/` (round 1) | `reviews/ROUND2-*` (flat) | ✗ No |
| Panel | Module root | `panel-reviews/round-N/` | ✓ Yes |
| Board | Repo root | `board-reviews/round-N/` | ✓ Yes |

**Problem**: Paper tier doesn't distinguish canonical from historical clearly.

## Proposed Unified Schema

### Design Principles

1. **Consistency across tiers**: Same patterns at paper/panel/board
2. **Canonical + archive split**: Latest always at predictable location
3. **Round directories everywhere**: No flat ROUND2- prefixes
4. **Explicit state files**: `_state.yaml` at each tier for round tracking
5. **Uniform naming**: Either all kebab-case or all ALL-CAPS (not mixed)

### Option A: Explicit State + Round Directories (Recommended)

#### Paper Tier
```
{paper}/
├── _panel.yaml                       # State: stage, round, reviewers, P1 items
├── REVISION-PLAN.md                  # Latest revision plan (canonical)
└── reviews/
    ├── REVIEW-{NAME}.md              # Latest reviews (canonical, always Round N)
    ├── SYNTHESIS.md                  # Latest synthesis (canonical)
    ├── round-1/
    │   ├── REVIEW-{NAME}.md          # Round 1 snapshot
    │   ├── SYNTHESIS.md
    │   └── REVISION-PLAN.md
    └── round-2/
        ├── REVIEW-{NAME}.md          # Round 2 snapshot
        ├── SYNTHESIS.md
        └── REVISION-PLAN.md
```

**Changes**:
- ✅ Round directories instead of ROUND2- prefix
- ✅ REVISION-PLAN.md moves into reviews/ (or stays in paper root — see variant below)
- ✅ Canonical files always at top level of reviews/
- ✅ Snapshots in round-N/ subdirectories

#### Panel Tier
```
{module}/
├── _panel-state.yaml                 # State: round, PP item progress, completion date
├── REVIEW_PANEL.md                   # Latest panel review (canonical)
├── PANEL-REVISION-PLAN.md            # Latest revision plan (canonical)
└── panel-reviews/
    ├── round-1/
    │   ├── REVIEW_PANEL.md           # Round 1 snapshot
    │   └── PANEL-REVISION-PLAN.md
    └── round-2/
        ├── REVIEW_PANEL.md
        └── PANEL-REVISION-PLAN.md
```

**Changes**:
- ✅ Add `_panel-state.yaml` for explicit tracking
- ✅ Keep existing round directory pattern (works well)

#### Board Tier
```
{repo}/
├── _board-state.yaml                 # State: round, B item progress, completion date
├── REVIEW_BOARD.md                   # Latest board review (canonical)
├── board-revision-plans/
│   ├── merit.md                      # Per-module plans (latest, canonical)
│   ├── waves.md
│   └── panel.md
└── board-reviews/
    ├── round-1/
    │   ├── MANIFEST.md               # Round index
    │   ├── REVIEW_BOARD.md           # Board snapshot
    │   ├── revision-plans/
    │   │   ├── merit.md              # Snapshot of per-module plans
    │   │   ├── waves.md
    │   │   └── panel.md
    │   ├── merit/                    # Module state snapshot
    │   │   ├── REVIEW_PANEL.md
    │   │   └── RESEARCH.md
    │   └── waves/
    │       └── ...
    └── round-2/
        └── ... (same structure)
```

**Changes**:
- ✅ Add `_board-state.yaml` for explicit tracking
- ✅ Group per-module revision plans in `board-revision-plans/` directory
- ✅ Shorter filenames (merit.md vs BOARD-REVISION-PLAN-merit.md)
- ✅ Mirror the directory structure in snapshots

### Option B: Keep Current Panel/Board, Fix Paper Only (Minimal)

**Scope**: Only change paper tier to match panel/board pattern

#### Paper Tier (Fixed)
```
{paper}/
├── _panel.yaml
├── REVISION-PLAN.md                  # Keep in paper root (not reviews/)
└── reviews/
    ├── REVIEW-{NAME}.md              # Latest (canonical)
    ├── SYNTHESIS.md                  # Latest (canonical)
    ├── round-1/
    │   ├── REVIEW-{NAME}.md
    │   └── SYNTHESIS.md
    └── round-2/
        ├── REVIEW-{NAME}.md
        └── SYNTHESIS.md
```

**Changes**:
- ✅ Round directories (no more ROUND2- prefix)
- ✅ Canonical files at top level of reviews/
- ✅ REVISION-PLAN.md stays in paper root (consistent with current location)
- ✅ Minimal disruption to existing code

**Leave unchanged**:
- Panel tier (already clean with round directories)
- Board tier (already clean with round directories)
- State tracking (only paper has `_panel.yaml`, panel/board don't need it)

## Recommendation

**Option B: Minimal Fix** is recommended because:

1. **Paper tier is the only real mess** — panel/board are already clean
2. **Minimal code changes** — only affects paper-level round tracking
3. **State files not needed at panel/board** — those tiers don't have complex stage machines
4. **Backward compatible** — existing panel/board code doesn't need refactoring

### Migration Plan (Option B)

1. **Update commands/review.md**:
   - Stage handler for "recheck" writes to `reviews/round-{N}/` instead of `reviews/ROUND{N}-*`
   - Keep canonical files at `reviews/` top level (always latest)

2. **Update shared/stage-machine.md**:
   - Round snapshot function creates `reviews/round-{round}/` directory
   - Copies REVIEW-*.md and SYNTHESIS.md into snapshot

3. **No changes needed**:
   - Panel tier (already correct)
   - Board tier (already correct)
   - State tracking (paper `_panel.yaml` is sufficient)

4. **Backward compatibility**:
   - Loader checks both `reviews/ROUND2-*` (old) and `reviews/round-2/` (new)
   - Graceful fallback for existing papers

### Option A Benefits (If We Want to Go Further)

- **More consistent** across all three tiers
- **Explicit state tracking** at panel/board helps with debugging
- **Cleaner directory structure** at board level (revision-plans/ grouping)
- **Future-proof** for additional features (e.g., panel round diff, board member rotation tracking)

But Option A requires:
- More extensive refactoring (~3-4 files at each tier)
- Migration script for existing papers/modules
- Higher testing burden

## Next Steps

1. **User decision**: Choose Option A (comprehensive) or Option B (minimal)?
2. **Update stage-plan.md**: Add task for schema migration (after E3 integration?)
3. **Document decision**: Update ARCHITECTURE.md with chosen schema
4. **Implementation**: Create migration task (E7 or separate wave?)

## References

- commands/review.md (Paper tier)
- commands/convene.md (Panel tier)
- commands/board.md (Board tier)
- shared/stage-machine.md (Stage progression logic)
- shared/panel-utils.md (Panel-specific utilities)
- shared/board-utils.md (Board-specific utilities)
