# Panel — AI-Simulated Expert Review Lifecycle

A Claude Code plugin that drives research papers through a complete AI-simulated expert review lifecycle via a three-tier review architecture: paper-level reviews, module-level panels, and monorepo-level board reviews.

## ⚠️ Critical Framing

**This is a quality improvement simulation, NOT peer review.**

### What This Means:
- **All feedback is AI-generated** based on domain expert personas (e.g., "Percy Liang," "Michael Bernstein")
- **Named researchers are NOT participants** — they did not write, review, or endorse any output
- **Purpose: strengthen your work** before real submission, not "respond to reviewers"
- **P1/P2/P3 = improvement suggestions**, not reviewer mandates
- **Use what helps, ignore what doesn't** align with your research goals

### Template Policy:
- **NEVER use conference templates** (acmart, neurips, etc.) unless user **explicitly submitting** to that conference
- **Default to generic `article` class** to emphasize this is quality work, not submission-ready formatting
- **Only use conference formatting** when user has real reviewer feedback or is actually submitting

### Language to Use:
- ✅ "simulated feedback," "AI-generated assessment," "quality improvement suggestions"
- ✅ "AI persona based on [Name]," "simulated reviewer perspective"
- ✅ "strengthen this aspect," "enhance the work," "improvement opportunities"
- ❌ "reviewer said," "address reviewer concerns," "respond to feedback"
- ❌ "must fix," "blocking issue," "required for acceptance"

## Three-Tier Review Architecture

```
                    ┌───────────────┐
                    │  panel:board  │  Monorepo level
                    │  REVIEW_BOARD │  Cross-module synthesis
                    └───────┬───────┘
                        ↕ findings bubble up
                        ↕ revisions flow down
                    ┌───────────────┐
                    │panel:convene  │  Module level
                    │ REVIEW_PANEL  │  Cross-portfolio panel (7 reviewers)
                    └───────┬───────┘
                        ↕ findings bubble up
                        ↕ revisions flow down
              ┌─────────────────────────┐
              │     panel:review        │  Individual paper level
              │  REVIEW-*.md, SYNTHESIS │  Per-paper review rounds
              └─────────────────────────┘
```

**Bidirectional flow:**
- **Up**: Paper reviews surface issues → panel sees patterns across papers → board sees patterns across modules
- **Down**: Board generates B1/B2/B3 per module → panel generates PP1/PP2/PP3 per paper → papers revise

**Impact classification at each tier:**

| Tier | Prefix | High Impact (P1) | Medium Impact (P2) | Low Impact (P3) |
|------|--------|----------|-----------|--------------|
| Paper | P1/P2/P3 | 3+ personas or critical gap | 2+ personas | 1 persona |
| Panel | PP1/PP2/PP3 | Cross-paper pattern or threatens module | 2+ papers affected | 1 paper |
| Board | B1/B2/B3 | 3+ board members or threatens program | 2+ modules affected | 1 module |

## Project Layout

