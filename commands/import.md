<command-name>panel:import</command-name>

# panel:import — Discover, Generate, and Import Papers

Four modes: discover papers from external sources (roadmap, waves, commits) or import existing review artifacts.

## Arguments

### Discovery Modes (new papers)
- `--from roadmap [--roadmap <path>]` — Discover papers from research ROADMAP.md
- `--from waves [--project <name>] [--path <waves-dir>]` — Discover papers from completed waves
- `--from commits [--repo <path>] [--since <date>] [--count <N>]` — Discover papers from git history

### Artifact Import Mode (existing papers)
- `--paper <dir>` — Import specific paper with existing review artifacts
- `--module <path>` — Import all papers in a module directory

### Common Options
- `--dry-run` — Show what would be discovered/imported without creating files

---

## Mode 1: From Roadmap

```
panel:import --from roadmap
panel:import --from roadmap --roadmap C:\src\research\ROADMAP.md
```

### Behavior

1. **Discover**: Call `discover_from_roadmap(roadmap_path)` from shared/topic-discovery.md
   - Default path: `C:\src\research\ROADMAP.md`
   - Parses Priority sections for "Not started" papers with target venues
   - Extracts titles, venues, abstract sketches, evidence (unchecked action items)
   - Cross-checks against existing papers in `research/` to skip duplicates

2. **Propose**: Display discovered papers in a table:

   ```
   Panel Import — Discovering papers from roadmap
   ═══════════════════════════════════════════════════════════════════════

   Source: C:\src\research\ROADMAP.md

   Found 3 potential papers:

    #  Title                                              Venue              Evidence    Priority
    ── ──────────────────────────────────────────────────  ──────────────── ──────────  ────────
    1  Structured Expertise Injection: A Pattern Language  CACM / IEEE SW   4 actions   P3
    2  Closing the Loop: Learning from Human Decisions     CHI / CSCW 2026  5 actions   P4
    3  Cross-Domain Replication Study                      OSDI / SOSP      3 actions   P5 (capstone)
   ```

   If `--dry-run`: stop here, show proposals only.

3. **Approve**: Use AskUserQuestion to let the user select which papers to create:
   - Present each paper as a selectable option with title and venue
   - Use `multiSelect: true` so the user can pick any combination
   - Options: each discovered paper + "None — cancel import"

4. **Generate**: For each approved paper, call `generate_paper(proposal, options)` from shared/paper-generator.md:
   - Create paper directory: `research/{slug}/`
   - Generate `main.tex` with full preamble, real title, abstract, and section includes
   - Generate 6 section files with substantive content drawing on evidence
   - Create `reviews/` directory
   - Create `Makefile` with build targets
   - Create `_panel.yaml` initialized at stage: draft

5. **Update RESEARCH.md**: For each created paper, append to the Paper Inventory table with next sequential number.

6. **Report**: Show generation summary:

   ```
   Panel Import — 2 papers created
   ═══════════════════════════════════════════════════════════════════════

   Created paper #6: panel-structured-expertise-injection
     Directory:  research/panel-structured-expertise-injection/
     Venue:      CACM / IEEE Software
     Stage:      draft
     Sections:   6 files written (introduction through conclusion)
     ✓ _panel.yaml initialized
     ✓ RESEARCH.md updated (paper #6)

   Created paper #7: panel-closing-the-loop
     Directory:  research/panel-closing-the-loop/
     Venue:      CHI / CSCW 2026
     Stage:      draft
     Sections:   6 files written
     ✓ _panel.yaml initialized
     ✓ RESEARCH.md updated (paper #7)

   Next steps:
     1. Review generated content:  Read main.tex and sections/ in each paper
     2. Start reviews:             panel:go --paper panel-structured-expertise-injection
     3. Check portfolio:           panel:status
   ```

---

## Mode 2: From Waves

```
panel:import --from waves
panel:import --from waves --project merit
panel:import --from waves --path C:\src\waves
```

### Behavior

1. **Discover**: Call `discover_from_waves(waves_dir, project)` from shared/topic-discovery.md
   - Default path: `C:\src\waves`
   - Loads wave index for completed waves
   - Clusters related waves by theme/discipline
   - Scores by novelty, evidence depth, venue fit
   - Cross-checks against existing papers

2. **Propose**: Display discovered papers (same table format as roadmap mode):

   ```
   Panel Import — Discovering papers from waves
   ═══════════════════════════════════════════════════════════════════════

   Source: C:\src\waves (project: all)
   Scanned: 31 completed waves across 3 projects

   Found 2 potential papers:

    #  Title                                              Venue              Evidence      Score
    ── ──────────────────────────────────────────────────  ──────────────── ────────────  ───────
    1  Wave-Driven Architecture Evolution Patterns         ICSE / FSE       12 pulses     0.82
    2  Discipline-Guided Code Generation at Scale          MLSys 2026       8 pulses      0.71

   ⚠ Skipped 1 topic (overlaps with existing paper panel-revision-dynamics)
   ```

   If `--dry-run`: stop here.

3. **Approve**: Same AskUserQuestion flow as roadmap mode.

4. **Generate**: Same generate_paper() pipeline, with wave pulse data as evidence.

5. **Update RESEARCH.md** and **Report**: Same as roadmap mode.

---

## Mode 3: From Commits

```
panel:import --from commits
panel:import --from commits --repo C:\src\merit --since 2025-09-01
panel:import --from commits --repo C:\src\panel --count 200
```

### Behavior

