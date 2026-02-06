# Panel — AI-Simulated Expert Review Lifecycle

A Claude Code plugin that drives research papers through a complete AI-simulated expert review lifecycle via stage-driven commands.

## Project Layout

```
panel/
├── .claude-plugin/
│   └── plugin.json              # Plugin manifest (9 commands)
├── commands/
│   ├── go.md                    # Stage-driven lifecycle command
│   ├── status.md                # Overview of all papers
│   ├── show.md                  # Detailed paper view
│   ├── reviewers.md             # Reviewer database browser
│   ├── setup.md                 # Project initialization
│   ├── import.md                # Import existing review process
│   ├── report.md                # Generate reports
│   ├── help.md                  # Interactive help
│   └── venue.md                 # Venue recommendation
├── shared/
│   ├── stage-machine.md         # Stage progression logic + gates
│   ├── state-loader.md          # Read/write _panel.yaml
│   ├── reviewer-selector.md     # Match reviewers to papers
│   ├── synthesis-engine.md      # Consolidate reviews → P1/P2/P3
│   ├── score-utils.md           # Score aggregation, consensus metrics
│   └── display-utils.md         # Terminal formatting
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
│   └── REVIEW_PANEL.md         # Placeholder
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
6. ready     All reviewers Accept or better                 Cross-portfolio panel done
7. submit    Paper submitted to target venue                Submission confirmed
8. accepted  Paper accepted at venue                        Acceptance confirmed
```

## Commands (9)

| Command | Purpose |
|---------|---------|
| `panel:go` | The one command — moves paper through all 8 stages |
| `panel:status` | Overview of all papers: stage, round, score, next action |
| `panel:show` | Detailed view of one paper |
| `panel:reviewers` | Browse/filter reviewer database |
| `panel:setup` | Initialize project or add a new paper |
| `panel:import` | Import existing review process |
| `panel:report` | Generate review reports |
| `panel:help` | Interactive help system |
| `panel:venue` | Venue recommendation + submission strategy |

## Per-Paper State (`_panel.yaml`)

Each paper directory contains a `_panel.yaml` tracking lifecycle state:
- Current stage and round number
- Assigned reviewers with scores
- Review completion status by round
- P1 item tracking (addressed/not addressed)
- Stage transition history

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

## Conventions

- Commit messages prefixed with `[panel]`
- PDFs in `research/docs/` are canonical outputs
- Review files use ALL-CAPS: `REVIEW-PERCY-LIANG.md`, `SYNTHESIS.md`
- State files use underscore prefix: `_panel.yaml`
