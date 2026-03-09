---
name: panel:board
description: Board-tier operations — cross-module review, status, revision tracking. Operates across all configured modules in the monorepo.
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Bash
  - AskUserQuestion
---

# panel:board — Board Tier

All board-level operations. The board sees across all modules — it is the
monorepo-level tier of the three-tier review architecture.

```
panel:paper    — individual paper lifecycle
panel:module   — module-level panel review
panel:board    — cross-module board review  ← this command
```

## Plugin Root + Config

```javascript
// @import ../shared/project-config.md
// @import ../shared/module-utils.md
// @import ../shared/board-utils.md

const projectConfig = loadProjectConfig();
const pluginRoot = projectConfig.pluginRoot;
const allProjects = getAllProjects();
```

---

## Usage

```
panel:board <subcommand> [options]

Subcommands:
  review              Run cross-module board review
  status              Board status — module registry, track map, revision progress
  revisions           Show B1/B2/B3 progress across all modules
  member <name>       Regenerate one board member's assessment
  update <section>    Targeted refresh of a REVIEW_BOARD.md section
  scaffold [modules]  Discover and scaffold uninitialized modules

Options (for review):
  --repo <path>       Monorepo root (default: auto-detect)
  --dry-run           Preview without writing files
  --round <n>         Force a specific round number
```

---

## Repo Path Resolution

1. `--repo <path>` explicit flag
2. `process.cwd()` (assumes run from monorepo root)
3. Walk up looking for `.claude/panel.json` with multiple projects
4. Walk up looking for `REVIEW_BOARD.md`
5. Walk up looking for directory with 2+ configured research paths
6. Fail with guidance

---

## Subcommands

### `review`

Cross-module board review. Reads all module `REVIEW_PANEL.md` files and
`MODULE.md` files, assembles 7-member board, produces `REVIEW_BOARD.md`.

**Prerequisites:**
- 2+ modules with completed `REVIEW_PANEL.md` (from `panel:module review`)
- Panel reviews must be substantive (not placeholders)

**Flow:**

1. **Resolve repo**: find monorepo root
2. **Discover modules**: scan all configured projects for completed `REVIEW_PANEL.md`
3. **Load cross-module track map** via `discoverCrossModuleTracks()`:
   - Scan all `MODULE.md` files for track definitions
   - Identify tracks spanning multiple modules
   - Assess alignment: `aligned` | `subset` | `parallel` | `divergent` | `unique`
4. **Select 7-member board**: shared/board-utils.select_board()
   - Round 1: fresh selection
   - Round 2+: retain 5 core, rotate 2
5. **Load profiles**: `loadReviewerProfile()` + `buildReviewerContext()` for all 7
6. **Generate assessments**: each board member reviews all module panels
   - Read each module's `REVIEW_PANEL.md` and `MODULE.md`
   - Inject OLE context string as reviewer persona
   - Assess module quality (10-point scale)
   - Assess cross-module track alignment:
     - `aligned` → program strength, cite explicitly
     - `divergent` → B1 candidate: conflicting chain logic
     - `parallel` → B2 candidate: papers should cite each other
     - `subset` → depth signal (good)
   - Identify cross-module themes and synergies
   - Rank modules within the program
7. **Synthesize** into `REVIEW_BOARD.md`:
   - Program score and tier
   - Module rankings with consensus and agreement matrix
   - **Cross-module track map**: alignment status per track
   - Cross-module themes (derived from track alignment + panel findings)
   - Per-module assessments
8. **Generate per-module revision plans**: `BOARD-REVISION-PLAN-{module}.md`
   - B1/B2/B3 items **tagged to tracks** where applicable:
     - `B1 [Track methodology]` — divergent track logic across modules
     - `B2 [Track empirical, alpha + beta]` — parallel papers should cite each other
     - `B3 [module]` — module-level item
9. **Snapshot round** to `board-reviews/round-{N}/` with MANIFEST.md
10. **Report**:

```
panel:board review
═══════════════════════════════════════════════════════════════════════

Board Review — Round 1

Modules reviewed:
  module-alpha   Score: 7.2/10 (B+)   Tier: Solid
  module-beta    Score: 7.8/10 (A-)   Tier: Strong
  module-gamma   Score: 8.1/10 (A-)   Tier: Strong

Program score: 7.7/10 (A-)

Cross-module tracks:
  Track methodology   alpha + beta    aligned ✓    (program strength)
  Track empirical     beta + gamma    parallel ⚠   (B2: add cross-citations)
  Track theory        alpha only      unique        (no cross-module implication)

B1 items (blocking): 1
  B1.1 [Track empirical] beta + gamma parallel papers need cross-citation framework

B2 items (important): 3
B3 items (nice-to-have): 2

Revision plans written:
  BOARD-REVISION-PLAN-module-alpha.md
  BOARD-REVISION-PLAN-module-beta.md
  BOARD-REVISION-PLAN-module-gamma.md

Archived: board-reviews/round-1/
Next: modules address B1 items → panel:module review (round 2) → panel:board review (round 2)
```

