---
name: panel:paper
description: Quick markdown research papers — setup, author, review, status, show, promote. Fast-cycle lightweight research notes and position papers in papers/ directory.
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Bash
  - AskUserQuestion
---

# panel:paper — Quick Research Papers (Markdown)

Lightweight markdown research papers in `papersPath` (`research/papers/` by default).
Fast to write, fast to review. Think: working notes, position papers, technical reports,
pre-publication research snapshots.

**Not for formal LaTeX publications** — use `panel:publication` for those.

## Plugin Root + Config

```javascript
// @import ../shared/project-config.md
// @import ../shared/state-loader.md
// @import ../shared/module-utils.md

const projectConfig = loadProjectConfig();
const papersDir = path.join(process.cwd(), projectConfig.papersPath);
const pluginRoot = projectConfig.pluginRoot;
```

---

## Usage

```
panel:paper <subcommand> [targets] [options]

Subcommands:
  setup    <name>           Initialize one or more markdown paper directories
  author   [targets]        Write papers (markdown, fast)
  review   [targets]        Run lightweight review lifecycle
  status   [targets]        Show stage, round, score for papers
  show     <name>           Detailed view of one paper
  promote  <name>           Graduate a paper to a formal LaTeX publication
  import   [options]        Discover and import papers from waves/roadmap/commits

Targets (for subcommands that accept them):
  (none)        All eligible papers
  <name>        One paper by slug or partial match
  1 3 5         By index (from panel:paper status)
  --track <t>   All papers in a track
  --stage <s>   All papers at a stage (e.g., --stage draft)
  --tag <t>     All papers with a tag
```

---

## Target Resolution

All subcommands use the same target resolution logic:

```javascript
// @import ../shared/paper-target-resolver.md

async function resolveTargets(args, researchDir, subcommand) {
    // No targets → all eligible papers for this subcommand
    if (args.targets.length === 0) {
        return getAllEligiblePapers(researchDir, subcommand);
    }

    // Numeric targets → by index from status list
    if (args.targets.every(t => /^\d+$/.test(t))) {
        const all = await getAllPapers(researchDir);
        return args.targets.map(i => all[parseInt(i) - 1]).filter(Boolean);
    }

    // --track filter
    if (args['--track']) {
        const moduleFile = resolveModuleFile(researchDir);
        if (moduleFile) {
            const module = parseModule(moduleFile);
            return getTrackPapers(module, args['--track']);
        }
    }

    // --stage filter
    if (args['--stage']) {
        const papers = await getAllPapers(researchDir);
        return papers.filter(p => p.state.stage === args['--stage']);
    }

    // Named targets → slug match or partial match
    return args.targets.map(t => resolvePaperByName(t, researchDir)).filter(Boolean);
}
```

**Eligibility by subcommand:**
- `author`: papers at `draft` stage with `plan.md` present, no `main.tex` yet
- `review`: papers at any stage except `accepted`
- `status`: all papers
- `venue`: papers at `draft` or `ready` stage

---

## Subcommands

### `setup <name> [venue]`

Initialize one or more paper directories. Each gets `_panel.yaml`, `sections/`,
`reviews/`, `Makefile`, `REVISION-PLAN.md`. Prompts for venue if not supplied.

**Bulk**: `panel:paper setup name-1 name-2 name-3 "ACL 2026"` — batch-initialize.
**From MODULE.md**: if MODULE.md exists, seeds `plan.md` with track context.

```javascript
for (const name of targetNames) {
    await setupPaper(name, venue, researchDir, pluginRoot, projectConfig);
}
```

See `commands/setup.md` Level 2 behavior for the per-paper setup logic.

---

### `author [targets]`

Write papers from `plan.md`. Reads MODULE.md for track arc paragraphs if present.

**Single**: `panel:paper author my-paper`
**All eligible**: `panel:paper author` — all papers with plan.md but no main.tex
**Selection**: `panel:paper author 1 3` — papers 1 and 3 from status list
**By track**: `panel:paper author --track methodology`

**Bulk mode**: runs sequentially (papers in a module often share context).
Override with `--parallel` for independent papers.

```javascript
const papers = await resolveTargets(args, researchDir, 'author');
msg(`Authoring ${papers.length} paper(s)`, 'header');

for (const paper of papers) {
    msg(`→ ${paper.slug}`, 'stage');
    await authorPaper(paper, researchDir, pluginRoot, projectConfig);
}
```

For each paper, `authorPaper()` follows `commands/author.md` logic:
- Load plan.md, _panel.yaml
- Load track arc paragraphs from MODULE.md
- Warn if paper has no track assignment
- Run writing tasks sequentially (sections, experiments, figures)
- Inject track arc into Introduction
- Compile PDF, update _panel.yaml

---

### `review [targets]`

Run the review lifecycle. Advances each paper through its current stage gate.

**Single**: `panel:paper review my-paper`
**All eligible**: `panel:paper review`
**Until stage**: `panel:paper review --until ready`
**One round only**: `panel:paper review --round` (default: advance one stage)

```javascript
const papers = await resolveTargets(args, researchDir, 'review');
const until = args['--until'] || null;

msg(`Reviewing ${papers.length} paper(s)`, 'header');

for (const paper of papers) {
    msg(`→ ${paper.slug} [${paper.state.stage}]`, 'stage');
    await reviewPaper(paper, researchDir, pluginRoot, projectConfig, { until });
}
```

**Stage handlers** (from `commands/review.md`):

