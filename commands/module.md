---
name: panel:module
description: Module-tier operations — design tracks, run cross-portfolio review, curate toward 9.0+, track status. Runs on one or more modules.
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Bash
  - AskUserQuestion
---

# panel:module — Module Tier

All module-level operations. Each subcommand works on the current module
or a named set of modules.

## Plugin Root + Config

```javascript
// @import ../shared/project-config.md
// @import ../shared/module-utils.md
// @import ../shared/state-loader.md

const projectConfig = loadProjectConfig();
const researchDir = path.join(process.cwd(), projectConfig.researchPath);
const pluginRoot = projectConfig.pluginRoot;
const allProjects = getAllProjects();
```

---

## Usage

```
panel:module <subcommand> [targets] [options]

Subcommands:
  design   [name]           Design module architecture — tracks, contracts, arc paragraphs
  review   [modules]        Cross-portfolio panel review (was panel:convene --review)
  curate   [modules]        Curate module toward 9.0+ — diagnosis + CURATION.md
  status   [modules]        Track health, paper coverage, PP progress
  assign   <paper> <track>  Assign a paper to a track
  track    <name>           Add or inspect a track
  check    [modules]        Validate track coverage (orphans, chains, contracts)
  revisions [modules]       Show PP1/PP2/PP3 progress across papers
  apply    [modules]        Apply PP1/PP2 revision items to paper LaTeX source
  member   <name>           Regenerate one panel member's assessment

Targets:
  (none)          Current module (from .claude/panel.json default project)
  <name>          Module by project name
  alpha beta      Multiple modules by name
  --all           All configured modules
```

---

## Target Resolution

```javascript
async function resolveModuleTargets(args) {
    if (args['--all']) return allProjects;
    if (args.targets.length === 0) return [getDefaultProject(projectConfig)];
    return args.targets.map(name =>
        allProjects.find(p => p.projectName === name || p.clientSlug === name)
    ).filter(Boolean);
}
```

---

## Subcommands

### `design [name]`

Design a new module or inspect/update an existing one. Interactive flow:

1. **New module**: theme → tracks → paper-to-track assignments → quantification
   contracts → series arc paragraphs → MODULE.md → per-paper plan.md files
2. **Existing module** (`MODULE.md` found): show current design, offer to add tracks
   or update contracts

**Three Properties** (from gravity:downward-signal 9.37/10 benchmark):
- **Causal Chain**: each paper in a track is unintelligible without the prior
- **No Weak Links**: every paper designed to score ≥ 8.0
- **Actionable Numbers**: every finding has a specific quantified result

**Modes**:
```
panel:module design                 # design current module
panel:module design my-module       # design named module
panel:module design --status        # show current design
panel:module design --assign p t    # assign paper to track
panel:module design --track name    # add a track
panel:module design --check         # validate coverage
```

Full logic in the `design` handler below.

---

### `review [modules]`

Cross-portfolio panel review. Assembles 7-member panel, generates REVIEW_PANEL.md
with track scores, PP1/PP2/PP3 items tagged to tracks, cross-module track map.

**Single module**: `panel:module review`
**Multiple**: `panel:module review alpha beta`
**All**: `panel:module review --all`

**Prerequisites per module:**
- 2+ papers at `recheck` stage or beyond
- Passing scores (avg ≥ 2.5/4, min ≥ 2/4)

**Flow** (per module):

1. **Assess readiness**: check papers via shared/panel-utils.assess_paper_readiness()
2. **Load module architecture**: read `MODULE.md` via shared/module-utils.md
   - Extract track definitions, paper-to-track assignments
   - Identify orphan papers — include but flag
   - Discover cross-module tracks via `discoverCrossModuleTracks()`
3. **Select 7-member panel**: shared/panel-utils.select_cross_portfolio_panel()
   - Round 1: fresh selection
   - Round 2+: retain 5 core, rotate 2