---

### `status`

Board status: module registry, cross-module track map, revision progress.

```
panel:board status
═══════════════════════════════════════════════════════════════════════

Program: craftworks research | Board round 1 | Score: 7.7/10 (A-)

Module Registry:
  module-alpha   5 papers  Panel: ✓ (7.2)  Board: ✓  B1: 0/1 addressed
  module-beta    4 papers  Panel: ✓ (7.8)  Board: ✓  B1: 1/1 addressed ✓
  module-gamma   3 papers  Panel: ✓ (8.1)  Board: ✓  B1: 0/0
  module-delta   2 papers  Panel: ✗         Board: —  (awaiting panel:module review)

Cross-module Track Map:
  Track methodology   alpha + beta    aligned ✓
  Track empirical     beta + gamma    parallel ⚠  B2.1 open
  Track theory        alpha only      unique

Board composition (7 members): [names if board has run]

Ready for round 2: module-beta ✓ (all B1 addressed)
Waiting: module-alpha (1 B1 open)
```

---

### `revisions`

Show B1/B2/B3 progress across all modules, tagged by track.

```
B1 Progress — Blocking Items
═══════════════════════════════════════
 #  Item                          Track       Modules           Status
 ── ───────────────────────────── ─────────── ─────────────     ──────
 1  Divergent chain logic         methodology alpha + beta       0/1 ✗
 2  Missing baseline comparison   empirical   beta               1/1 ✓
```

---

### `member <name>`

Regenerate one board member's assessment. Loads their profile,
builds OLE context, regenerates assessment, re-runs synthesis.
No new round.

```
panel:board member "Percy Liang"
```

---

### `update <section>`

Targeted refresh of a specific REVIEW_BOARD.md section without full re-review.

| Section | What it updates |
|---------|----------------|
| `registry` | Re-scan modules, update panel status |
| `board` | Re-select board members |
| `tracks` | Re-run cross-module track alignment |
| `synthesis` | Re-run synthesis from existing assessments |
| `rankings` | Recalculate module rankings |
| `themes` | Re-extract cross-module themes |
| `revisions` | Regenerate per-module revision plans |
| `all` | Full refresh (equivalent to `review`) |

---

### `scaffold [modules]`

Discover and scaffold modules that exist on disk but lack panel infrastructure.
The board is the right place for this — it has the monorepo view and can see
all research paths at once.

**Discovery**: finds three types of unscaffolded modules:

| Type | Signal | Action |
|------|--------|--------|
| **Configured, empty** | In `panel.json` but no `papers/` or `publications/` | Create directories + Makefiles + MODULE.md stub |
| **Configured, unarchitected** | Has publications but no `MODULE.md` | Scaffold MODULE.md from existing `_panel.yaml` inventory |
| **Unconfigured, exists** | Research path exists on disk but not in `panel.json` | Offer to register in `panel.json` + scaffold |

```
panel:board scaffold               # discover and scaffold all
panel:board scaffold module-alpha  # scaffold one module by name
panel:board scaffold --check       # show what needs scaffolding, no changes
```

#### Flow

**Step 1 — Discovery**

```javascript
const allProjects = getAllProjects();
const gaps = [];

for (const project of allProjects) {
    const researchDir = path.join(cwd, project.researchPath);
    const moduleFile = resolveModuleFile(researchDir);
    const hasPublications = exists(path.join(researchDir, 'publications'));
    const hasPapers = exists(path.join(researchDir, 'papers'));

    if (!exists(researchDir)) {
        gaps.push({ project, type: 'empty', action: 'create-structure' });
    } else if (!moduleFile) {
        gaps.push({ project, type: 'unarchitected', action: 'scaffold-module-md' });
    } else if (!hasPublications && !hasPapers) {
        gaps.push({ project, type: 'no-content-dirs', action: 'create-dirs' });
    }
}

// Also scan for unconfigured research directories
const discoveredPaths = await discoverResearchPaths(cwd);
for (const path of discoveredPaths) {
    if (!allProjects.find(p => p.researchPath === path)) {
        gaps.push({ path, type: 'unconfigured', action: 'register-and-scaffold' });
    }
}
```

**Step 2 — Show discovery report**

```
panel:board scaffold --check
═══════════════════════════════════════════════════════════════════════

Board sees 4 modules. Scaffold status:

  module-alpha   ✓ Fully scaffolded (MODULE.md, publications/, papers/)
  module-beta    ⚠ No MODULE.md — has 3 publications, needs architecture
  module-gamma   ✗ Empty — research path exists but no content directories
  module-delta   ✗ Not configured — research/delta/ exists but not in panel.json

Actions needed:
  module-beta    scaffold MODULE.md from 3 existing _panel.yaml files
  module-gamma   create publications/, papers/, docs/, Makefiles
  module-delta   register in panel.json + full scaffold
```

