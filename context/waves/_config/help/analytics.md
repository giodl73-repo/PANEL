---
format_version: "4.0"
---

# Analytics Suite

Search, analyze, and visualize wave data across all projects.

## Commands

| Command | Purpose |
|---------|---------|
| `/waves:search` | Full-text search with TF-IDF ranking |
| `/waves:metrics` | Performance dashboard with trends |
| `/waves:graph` | Dependency visualization |
| `/waves:report` | Stakeholder reports |

---

## Search

```bash
# Basic search
/waves:search "authentication"

# Filter by project
/waves:search "oauth" --project waves

# Filter by type (wave, pulse, role, meta)
/waves:search "refactor" --type wave

# Filter by date
/waves:search "api" --date last-30d
/waves:search "auth" --date 2026-01-01..2026-02-01

# Filter by role
/waves:search "setup" --role backend
```

**Features:**
- TF-IDF relevance ranking
- Field-weighted scoring (title > tags > summary > content)
- Highlighted context snippets
- Automatic index caching

---

## Metrics Dashboard

```bash
# Full dashboard
/waves:metrics

# Filter by project
/waves:metrics --project Performance

# Last N waves
/waves:metrics --last 10

# Export to CSV
/waves:metrics --export metrics.csv
```

**Dashboard Sections:**
- Completion rates (waves, pulses, tasks)
- Planning accuracy with variance
- Scenario breakdown (feature, refactor, fix, etc.)
- Status breakdown with progress indicators
- Role velocity (pulses per role)
- Duration trend sparkline

---

## Dependency Graph

```bash
# Single wave graph
/waves:graph ^14

# ASCII output (default)
/waves:graph ^14 --format ascii

# Mermaid output (for documentation)
/waves:graph ^14 --format mermaid

# Show critical path only
/waves:graph --critical-path
```

**Output:**
```
DEPENDENCY GRAPH: ^14+command-expansion
═══════════════════════════════════════

Level 0: [~1 context-resolver]
              │
              ▼
Level 1: [~2 wave-loader] ──► [~3 settings-loader]
              │                      │
              ▼                      ▼
Level 2: [~4 run-command] ◄── [~5 complete-command]

Critical Path: ~1 → ~2 → ~4 (3 pulses)
```

---

## Reports

```bash
# Wave completion report
/waves:report ^17

# Weekly progress report
/waves:report --weekly

# Project report with HTML output
/waves:report --project waves --format html

# Quarterly executive summary
/waves:report --quarterly Q1-2026
```

**Report Types:**
- **Wave**: Single wave summary with pulses, metrics, commits
- **Weekly**: Active waves progress across all projects
- **Project**: Full project history and statistics
- **Quarterly**: Executive summary with trends

**Output Formats:**
- Markdown (default)
- HTML

---

## Performance Targets

| Operation | Target | Typical |
|-----------|--------|---------|
| Search (cached) | <100ms | ~50ms |
| Search (cold) | <5s | ~1.5s |
| Metrics calc | <2s | ~500ms |
| Graph render | <1s | ~100ms |
| Index build | <5s | ~1.5s |

---

## Data Extraction

All analytics commands use consistent data extraction:

- Reads all wave directories (`NN+wave-slug/`)
- Parses `wave.md`, `_meta.yaml`, and pulse files
- Handles V4 format with graceful defaults
- Cross-project aggregation

**Extracted Fields:**
- Wave: order, slug, UUID, status, dates, estimates
- Pulse: order, slug, status, role, hours, dependencies
- Aggregate: completion rates, planning accuracy, role velocity

---

## See Also

- `shared/data-extractor.md` - Data extraction logic
- `shared/metrics-engine.md` - Metrics computation
- `commands/search.md` - Search implementation
- `commands/metrics.md` - Metrics dashboard
- `commands/graph.md` - Dependency graphs
- `commands/report.md` - Report generation
