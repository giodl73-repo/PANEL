---
name: panel:publication
description: Formal LaTeX publication lifecycle — setup, author, review, status, show, venue. Full academic paper pipeline with sections, PDF, and venue submission in publications/ directory.
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Bash
  - AskUserQuestion
---

# panel:publication — Formal LaTeX Publications

Formal academic papers in `publicationsPath` (`research/publications/` by default).
Full lifecycle: LaTeX sections, PDF compilation, full review rounds, venue submission.

**For quick markdown research notes** — use `panel:paper` instead.
**To graduate a paper to a publication** — use `panel:paper promote`.

## Plugin Root + Config

```javascript
// @import ../shared/project-config.md
// @import ../shared/state-loader.md
// @import ../shared/module-utils.md

const projectConfig = loadProjectConfig();
const publicationsDir = path.join(process.cwd(), projectConfig.publicationsPath);
const pluginRoot = projectConfig.pluginRoot;
```

---

## Usage

```
panel:publication <subcommand> [targets] [options]

Subcommands:
  setup    <name> [venue]   Initialize LaTeX publication directory
  author   [targets]        Write LaTeX sections from plan.md
  review   [targets]        Full review lifecycle (draft → panel → ... → ready)
  status   [targets]        Show stage, round, score
  show     <name>           Detailed view of one publication
  venue    [targets]        Venue recommendation and submission strategy
  build    [targets]        Compile PDF (make pdf)
  submit   <name>           Mark as submitted to venue

Targets:
  (none)          All eligible publications
  <name>          One publication by slug or partial match
  1 3 5           By index (from panel:publication status)
  --track <t>     All publications in a track
  --stage <s>     All publications at a stage
  --venue <v>     All targeting a specific venue
```

---

## Directory Structure

Each publication lives in `publicationsDir/<slug>/`:

```
publications/
└── panel-token-efficiency/
    ├── _panel.yaml           ← state (stage, round, reviewers, scores)
    ├── plan.md               ← research plan (seeded from paper if promoted)
    ├── main.tex              ← root LaTeX file
    ├── sections/
    │   ├── 01-introduction.tex
    │   ├── 02-related-work.tex
    │   ├── 03-methodology.tex
    │   ├── 04-evaluation.tex
    │   ├── 05-discussion.tex
    │   └── 06-conclusion.tex
    ├── figures/              ← diagrams, plots
    ├── reviews/              ← REVIEW-*.md, SYNTHESIS.md
    ├── REVISION-PLAN.md
    ├── Makefile              ← pdf target
    └── references.bib        ← local bibliography (draws from global)
```

---

## Subcommands

### `setup <name> [venue]`

Initialize a new LaTeX publication directory.

```
panel:publication setup token-efficiency "EMNLP 2026"
panel:publication setup token-efficiency    # prompts for venue
```

Creates: `main.tex`, `sections/` (6 files), `reviews/`, `Makefile`, `_panel.yaml`,
`REVISION-PLAN.md` (template).

**From MODULE.md**: if the module has a track assignment for this publication slug,
seeds `plan.md` with track context and arc paragraphs.

**Batch**: `panel:publication setup alpha beta gamma "CHI 2026"`

---

### `author [targets]`

Write LaTeX sections from `plan.md`. Injects track arc paragraphs into Introduction.

```
panel:publication author                     # all draft publications with plan.md
panel:publication author token-efficiency    # single
panel:publication author 1 3                 # by index
panel:publication author --track methodology # by track
```

**For each publication:**
1. Load `plan.md` and `_panel.yaml`
2. Load track context from `MODULE.md` — arc paragraphs for each track
3. Warn if no track assignment
4. Write sections sequentially: introduction → related-work → methodology → evaluation → discussion → conclusion
5. **Introduction**: inject track arc paragraphs after contributions list
6. Run experiments/scripts listed in plan.md
7. Compile PDF (`make pdf`)
8. Update `_panel.yaml`: `content_mode: full`, `writing_completed: true`

**Track arc injection** (Introduction):
```latex
% --- Research program context ---
% Track methodology: [arc paragraph from MODULE.md]
% Track empirical: [arc paragraph, if publication belongs to this track too]
```

---

### `review [targets]`

Full review lifecycle. Advances each publication through its current stage gate.

```
panel:publication review                       # all eligible
panel:publication review token-efficiency      # single
panel:publication review --until ready         # run until ready stage
panel:publication review --track empirical     # all in track
```

**Stage lifecycle:**

| Stage | Gate | Action |
|-------|------|--------|
| `draft` | main.tex + venue set | Select 5 reviewers, load OLE profiles, assign |
| `panel` | 5+ reviews | Generate `reviews/REVIEW-{NAME}.md` via `buildReviewerContext()` |
| `synthesis` | SYNTHESIS.md | Consolidate → P1/P2/P3 |
| `revision` | P1 items addressed | Create REVISION-PLAN.md, offer to apply |
| `recheck` | avg ≥ 2.5, min ≥ 2 | Round N review cycle |
| `ready` | module panel complete | Awaiting `panel:module review` |
| `submit` | venue confirmed | Submitted |
| `accepted` | acceptance confirmed | Done |