| Current stage | Gate | Action |
|--------------|------|--------|
| `draft` | main.tex + venue | Select 5 reviewers, load profiles, assign |
| `panel` | 5+ reviews exist | Generate `REVIEW-{NAME}.md` per reviewer using `buildReviewerContext()` |
| `synthesis` | SYNTHESIS.md | Consolidate reviews → P1/P2/P3 |
| `revision` | P1 items addressed | Create REVISION-PLAN.md, offer to apply |
| `recheck` | avg ≥ 2.5, min ≥ 2 | Round N review cycle |
| `ready` | panel complete | Await `panel:module review` |

**Bulk behavior**: each paper advances independently. A paper that fails its gate
is reported but doesn't block other papers.

---

### `status [targets]`

Show stage, round, score, and next action for papers.

**All papers**: `panel:paper status`
**Track**: `panel:paper status --track empirical`

```
panel:paper status
═══════════════════════════════════════════════════════════════════════

Module: reviewer-simulation
Research: research/reviewer-simulation/

 #  Paper                         Track(s)   Stage      Round  Score   Next
 ─  ────────────────────────────  ─────────  ─────────  ─────  ──────  ────────────────
 1  panel-token-efficiency        A, C       recheck    1      2.8/4   panel:module review
 2  panel-profile-caching         A, B       revision   1      —       Apply P1 items
 3  panel-ole-injection           B          synthesis  1      —       Generate SYNTHESIS
 4  panel-cross-venue-analysis    C          draft      0      —       panel:paper author
 5  panel-calibration-study       B, C       draft      0      —       plan.md missing ⚠

Track coverage:
  Track A: 2 papers (panel-token-efficiency → panel-profile-caching) ✓
  Track B: 3 papers (panel-profile-caching → panel-ole-injection → panel-calibration-study) partial
  Track C: 3 papers (panel-token-efficiency → panel-cross-venue-analysis → ?) broken — needs paper-3

Orphan papers: none
```

---

### `show <name>`

Detailed view of one paper: full history, all review scores, P1/P2/P3 items,
track assignments, reviewer profiles used.

See `commands/show.md` for display logic.

---

### `promote <name>`

Graduate a markdown paper to a formal LaTeX publication in `publicationsPath`.

```
panel:paper promote my-quick-research
panel:paper promote my-quick-research --venue "CHI 2026"
```

**What it does:**
1. Reads the paper's markdown content and `_panel.yaml`
2. Creates a new publication directory in `publicationsPath/`
3. Converts markdown content → LaTeX skeleton (main.tex + sections/)
4. Copies `_panel.yaml` with `type: publication`, `promoted_from: <paper-slug>`
5. Creates `plan.md` seeded from the paper's existing content
6. Updates MODULE.md: replaces paper with publication in track assignments
7. Marks original paper as `promoted` in its `_panel.yaml`

**Result:** The publication starts at `draft` stage, ready for `panel:publication author`
to fill in the formal LaTeX sections using the markdown paper as source material.

```
✓ Promoted: my-quick-research → publications/panel-my-quick-research/
  Track assignments carried over: [A, C]
  Next: panel:publication author panel-my-quick-research
```

### `venue [targets]`

Venue recommendation based on paper content, scope, and track position.

**Single**: `panel:paper venue my-paper`
**All draft papers**: `panel:paper venue --stage draft`

Shows: recommended venues ranked by fit, submission timeline, page limits,
acceptance rate, track alignment.

---

### `import [options]`

Discover and import papers from waves, roadmap, or existing artifacts.

```
panel:paper import                         # interactive discovery
panel:paper import --from waves            # scan waves for paper topics
panel:paper import --from commits          # scan git commits
panel:paper import --artifact ./existing/  # import existing review artifacts
```

See `commands/import.md` for discovery logic.

---

## Bulk Confirmation

For bulk operations affecting ≥3 papers, confirm before running:

```javascript
if (papers.length >= 3 && !args['--yes']) {
    const answer = await AskUserQuestion({
        question: `Run panel:paper ${subcommand} on ${papers.length} papers?`,
        header: 'Bulk operation',
        options: [
            { label: `Yes, run on all ${papers.length}`, description: papers.map(p => p.slug).join(', ') },
            { label: 'Select specific papers', description: 'Choose which to include' },
            { label: 'Cancel' }
        ]
    });
    if (answer === 'Select specific papers') {
        // AskUserQuestion with multiSelect: true
    }
}
```

---

## Progress Reporting (bulk)

```
panel:paper review
═══════════════════════════════════════════════════════════════════════

Running review on 4 papers...

[1/4] panel-token-efficiency        recheck → complete ✓   (2 min)
[2/4] panel-profile-caching         revision (P1 items applied) ✓  (3 min)
[3/4] panel-ole-injection           synthesis → SYNTHESIS.md ✓  (4 min)
[4/4] panel-cross-venue-analysis    draft → reviewers assigned ✓  (1 min)

Done. 4/4 papers advanced.
Next: panel:module review (2 papers at recheck stage)
```

---

## Auto-Commit

After each paper operation:
```javascript
await gitCommitIfEnabled(
    `[panel] ${subcommand} ${papers.map(p => p.slug).join(', ')}`,
    papers.map(p => path.join(researchDir, p.slug))
);
```

## Dependencies

- shared/project-config.md — researchPath, pluginRoot, reviewersPath
- shared/state-loader.md — _panel.yaml read/write
- shared/module-utils.md — MODULE.md, track arc injection
- shared/reviewer-profile-loader.md — loadReviewerProfile(), buildReviewerContext()
- shared/reviewer-selector.md — select 5 reviewers per paper
- shared/synthesis-engine.md — P1/P2/P3 consolidation
- shared/stage-machine.md — stage gate validation
- shared/plan-parser.md — parse plan.md into tasks
- shared/quality-checker.md — quality gate validation
- shared/score-utils.md — score aggregation
- shared/git-helper.md — auto-commit
- shared/display-utils.md — terminal formatting
- shared/message-utils.md — standardized output
