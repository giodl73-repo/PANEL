# Panel Utils — Module-Level Cross-Portfolio Panel Utilities

Shared utility for managing module-level panel reviews across multiple papers, including PP1/PP2/PP3 generation, round tracking, and bubble-up logic.

## Paper Readiness

### assess_paper_readiness(papers)

```
Input:  array of { dir, state } from state-loader.discover_papers()
Output: {
  ready: [{ dir, state, score_summary }],     # stage >= recheck and gate passed
  not_ready: [{ dir, state, reason }],         # stage < recheck or gate failed
  total: number,
  ready_count: number
}
```

A paper is ready for panel review when:
1. Current stage is `recheck` or beyond (stage index >= 4)
2. Latest round scores meet thresholds (avg >= 2.5/4, min >= 2/4)
3. At least one complete synthesis exists

Papers at `ready`, `submit`, or `accepted` are included but flagged as already panel-reviewed if `REVIEW_PANEL.md` references them.

## Panel Selection

### select_cross_portfolio_panel(papers, reviewer_db, existing_panel)

```
Input:
  papers:          array of ready paper objects
  reviewer_db:     path to REVIEWER-DATABASE.md
  existing_panel:  optional existing panel for continuity (re-review rounds)
Output: array of 7 { name, affiliation, expertise, rationale, papers_covered }
```

Selection criteria for 7-member cross-portfolio panel:
1. **Breadth**: At least 1 reviewer familiar with each paper's domain
2. **Continuity**: Prefer reviewers who served on 2+ individual paper panels
3. **Diversity**: At least 2 categories represented, at least 1 industry + 1 academic
4. **Fresh eyes**: At least 2 reviewers who did NOT review any individual paper
5. **Methodology**: At least 1 reviewer with evaluation/methodology expertise

If `existing_panel` provided (re-review round), retain core members (5 of 7) and rotate 2 for fresh perspective.

## Revision Item Generation

### generate_panel_revision_items(themes, papers)

```
Input:
  themes:   array of cross-paper themes from panel synthesis
  papers:   array of paper objects with their individual reviews
Output: {
  per_paper: {
    "paper-name": [
      { id: "PP1.1", priority: "PP1", title, description, papers_affected, source_theme }
    ]
  },
  module_level: [
    { id: "PP1.M1", priority: "PP1", title, description, all_papers: true }
  ]
}
```

Priority classification for panel-level items:

| Priority | Label | Criteria |
|----------|-------|----------|
| **PP1** | High Impact | Cross-paper pattern threatening module quality OR affects 3+ papers |
| **PP2** | Important | Affects 2+ papers OR substantive module-level improvement |
| **PP3** | Nice-to-have | Affects 1 paper, surfaced by panel perspective |

PP items are distinct from individual paper P1/P2/P3 items — they represent cross-portfolio concerns that individual reviews may miss.

## Revision Progress Tracking

### check_panel_revision_progress(paper_dir)

```
Input:  path to paper directory
Output: {
  pp1: { total, addressed, items: [{ id, title, addressed, notes }] },
  pp2: { total, addressed, items: [...] },
  pp3: { total, addressed, items: [...] },
  all_pp1_addressed: bool
}
```

Reads PP items from the latest `PANEL-REVISION-PLAN.md` in the paper directory. Items are marked addressed when:
- The paper's content has been updated to reflect the change
- A subsequent `panel:review` round confirms the fix
- Checked off in the revision plan (checkbox `[x]`)

## Bubble-Up Logic

### bubble_up_findings(paper_reviews)

```
Input:  array of {
  paper: string,
  p1_items: [{ title, description, raised_by }],
  p2_items: [...],
  scores: { avg, min, distribution },
  themes: [string]
}
Output: {
  module_themes: [
    {
      theme: string,
      papers_affected: [string],
      severity: "PP1"|"PP2"|"PP3",
      evidence: [{ paper, item_id, description }]
    }
  ],
  module_strengths: [{ theme, papers: [string] }],
  module_weaknesses: [{ theme, papers: [string] }]
}
```

Aggregation rules:
1. A P1 issue appearing in 3+ papers → PP1 module theme
2. A P1 issue in 2 papers → PP2 module theme
3. A P2 issue appearing in 3+ papers → PP2 module theme
4. Common strengths across 3+ papers → module strength
5. Score patterns (e.g., all papers weak on evaluation) → module theme

## Panel Round Management

### snapshot_panel_round(module_dir, round_num)

```
Input:  module directory path, round number
Output: creates panel-reviews/round-{N}/ with snapshot files
```

1. Create `panel-reviews/round-{round_num}/` directory
2. Copy canonical `REVIEW_PANEL.md` → round directory
3. Copy `PANEL-REVISION-PLAN.md` if it exists → round directory
4. Return list of files archived

### get_panel_round(module_dir)

```
Input:  module directory path
Output: { current_round: number, rounds: [{ num, date, file_count }] }
```

Determines current round by scanning `panel-reviews/round-*/` directories. If none exist, current round is 0 (no panel review yet).

## Panel Document Structure

### REVIEW_PANEL.md Structure

```markdown
# Cross-Portfolio Panel Review — [Module Name]

## Panel Round {N} — {Date}

## Panel Composition
| # | Reviewer | Affiliation | Expertise | Papers Covered |
|---|----------|-------------|-----------|----------------|

## Module Overview
- Papers reviewed: N
- Average module score: X.X/10
- Module tier: [A/A-/B+/B/B-/C]
- Panel consensus: [Strong/Moderate/Weak]

## Paper Rankings
| Rank | Paper | Score | Tier | Trajectory |
|------|-------|-------|------|------------|

## Cross-Paper Themes

### Theme 1: [Title]
- Affected papers: [list]
- Severity: PP1/PP2/PP3
- Description: ...
- Recommended action: ...

## Module Strengths
[What the module does well across papers]

## Module Weaknesses
[Systemic issues across the portfolio]

## Per-Paper Assessments

### [Paper Name]
- Score: X.X/10
- Tier: [tier]
- Key strengths: ...
- Key concerns: ...
- PP items: PP1.1, PP2.3

## Panel Verdict
[Overall module readiness assessment]
```

### PANEL-REVISION-PLAN.md Structure

```markdown
# Panel Revision Plan — [Module Name] — Round {N}

## PP1: High Impact (address before next round)
- [ ] PP1.1: [Title] — affects: [papers] — [description]
- [ ] PP1.2: ...

## PP2: Important (should address)
- [ ] PP2.1: [Title] — affects: [papers] — [description]

## PP3: Nice-to-have
- [ ] PP3.1: [Title] — affects: [papers] — [description]

## Per-Paper Action Items

### [Paper Name]
- [ ] PP1.1: [specific action for this paper]
- [ ] PP2.3: [specific action for this paper]
```

## Dependencies

- shared/state-loader.md — discover_papers(), load_state()
- shared/reviewer-selector.md — filter_reviewers(), select_panel()
- shared/synthesis-engine.md — consolidation patterns
- shared/score-utils.md — score aggregation, tier mapping
- shared/display-utils.md — terminal formatting
- config/scoring.yaml — 10-point scale tier definitions
