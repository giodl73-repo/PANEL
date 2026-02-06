<command-name>panel:report</command-name>

# panel:report — Generate Review Reports

Produces formatted reports at various levels of detail for sharing with collaborators or archiving.

## Arguments

- `--paper <name>` — Report on a single paper
- `--round <N>` — Report on a specific review round
- `--portfolio` — Portfolio-level report across all papers
- `--format <fmt>` — Output format: `markdown` (default), `table`, `summary`

## Behavior

1. **Load state**: Read all `_panel.yaml` files in the project.
2. **Gather review data**: Read review files, synthesis documents, score histories.
3. **Generate report**: Produce the requested report type.

## Report Types

### Per-Paper Report (`--paper <name>`)

```markdown
# Review Report: panel-review-methodology

**Title**: AI-Simulated Expert Review: A Methodology for Pre-Submission Paper Assessment
**Venue**: CHI 2026
**Stage**: recheck (round 2)
**Score**: 2.8/4 (round 1: 2.2/4 → round 2: 2.8/4, Δ +0.6)

## Reviewer Panel

| Reviewer | Affiliation | R1 Score | R2 Score | Verdict |
|----------|-------------|----------|----------|---------|
| Percy Liang | Stanford | 2/4 | 3/4 | Accept |
| Harrison Chase | LangChain | 2/4 | 3/4 | Accept |
| ...

## Key Findings
- P1 items: 3 (3 addressed)
- P2 items: 5 (3 addressed)
- Score improvement: +0.6/4 across rounds

## Remaining Concerns
[Extracted from latest synthesis]
```

### Portfolio Report (`--portfolio`)

```markdown
# Portfolio Review Report

**Papers**: 5 | **Date**: 2026-02-05

## Status Overview

| # | Paper | Stage | Round | Score | Venue | Tier |
|---|-------|-------|-------|-------|-------|------|
| 1 | review-methodology | recheck | 2 | 2.8/4 | CHI 2026 | B+ |
...

## Cross-Portfolio Themes
[Common strengths and weaknesses across papers]

## Submission Readiness
[Papers ready vs. needing more work]
```

## Dependencies

- shared/state-loader.md — Read _panel.yaml files
- shared/score-utils.md — Score aggregation and trends
- shared/display-utils.md — Terminal formatting