4. **Load profiles**: `loadReviewerProfile()` + `buildReviewerContext()` for all 7
5. **Generate assessments**: each member reviews all ready papers
   - Inject OLE context string as reviewer persona
   - Assess paper quality (10-point scale)
   - Assess each track's causal chain integrity
   - Rank papers within module
6. **Synthesize** into `REVIEW_PANEL.md`:
   - Module score and tier
   - Track scores (score, chain health, weak links per track)
   - Cross-module tracks (tracks spanning this module and others)
   - Paper rankings with consensus
   - PP1/PP2/PP3 items tagged to tracks
7. **Write `PANEL-REVISION-PLAN.md`**: PP items with track tags, open checkboxes
8. **Update MODULE.md**: write track scores back via `updateTrackScore()`
9. **Archive**: snapshot to `panel-reviews/round-{N}/` (includes MODULE.md)
10. **Offer to apply**: PP1/PP2 items immediately

**Bulk** (multiple modules): runs sequentially, shared progress report at end.

```
panel:module review --all
═══════════════════════════════════════════════════════════════════════

Running module review on 3 modules...

[1/3] module-alpha   Round 1 → REVIEW_PANEL.md ✓  Score: 7.2/10 (B+)
[2/3] module-beta    Round 1 → REVIEW_PANEL.md ✓  Score: 6.8/10 (B+)
[3/3] module-gamma   Skipped — only 1 paper at recheck (needs 2+)

Done. 2/3 modules reviewed.
Cross-module tracks found: Track A spans module-alpha + module-beta (aligned ✓)
Next: panel:board review
```

---

### `curate [modules]`

Diagnose module against three properties and write CURATION.md.

**Single**: `panel:module curate`
**Level override**: `panel:module curate --level B`
**Specific track**: `panel:module curate --track methodology`

**Curation levels:**
- **A** — Series arc + PP1 fixes (+0.8 to +1.2)
- **B** — Weak link surgery (+1.5 to +2.0)
- **C** — Full curation (+2.0 to +3.0)
- **D** — Merger/restructure (+2.5 to +4.0)

Full diagnosis logic in `commands/curate.md`.

---

### `status [modules]`

Track health, paper coverage, PP item progress.

```
panel:module status
═══════════════════════════════════════════════════════════════════════

Module: reviewer-simulation | Round 1 | Score: 7.2/10 (B+)

Track Health:
  Track A (methodology)   Score: 7.8  Chain: Strong  Weak links: none    Numbers: 3/3 ✓
  Track B (empirical)     Score: 6.9  Chain: Partial  Weak link: paper-3  Numbers: 2/3 ⚠
  Track C (theory)        Score: —    Chain: Broken   (paper-5 missing)   Numbers: 1/2 ✗

Paper Coverage:
  paper-1  Tracks: A, C   Stage: recheck  Round: 1  Score: 2.8/4
  paper-2  Tracks: A, B   Stage: revision Round: 1  Score: —
  paper-3  Track:  B      Stage: draft    Round: 0  Score: — ⚠ weak link
  paper-4  Tracks: B, C   Stage: recheck  Round: 1  Score: 2.6/4
  paper-5  Track:  C      Stage: planned  (not yet created)

Orphan papers: none

PP Progress:
  PP1 items: 2 total — 1 addressed ✓, 1 open
  PP2 items: 3 total — 0 addressed
  PP3 items: 2 total

Cross-module tracks:
  Track A also in: module-beta (aligned ✓)
```

---

### `assign <paper> <track>`

Assign a paper to a track and update MODULE.md.

```
panel:module assign panel-profile-caching methodology
```

Validates chain position, warns if paper breaks causal order.

---

### `track <name>`

Add a new track or inspect an existing one.

```
panel:module track                    # list all tracks
panel:module track methodology        # inspect track details
panel:module track new-track-name    # add new track (interactive)
```

---