1. **Discover**: Call `discover_from_commits(repo_path, options)` from shared/topic-discovery.md
   - Default: current repository, last 6 months, max 500 commits
   - Groups commits by prefix pattern (`[panel]`, `[waves]`, etc.) and directory
   - Identifies clusters with 10+ commits
   - Cross-checks against existing papers

2. **Propose**: Display discovered papers:

   ```
   Panel Import — Discovering papers from commits
   ═══════════════════════════════════════════════════════════════════════

   Source: C:\src\panel (since 2025-09-01)
   Analyzed: 147 commits

   Found 1 potential paper:

    #  Title                                              Venue              Evidence       Span
    ── ──────────────────────────────────────────────────  ──────────────── ────────────── ─────────
    1  Plugin-Driven Review Lifecycle Automation           ICSE / FSE       47 commits     4 months
   ```

   If `--dry-run`: stop here.

3. **Approve → Generate → Update → Report**: Same pipeline as above.

---

## Mode 4: Artifact Import (Existing)

```
panel:import --paper research/panel-review-methodology
panel:import --module merit/
```

Unchanged from original behavior:

1. **Scan for review artifacts**: Find `REVIEW-*.md`, `ROUND*-REVIEW-*.md`, `SYNTHESIS.md`, `REVISION-PLAN.md` files.
2. **Detect current stage**: Based on which artifacts exist:
   - Has `main.tex` only → `draft`
   - Has `REVIEW-*.md` files → `panel`
   - Has `SYNTHESIS.md` → `synthesis`
   - Has `REVISION-PLAN.md` → `revision`
   - Has `ROUND2-REVIEW-*.md` → `recheck`
   - Has `REVIEW_PANEL.md` in parent → `ready`
3. **Extract reviewer data**: Parse reviewer names, affiliations, and scores from review files.
4. **Extract scores**: Parse score lines from review files (handles `Score: 3/4`, `Overall: Accept`, etc.).
5. **Build history**: Reconstruct stage transition timeline from file modification dates.
6. **Write `_panel.yaml`**: Create state file with all extracted data.

### Artifact Import Output

```
Panel Import — merit/merit-data-first-architecture
═══════════════════════════════════════════════════════════════════════

Detected artifacts:
  reviews/REVIEW-PERCY-LIANG.md        Score: 3/4
  reviews/REVIEW-MATEI-ZAHARIA.md      Score: 4/4
  reviews/REVIEW-HARRISON-CHASE.md     Score: 3/4
  reviews/REVIEW-SHREYA-SHANKAR.md     Score: 3/4
  reviews/REVIEW-ION-STOICA.md         Score: 3/4
  reviews/SYNTHESIS.md                 P1: 3, P2: 5, P3: 2
  reviews/ROUND2-REVIEW-*.md           5 files, avg 3.4/4
  REVISION-PLAN.md                     Exists

Inferred state:
  Stage: ready (round 2 complete, all scores ≥ 2/4, avg 3.4/4)
  Reviewers: 5
  Rounds: 2

Created: _panel.yaml
```

### Batch Import

```bash
# Import all merit papers
panel:import --module merit/

# Import all waves papers
panel:import --module waves/
```

---

## Mode Selection Logic

When the command is invoked, determine the mode from arguments:

| Arguments | Mode |
|-----------|------|
| `--from roadmap` | Mode 1: Roadmap discovery |
| `--from waves` | Mode 2: Waves discovery |
| `--from commits` | Mode 3: Commit discovery |
| `--paper <dir>` | Mode 4: Artifact import (single) |
| `--module <path>` | Mode 4: Artifact import (batch) |
| No arguments | Show help: list all modes with examples |

If no arguments are provided, display:

```
Panel Import — Choose a source
═══════════════════════════════════════════════════════════════════════

Usage:
  panel:import --from roadmap          Discover papers from ROADMAP.md
  panel:import --from waves            Discover papers from completed waves
  panel:import --from commits          Discover papers from git history
  panel:import --paper <dir>           Import paper with existing reviews
  panel:import --module <path>         Import all papers in a module

Add --dry-run to any mode to preview without creating files.

Examples:
  panel:import --from roadmap
  panel:import --from waves --project merit
  panel:import --from commits --repo C:\src\merit --since 2025-09-01
  panel:import --paper research/panel-review-methodology
  panel:import --module C:\src\research\merit
```

---

## Error Handling

- **Roadmap not found**: If the roadmap file doesn't exist at the default or specified path, show error with the path tried and suggest using `--roadmap <path>`.
- **No waves found**: If no completed waves found, show message with the path scanned and suggest checking the project name.
- **No commits found**: If the repo path doesn't exist or has no matching commits, show error.
- **No proposals found**: If discovery returns empty (all papers already exist or no qualifying topics), show message: "No new papers discovered. All topics from {source} already have corresponding papers."
- **Duplicate detected**: If a proposal matches an existing paper exactly, skip it automatically and note it in the output.
- **RESEARCH.md not found**: If `research/RESEARCH.md` doesn't exist, warn but continue — the paper is still created, just not registered in the inventory.

---

## Dependencies

- shared/topic-discovery.md — discover_from_roadmap(), discover_from_waves(), discover_from_commits()
- shared/paper-generator.md — generate_paper() for creating paper directories and content
- shared/state-loader.md — save_state() for _panel.yaml creation, discover_papers() for duplicate check
- shared/score-utils.md — Score parsing for artifact import mode
- shared/display-utils.md — header(), table() for terminal formatting