**Step 3 — Scaffold per module**

For `type: empty` — create full structure:
```bash
mkdir -p ${researchDir}/publications
mkdir -p ${researchDir}/papers
mkdir -p ${researchDir}/docs
cp ${pluginRoot}/templates/makefile-module.mk ${researchDir}/Makefile
cp ${pluginRoot}/templates/makefile-publications.mk ${researchDir}/publications/Makefile
```
Then scaffold MODULE.md stub and run `panel:module design` interactively
(or generate a full stub with `--auto`).

For `type: unarchitected` — MODULE.md only:
```javascript
const publications = glob(`${researchDir}/publications/*/_panel.yaml`)
    .map(p => parseYAML(Read(p)));
const papers = glob(`${researchDir}/papers/*.md`);
const moduleContent = scaffoldModuleMd(project.projectName, publications, papers);
Write(`${researchDir}/MODULE.md`, moduleContent);
```

For `type: unconfigured` — register + full scaffold:
```javascript
// 1. Add to panel.json
const config = JSON.parse(Read('.claude/panel.json'));
config.projects[inferModuleName(discoveredPath)] = {
    projectName: inferModuleName(discoveredPath),
    researchPath: discoveredPath,
    papersPath: `${discoveredPath}/papers`,
    publicationsPath: `${discoveredPath}/publications`,
    panelPath: `context/panel/${inferModuleName(discoveredPath)}`,
    clientSlug: inferModuleName(discoveredPath)
};
Write('.claude/panel.json', JSON.stringify(config, null, 2));
// 2. Then scaffold as 'empty' above
```

**Step 4 — Offer to design MODULE.md**

After scaffolding, for each module with a stub MODULE.md:
```javascript
AskUserQuestion({
    question: `${module.name} scaffolded. Define module architecture now?`,
    options: [
        { label: 'Yes — run panel:module design', description: 'Interactive track design' },
        { label: 'Later', description: 'MODULE.md has a stub — fill in tracks manually' }
    ]
});
```
If yes: relay to `panel:module design <module-name>`.

**Step 5 — Report + commit**

```
panel:board scaffold — Complete
═══════════════════════════════════════════════════════════════════════

✓ module-beta    MODULE.md scaffolded (3 publications, tracks TBD)
✓ module-gamma   Full structure created (publications/, papers/, docs/, Makefiles)
✓ module-delta   Registered in panel.json + full structure created

All 3 modules ready for panel:module design.

Next: panel:module design <module-name> to define tracks and causal chains.
```

---

## Round Cycle

```
panel:board review (round 1)
  → REVIEW_BOARD.md (canonical)
  → BOARD-REVISION-PLAN-{module}.md per module
  → board-reviews/round-1/ snapshot

Modules revise via panel:module → panel:paper → addresses B1 items

panel:board review (round 2)
  → Checks B1 items addressed
  → Updated REVIEW_BOARD.md
  → board-reviews/round-2/ snapshot
  → All B1 addressed + program ≥ 7.0/10 → board signs off
```

## Completion Criteria

1. All B1 items addressed across all modules
2. Program score ≥ 7.0/10 (Tier A- or above)
3. No module below 6.0/10
4. Board consensus: avg Spearman's ρ > 0.6

## File Layout

```
{repo}/
├── REVIEW_BOARD.md                      ← canonical board review
├── BOARD-REVISION-PLAN-{module}.md      ← per-module revision plans
├── board-reviews/
│   └── round-{N}/
│       ├── MANIFEST.md
│       ├── REVIEW_BOARD.md
│       ├── BOARD-REVISION-PLAN-*.md
│       └── {module}/
│           ├── REVIEW_PANEL.md
│           ├── MODULE.md
│           └── RESEARCH.md
```

## Auto-Commit

```javascript
await gitCommitIfEnabled(
    `[panel] Board ${subcommand} round ${round}`,
    [repoRoot]
);
```

## Dependencies

- shared/project-config.md — getAllProjects(), pluginRoot
- shared/module-utils.md — MODULE.md parsing, discoverCrossModuleTracks(), alignment
- shared/board-utils.md — module discovery, board selection, snapshot
- shared/reviewer-profile-loader.md — loadReviewerProfile(), buildReviewerContext()
- shared/reviewer-selector.md — board member selection
- shared/score-utils.md — score aggregation, tier mapping, agreement
- shared/panel-utils.md — panel data parsing
- shared/display-utils.md — terminal formatting
- shared/message-utils.md — standardized output
- shared/git-helper.md — auto-commit
- config/scoring.yaml — 10-point scale, tier definitions