### `check [modules]`

Validate track coverage:
- Every paper has ≥1 track
- Every track has ≥2 papers
- Every paper has a quantification contract
- No broken chain links

```
panel:module check
══════════════════
✓ Track A: 3 papers, chain complete
⚠ Track B: paper-3 has no quantification contract
✗ Track C: chain broken (paper-5 not created yet)
✗ paper-7: orphan — not assigned to any track
```

---

### `revisions [modules]`

Show PP1/PP2/PP3 progress tagged by track.

```
PP1 Progress — Blocking Items
═══════════════════════════════════════
 #  Item                          Track  Papers       Status
 ── ───────────────────────────── ────── ──────────── ──────
 1  Missing GPT-4 baseline        A      2 papers     1/2 ✓
 2  Formal notation missing        B      paper-3      0/1
```

---

### `apply [modules]`

Apply PP1/PP2 revision items across all papers in the module(s).
Edits sections/*.tex per paper in ranking order.

See `--apply` logic from convene (now integrated here).

---

### `member <name>`

Regenerate one panel member's assessment, reload their profile,
rebuild OLE context, re-run synthesis. No new round.

```
panel:module member "Percy Liang"
```

---

## Design Handler (full)

When `panel:module design` runs on a new module:

### Step 1 — Theme
Ask: "What is the research theme? 2-3 sentences on what questions this module answers."

### Step 2 — Track count
1 track (focused chain) / 2 tracks (parallel) / 3 tracks (multi-perspective) / draft for me

### Step 3 — Track design
For each track: name, theme, planned paper chain.
Write chain sentence: "Paper A establishes X → Paper B requires X → reveals Y → Paper C operationalizes Y as Z"
If incoherent: redesign.

### Step 4 — Paper-to-track assignment
For each planned paper: which tracks? (multiSelect)
Orphan warning if none selected.

### Step 5 — Quantification contracts
Per paper: primary number, experiment design, decision it changes, null fallback.
Gate: no paper may skip its contract.

### Step 6 — Series arc paragraphs
One LaTeX paragraph per track (with actual numbers from contracts).
Module arc paragraph spanning all tracks.
Cannot be written until contracts are complete.

### Step 7 — Write MODULE.md + per-paper plan.md files

### Step 8 — Self-score against three properties
Report estimated panel score. Flag papers scoring ≤ 6 on the rubric.

---

## File Layout

```
{researchDir}/
├── MODULE.md                    ← track definitions, paper table, arcs, contracts
├── REVIEW_PANEL.md              ← latest panel review (from panel:module review)
├── PANEL-REVISION-PLAN.md       ← PP items with track tags
├── CURATION.md                  ← curation plan (from panel:module curate)
├── panel-reviews/
│   └── round-{N}/
│       ├── REVIEW_PANEL.md
│       ├── PANEL-REVISION-PLAN.md
│       └── MODULE.md            ← snapshot of module state at review time
└── panel-*/                     ← paper directories
```

---

## Auto-Commit

```javascript
await gitCommitIfEnabled(
    `[panel] ${moduleName}: module ${subcommand}`,
    [researchDir]
);
```

## Dependencies

- shared/project-config.md — researchPath, pluginRoot, getAllProjects()
- shared/module-utils.md — MODULE.md parsing, track operations, discoverCrossModuleTracks()
- shared/panel-utils.md — readiness assessment, panel selection
- shared/reviewer-profile-loader.md — loadReviewerProfile(), buildReviewerContext()
- shared/reviewer-selector.md — panel member selection
- shared/synthesis-engine.md — PP1/PP2/PP3 consolidation
- shared/score-utils.md — score aggregation, tier mapping
- shared/state-loader.md — paper state loading
- shared/git-helper.md — auto-commit
- shared/display-utils.md — terminal formatting
- shared/message-utils.md — standardized output
- config/scoring.yaml — 10-point scale, tier definitions
