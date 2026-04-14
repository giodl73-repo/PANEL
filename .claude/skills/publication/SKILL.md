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

Each publication lives in `publicationsDir/<slug>/` (no prefix — module dir provides namespace):

```
{researchPath}/
├── docs/                     ← all compiled PDFs land here
├── Makefile                  ← module-level: make dist → docs/
├── MODULE.md
└── publications/
    ├── Makefile              ← publications-level: discovers all subdirs dynamically
    └── token-efficiency/     ← no panel- prefix
        ├── _panel.yaml       ← state (stage, round, reviewers, scores)
        ├── plan.md           ← research plan (seeded from paper if promoted)
        ├── main.tex          ← root LaTeX file
        ├── sections/
        │   ├── 01-introduction.tex
        │   ├── 02-related-work.tex
        │   ├── 03-methodology.tex
        │   ├── 04-evaluation.tex
        │   ├── 05-discussion.tex
        │   └── 06-conclusion.tex
        ├── figures/          ← diagrams, plots
        ├── reviews/          ← REVIEW-*.md, SYNTHESIS.md
        ├── REVISION-PLAN.md
        ├── Makefile          ← dist target puts PDF in ../../docs/
        └── references.bib
```

**Makefile chain:**
- `make dist` at module level → delegates to `publications/Makefile` → each publication's `Makefile` → PDF in `../../docs/{slug}.pdf`
- All three Makefile levels are dynamic — no hardcoded publication names

---

## Subcommand Dispatch

| Subcommand | File | Description |
|------------|------|-------------|
| `setup` | See [setup.md](setup.md) | Initialize LaTeX publication directory |
| `author` | See [author.md](author.md) | Write LaTeX sections from plan.md |
| `review` | See [review.md](review.md) | Full review lifecycle (8 stages) |
| `status` | See [status.md](status.md) | Show stage, round, score |
| `show` | See [show.md](show.md) | Detailed view of one publication |
| `venue` | See [venue.md](venue.md) | Venue recommendation and submission strategy |
| `build` | See [build.md](build.md) | Compile PDF (make pdf) |
| `submit` | See [submit.md](submit.md) | Mark as submitted to venue |

Load the appropriate sub-command file based on the first argument after `panel:publication`.

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
