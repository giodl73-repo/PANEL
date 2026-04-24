---
name: board
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

## Sub-command Dispatch

| Sub-command | File | Description |
|-------------|------|-------------|
| `review` | See [review.md](review.md) | Full cross-module board review flow (7-member board, B1/B2/B3, snapshots) |
| `status` | See [status.md](status.md) | Module registry, track map, revision progress |
| `revisions` | See [revisions.md](revisions.md) | B1/B2/B3 progress across all modules |
| `scaffold` | See [scaffold.md](scaffold.md) | Discover and scaffold uninitialized modules |
| `member` | See [misc.md](misc.md) | Regenerate one board member's assessment |
| `update` | See [misc.md](misc.md) | Targeted refresh of a REVIEW_BOARD.md section |

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