```
panel/
├── .claude-plugin/
│   ├── plugin.json              # Plugin manifest (12 commands)
│   └── craft.json               # Craft feature tracking
├── .claude/
│   └── panel.json               # Plugin configuration (gitStrategy, suppressMessages)
├── commands/
│   ├── review.md                # Per-paper review lifecycle (8 stages)
│   ├── convene.md               # Module-level cross-portfolio panel
│   ├── board.md                 # Monorepo-level board review
│   ├── status.md                # Overview of all papers
│   ├── show.md                  # Detailed paper view
│   ├── reviewers.md             # Reviewer database browser
│   ├── setup.md                 # Project initialization
│   ├── import.md                # Discover + generate papers, or import artifacts
│   ├── report.md                # Generate reports
│   ├── help.md                  # Interactive help
│   ├── venue.md                 # Venue recommendation
│   └── uninstall.md             # Clean plugin removal
├── shared/
│   ├── stage-machine.md         # Stage progression logic + gates
│   ├── state-loader.md          # Read/write _panel.yaml
│   ├── reviewer-selector.md     # Match reviewers to papers
│   ├── synthesis-engine.md      # Consolidate reviews → P1/P2/P3
│   ├── score-utils.md           # Score aggregation, consensus metrics
│   ├── display-utils.md         # Terminal formatting
│   ├── topic-discovery.md       # Scan sources → propose paper topics
│   ├── paper-generator.md       # Paper content generation logic
│   ├── panel-utils.md           # Module-level panel utilities (PP1/PP2/PP3, rounds)
│   ├── board-utils.md           # Board-level utilities (module discovery, B1/B2/B3)
│   ├── message-utils.md         # Standardized output formatting
│   ├── error-handler.md         # Error codes and recovery suggestions
│   ├── git-helper.md            # Auto-commit with git strategy
│   └── git-utils.md             # (deprecated, use git-helper.md)
├── templates/
│   ├── help/                    # Help topic files
│   ├── review-template.md       # Individual review structure
│   ├── synthesis-template.md    # Synthesis document structure
│   └── revision-plan-template.md
├── config/
│   ├── stages.yaml              # Stage definitions + gates
│   ├── scoring.yaml             # Scoring rubrics (1-4 scale, 0-10 scale)
│   └── schemas/
│       └── panel-state.schema.yaml
├── research/                    # Research papers (5 papers)
│   ├── panel-{name}/           # Each paper: main.tex, sections/, Makefile
│   ├── docs/                   # Compiled PDFs
│   ├── Makefile                # Master build
│   ├── RESEARCH.md             # Paper inventory + dependency graph
│   ├── REVIEWERS.md            # Module reviewer subset
│   └── REVIEW_PANEL.md         # Module-level panel review
├── docs/                        # Plugin documentation
├── scripts/
│   ├── sync-to-plugin.sh       # → C:\src\plugins\panel
│   └── sync-to-research.sh     # → C:\src\research\panel
└── README.md
```

## The 8-Stage Lifecycle

```
Stage        Description                                    Gate to advance
─────        ───────────                                    ───────────────
1. draft     Paper exists, target venue identified          main.tex exists + venue set
2. panel     Reviewer panel assembled, reviews running      5+ REVIEW-*.md files generated
3. synthesis Reviews consolidated → SYNTHESIS.md            P1/P2/P3 tiering complete
4. revision  Author revising based on synthesis             All P1 items addressed
5. recheck   Round N reviews (N≥2), may loop → synthesis    Avg score ≥ 2.5/4, none < 2/4
6. ready     Panel review complete (panel:convene)           REVIEW_PANEL.md + PP1 addressed
7. submit    Paper submitted to target venue                Submission confirmed
8. accepted  Paper accepted at venue                        Acceptance confirmed
```

## Commands (12)

| Command | Tier | Purpose |
|---------|------|---------|
| `panel:review` | Paper | Per-paper review lifecycle — moves paper through all 8 stages |
| `panel:convene` | Module | Cross-portfolio panel review with rounds (7 reviewers, PP1/PP2/PP3) |
| `panel:board` | Monorepo | Cross-module board review with rounds (7 members, B1/B2/B3) |
| `panel:status` | — | Overview of all papers: stage, round, score, next action |
| `panel:show` | — | Detailed view of one paper |
| `panel:reviewers` | — | Browse/filter reviewer database |
| `panel:setup` | — | Initialize project or add a new paper |
| `panel:import` | — | Discover papers from roadmap/waves/commits, or import existing artifacts |
| `panel:report` | — | Generate review reports |
| `panel:help` | — | Interactive help system |
| `panel:venue` | — | Venue recommendation + submission strategy |
| `panel:uninstall` | — | Remove plugin data and configuration — clean uninstall |

## Per-Paper State (`_panel.yaml`)

Each paper directory contains a `_panel.yaml` tracking lifecycle state:
- Current stage and round number
- Assigned reviewers with scores
- Review completion status by round
- P1 item tracking (addressed/not addressed)
- Stage transition history

## Round Tracking (Panel + Board Tiers)

Paper-level keeps flat file pattern (`ROUND2-REVIEW-*.md`). Panel and board tiers use round directories:

