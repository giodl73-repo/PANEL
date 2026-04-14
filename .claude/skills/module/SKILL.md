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

## Subcommand Dispatch

| Subcommand | File | Description |
|------------|------|-------------|
| `design` | See [design.md](design.md) | Design module architecture — tracks, contracts, arc paragraphs, MODULE.md |
| `review` | See [review.md](review.md) | Cross-portfolio panel review with 7-member panel, PP1/PP2/PP3 |
| `curate` | See [curate.md](curate.md) | Diagnose module against three properties, write CURATION.md |
| `status` | See [status.md](status.md) | Track health, paper coverage, PP item progress |
| `check` | See [check.md](check.md) | Validate track coverage — orphans, chains, contracts |
| `revisions` | See [revisions.md](revisions.md) | Show PP1/PP2/PP3 progress tagged by track |
| `apply` | See [apply.md](apply.md) | Apply PP1/PP2 revision items to paper LaTeX source |
| `assign` | See [misc.md](misc.md) | Assign a paper to a track |
| `track` | See [misc.md](misc.md) | Add or inspect a track |
| `member` | See [misc.md](misc.md) | Regenerate one panel member's assessment |

---

## File Layout

```
{researchDir}/
├── MODULE.md                    <- track definitions, paper table, arcs, contracts
├── REVIEW_PANEL.md              <- latest panel review (from panel:module review)
├── PANEL-REVISION-PLAN.md       <- PP items with track tags
├── CURATION.md                  <- curation plan (from panel:module curate)
├── panel-reviews/
│   └── round-{N}/
│       ├── REVIEW_PANEL.md
│       ├── PANEL-REVISION-PLAN.md
│       └── MODULE.md            <- snapshot of module state at review time
└── panel-*/                     <- paper directories
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
