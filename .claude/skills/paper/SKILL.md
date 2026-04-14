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
  venue    [targets]        Venue recommendation + submission strategy
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

## Subcommand Dispatch

| Subcommand | File | Description |
|------------|------|-------------|
| `setup` | See [setup.md](setup.md) | Initialize paper directories |
| `author` | See [author.md](author.md) | Write papers from plan.md |
| `review` | See [review.md](review.md) | Run review lifecycle |
| `status` | See [status.md](status.md) | Show stage, round, score |
| `show` | See [show.md](show.md) | Detailed view of one paper |
| `promote` | See [promote.md](promote.md) | Graduate to LaTeX publication |
| `venue` | See [venue.md](venue.md) | Venue recommendation |
| `import` | See [import.md](import.md) | Discover and import papers |

---

## Bulk Confirmation

For bulk operations affecting >=3 papers, confirm before running:

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
