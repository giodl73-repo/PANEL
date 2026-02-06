# Help: Command Reference

## Core Lifecycle

| Command | Purpose | Common Usage |
|---------|---------|-------------|
| `panel:go` | Move paper through all 8 stages | `panel:go --paper my-paper` |

### panel:go options
- `--paper <name>` — Target paper (default: auto-detect)
- `--until <stage>` — Stop at stage (draft/panel/synthesis/revision/recheck/ready/submit/accepted)
- `--round N` — Force review round number
- `--dry-run` — Preview without changes

## Status & Access

| Command | Purpose | Common Usage |
|---------|---------|-------------|
| `panel:status` | Portfolio overview | `panel:status` |
| `panel:show` | Detailed paper view | `panel:show my-paper --scores` |
| `panel:reviewers` | Browse reviewer database | `panel:reviewers --venue CHI` |

### panel:show options
- `--reviews` — Show individual review summaries
- `--history` — Show stage transition history
- `--scores` — Show score progression

### panel:reviewers options
- `--category <cat>` — Filter by category
- `--venue <venue>` — Filter by venue
- `--tag <tag>` — Filter by expertise tag
- `--search <query>` — Free-text search

## Import & Setup

| Command | Purpose | Common Usage |
|---------|---------|-------------|
| `panel:setup` | Initialize panel in project | `panel:setup` |
| `panel:import` | Import existing reviews | `panel:import --module merit/` |

## Reporting & Help

| Command | Purpose | Common Usage |
|---------|---------|-------------|
| `panel:report` | Generate reports | `panel:report --portfolio` |
| `panel:help` | Help topics | `panel:help stages` |

### panel:report options
- `--paper <name>` — Per-paper report
- `--portfolio` — Portfolio-level report
- `--format <fmt>` — Output format (markdown/table/summary)

## Venue & Config

| Command | Purpose | Common Usage |
|---------|---------|-------------|
| `panel:venue` | Venue recommendation | `panel:venue --paper my-paper` |