**Reviewers**: loaded from `.craft/roles/panel-reviewer/` via `pluginReviewersPath`.
All reviews use `buildReviewerContext(profile)` — OLE preamble + structured fields.

**Bulk**: each publication advances independently. Gate failures reported but don't
block other publications.

---

### `status [targets]`

```
panel:publication status
═══════════════════════════════════════════════════════════════════════

Module: reviewer-simulation | Publications

 #  Publication                    Track(s)  Stage      Rd  Score   Next
 ─  ──────────────────────────────  ──────── ─────────  ──  ──────  ────────────────────
 1  panel-token-efficiency          A, C     recheck    1   2.8/4   panel:module review
 2  panel-profile-caching           A, B     revision   1   —       Apply P1 items
 3  panel-ole-injection             B        synthesis  1   —       Generate SYNTHESIS.md
 4  panel-cross-venue               C        draft      0   —       panel:publication author

Track coverage (publications only):
  Track A: panel-token-efficiency → panel-profile-caching ✓
  Track B: panel-profile-caching → panel-ole-injection ✓
  Track C: panel-token-efficiency → panel-cross-venue (partial — 1 paper in track C also)
```

---

### `show <name>`

Full detail: history, all reviewer scores, P1/P2/P3 items, track assignments,
OLE profile refs used, PDF build status.

---

### `venue [targets]`

Venue recommendation for formal publication. Factors in:
- Paper content and contribution type
- Track position (cross-citing papers may target same venue)
- Page limits, deadlines, acceptance rates
- Reviewer profile affinities (which venues their expertise aligns with)

```
panel:publication venue token-efficiency
panel:publication venue --track methodology   # coordinate venue across track
```

---

### `build [targets]`

Compile LaTeX to PDF.

```
panel:publication build                 # all publications
panel:publication build token-efficiency
```

Runs `make pdf` in each publication directory. Reports compilation errors.
Copies `main.pdf` to `docs/` on success.

---

### `submit <name>`

Mark a publication as submitted to its target venue.

```
panel:publication submit token-efficiency
panel:publication submit token-efficiency --venue "EMNLP 2026" --date 2026-06-15
```

Updates `_panel.yaml`: `stage: submit`, records submission date and venue.

---

## Bulk Confirmation

For ≥3 publications, confirm before running:

```javascript
if (publications.length >= 3 && !args['--yes']) {
    const answer = await AskUserQuestion({
        question: `Run panel:publication ${subcommand} on ${publications.length} publications?`,
        header: 'Bulk operation',
        options: [
            { label: `Yes, all ${publications.length}`, description: publications.map(p => p.slug).join(', ') },
            { label: 'Select specific', description: 'Choose which to include' },
            { label: 'Cancel' }
        ]
    });
}
```

---

## Progress Reporting (bulk)

```
panel:publication review
═══════════════════════════════════════════════════════════════════════

Reviewing 4 publications...

[1/4] panel-token-efficiency    recheck    → SYNTHESIS complete ✓    (3 min)
[2/4] panel-profile-caching     revision   → P1 items applied ✓      (4 min)
[3/4] panel-ole-injection       draft      → reviewers assigned ✓     (1 min)
[4/4] panel-cross-venue         draft      → gate failed (no main.tex) ✗

Done. 3/4 advanced. 1 failed (panel-cross-venue: run panel:publication author first).
Next: panel:module review (2 publications at recheck stage)
```

---

## Relationship to panel:paper

```
panel:paper my-research        ← quick markdown note
    ↓
panel:paper promote my-research --venue "EMNLP 2026"
    ↓
panel:publication author panel-my-research   ← formal LaTeX
panel:publication review panel-my-research
panel:publication submit panel-my-research
```

Both papers and publications participate in module tracks. MODULE.md tracks
can contain a mix of papers and publications — they're just different content types
at the same track chain position.

---

## Auto-Commit

```javascript
await gitCommitIfEnabled(
    `[panel] ${subcommand} ${publications.map(p => p.slug).join(', ')}`,
    publications.map(p => path.join(publicationsDir, p.slug))
);
```

## Dependencies

- shared/project-config.md — publicationsPath, pluginRoot
- shared/state-loader.md — _panel.yaml read/write
- shared/module-utils.md — MODULE.md, track arc injection
- shared/reviewer-profile-loader.md — loadReviewerProfile(), buildReviewerContext()
- shared/reviewer-selector.md — select 5 reviewers
- shared/synthesis-engine.md — P1/P2/P3 consolidation
- shared/stage-machine.md — stage gate validation
- shared/plan-parser.md — parse plan.md
- shared/quality-checker.md — quality gate validation
- shared/score-utils.md — score aggregation
- shared/git-helper.md — auto-commit
- shared/display-utils.md — terminal formatting
- shared/message-utils.md — standardized output