```
{module}/
├── REVIEW_PANEL.md              ← always the latest/canonical
├── panel-reviews/
│   ├── round-1/
│   │   ├── REVIEW_PANEL.md      ← snapshot
│   │   └── PANEL-REVISION-PLAN.md
│   └── round-2/
│       └── ...

{repo}/
├── REVIEW_BOARD.md              ← always the latest/canonical
├── BOARD-REVISION-PLAN-{module}.md
├── board-reviews/
│   ├── round-1/
│   │   ├── REVIEW_BOARD.md      ← snapshot
│   │   └── BOARD-REVISION-PLAN-*.md
│   └── round-2/
│       └── ...
```

## Research Papers (5)

| # | Paper | Venue Target |
|---|-------|-------------|
| 1 | panel-review-methodology | CHI / CSCW |
| 2 | panel-reviewer-calibration | EMNLP / ACL |
| 3 | panel-revision-dynamics | NeurIPS D&B |
| 4 | panel-portfolio-assessment | JCDL / Scientometrics |
| 5 | panel-synthesis-methods | AAAI / IJCAI |

## Build Commands

```bash
# Build all research papers
cd research
make all

# Build single paper
make -C research/panel-review-methodology pdf

# Copy PDFs to docs/
cd research
make dist
```

## Ship It

When the user says "ship it", run the full deploy sequence:

```bash
# 1. Commit (with [panel] prefix)
git add <changed files>
git commit -m "[panel] <message>"

# 2. Push
git push

# 3. Sync plugin → C:\src\plugins\panel (pulls, copies, commits, pushes in target repo)
./scripts/sync-to-plugin.sh --push

# 4. Sync research → C:\src\research\panel (pulls, copies, commits, pushes in target repo)
./scripts/sync-to-research.sh --push
```

All four steps run in order. If any step fails, stop and report.

Sync scripts support: `--push` (push to remote), `--dry-run` (preview), `--message "msg"` (custom commit message).

## Plugin Configuration

Panel uses `.claude/panel.json` for plugin settings:

```json
{
  "default": "panel",
  "gitStrategy": "auto-commit",
  "suppressMessages": []
}
```

### Settings

| Setting | Values | Description |
|---------|--------|-------------|
| `gitStrategy` | `"auto-commit"` or `"manual"` | Controls whether commands auto-commit changes |
| `suppressMessages` | Array of message types | Suppress specific output types: `["item", "subitem", "separator"]` |
| `default` | String | Default project name (for multi-project support) |

### Git Strategy

- **auto-commit**: Commands commit changes automatically when they finish using scoped `git add` (only files the command touched)
- **manual**: Changes are left uncommitted for user review

Commands respect this setting through `shared/git-helper.md` which provides:
- `gitCommitIfEnabled(message, paths)` — Simple auto-commit
- `auto_commit(context)` — Scoped commit with detailed control

### Message Utilities

All commands use standardized output formatting via `shared/message-utils.md`:

| Type | Symbol | Use |
|------|--------|-----|
| `header` | `═══` | Section headers |
| `stage` | `▶` | Stage transitions |
| `success` | `✓` | Confirmations |
| `error` | `✗` | Errors |
| `warning` | `⚠` | Warnings |
| `item` | `•` | List items |
| `complete` | `+` | Completed actions |

Use `suppressMessages` in config to reduce verbosity for specific workflows.

### Error Handling

Standardized error codes via `shared/error-handler.md`:

- **E100-E199**: File & state errors
- **E200-E299**: Stage & workflow errors
- **E300-E399**: Review errors
- **E400-E499**: Module & board errors
- **E500-E599**: Git & sync errors
- **E600-E699**: Configuration errors

Each error includes recovery suggestions and relevant command references.

## Conventions

- Commit messages prefixed with `[panel]`
- PDFs in `research/docs/` are canonical outputs
- Review files use ALL-CAPS: `REVIEW-PERCY-LIANG.md`, `SYNTHESIS.md`
- State files use underscore prefix: `_panel.yaml`
