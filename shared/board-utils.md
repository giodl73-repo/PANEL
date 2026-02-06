# Board Utils — Monorepo-Level Board Review Utilities

Shared utility for managing monorepo-level board reviews across modules, including module discovery, board state, B1/B2/B3 generation, and round tracking.

## Module Discovery

### discover_modules(repo_path)

```
Input:  path to monorepo root
Output: array of {
  name: string,              # directory name (e.g., "merit", "waves", "panel")
  path: string,              # full path to module in monorepo
  source_repo: string|null,  # external source repo path, if synced (e.g., "C:\src\boost")
  has_research: bool,        # contains research/ subdirectory
  paper_count: number,       # number of paper directories
  panel_status: "completed"|"placeholder"|"missing",
  panel_path: string|null    # path to REVIEW_PANEL.md if exists
}
```

Scans `repo_path` for directories containing:
- A `RESEARCH.md` file (primary signal)
- Paper subdirectories (dirs with `main.tex` or `_panel.yaml`)
- A `REVIEW_PANEL.md` file (panel review output)

Excludes: `.git`, `node_modules`, `.claude`, `docs`, `scripts`, hidden directories.

**Synced modules**: Some modules are authored in external source repos (e.g., boost at `C:\src\boost\research/`, waves at `C:\src\waves\research/`) and synced to the monorepo. The board always reads from the monorepo copy — the `source_repo` field is informational only, used for status messages (e.g., "boost: last synced 2h ago, source may be ahead").

### detect_panel_status(module_path)

```
Input:  path to module directory
Output: "completed"|"placeholder"|"missing"
```

- **completed**: `REVIEW_PANEL.md` exists AND contains substantive content (>100 lines, has Panel Composition and Paper Rankings sections)
- **placeholder**: `REVIEW_PANEL.md` exists but is a stub (<100 lines or lacks required sections)
- **missing**: No `REVIEW_PANEL.md` file

## Repo Path Resolution

### resolve_repo(cwd)

```
Input:  current working directory
Output: { path: string, method: string } | { error: string, guidance: string }
```

Resolution order:
1. Walk up from `cwd` looking for a directory containing `REVIEW_BOARD.md`
2. Walk up from `cwd` looking for a directory containing 2+ subdirectories with `RESEARCH.md`
3. Check common sibling patterns: if `cwd` is `/src/panel`, check `/src/` for monorepo root
4. Fail with guidance: "Could not find monorepo root. Use --repo <path> to specify explicitly."

Returns `method` for transparency: `"board_file"`, `"research_dirs"`, `"sibling_scan"`.

## Board State

### parse_board_state(board_review_path)

```
Input:  path to REVIEW_BOARD.md
Output: {
  round: number,
  date: string,
  board_members: [{ name, affiliation, expertise, modules_covered }],
  module_registry: [{ name, paper_count, panel_status, score, tier }],
  rankings: [{ module, score, tier, trajectory }],
  themes: [{ title, severity, modules_affected, description }],
  b_items: {
    b1: [{ id, title, modules, description, addressed }],
    b2: [...],
    b3: [...]
  },
  program_score: float,
  verdict: string
}
```

### parse_review_panel(panel_path)

```
Input:  path to module's REVIEW_PANEL.md
Output: {
  module: string,
  round: number,
  panel_members: [{ name, affiliation, expertise }],
  paper_rankings: [{ paper, score, tier }],
  themes: [{ title, severity, papers_affected }],
  pp_items: { pp1: [...], pp2: [...], pp3: [...] },
  module_score: float,
  module_tier: string,
  strengths: [string],
  weaknesses: [string]
}
```

## Board Selection

### select_board(modules, reviewer_db, existing_board)

```
Input:
  modules:         array of discovered module objects
  reviewer_db:     path to REVIEWER-DATABASE.md
  existing_board:  optional existing board for continuity
Output: array of 7 {
  name: string,
  affiliation: string,
  expertise: string,
  rationale: string,
  modules_covered: [string]
}
```

Selection criteria for 7-member board:
1. **Cross-module breadth**: At least 1 member familiar with each module's domain
2. **Seniority**: Prefer senior researchers / program chairs for board-level review
3. **Continuity**: If re-review, retain 5 of 7 core members
4. **Panel overlap**: At least 2 board members should have served on module panels
5. **Fresh perspective**: At least 2 members who are NOT on any module panel
6. **Methodology**: At least 1 member with meta-research / program evaluation expertise

## Revision Plan Generation

### generate_board_revision_plan(themes, priorities, module)

```
Input:
  themes:     array of cross-module themes
  priorities: aggregated priority items
  module:     target module name
Output: {
  items: [
    { id: "B1.1", priority: "B1", title, description, modules_affected, action }
  ]
}
```

Priority classification for board-level items:

| Priority | Label | Criteria |
|----------|-------|----------|
| **B1** | Blocking | 3+ board members flag it OR threatens program coherence OR affects 3+ modules |
| **B2** | Important | 2+ board members flag it OR affects 2+ modules |
| **B3** | Nice-to-have | 1 board member flags it OR affects 1 module |

### check_board_revision_progress(module_path)

```
Input:  path to module directory
Output: {
  b1: { total, addressed, items: [{ id, title, addressed, notes }] },
  b2: { total, addressed, items: [...] },
  b3: { total, addressed, items: [...] },
  all_b1_addressed: bool
}
```

Reads from `BOARD-REVISION-PLAN-{module}.md` in the repo root's `board-reviews/` latest round.

## Ranking and Consensus

### merge_rankings(existing_rankings, new_scores)

```
Input:
  existing_rankings:  previous round's module rankings
  new_scores:         current round's module scores
Output: [
  { module, prev_score, new_score, delta, tier, prev_tier, trajectory }
]
```

Trajectory classification:
- **improving**: delta > +0.3
- **stable**: |delta| <= 0.3
- **declining**: delta < -0.3

### compute_agreement_matrix(rankings)

```
Input:  {
  board_member_1: [{ module, score }],
  board_member_2: [{ module, score }],
  ...
}
Output: {
  matrix: { [member_pair]: spearman_rho },
  avg_agreement: float,
  consensus: "strong"|"moderate"|"weak"|"none",
  outliers: [{ member, deviation }]
}
```

Pairwise Spearman's rank correlation:
- Strong consensus: avg rho > 0.8
- Moderate consensus: avg rho > 0.6
- Weak consensus: avg rho > 0.4
- No consensus: avg rho <= 0.4

## Round Management

### snapshot_round(source_dir, round_dir, modules)

```
Input:  source directory (repo root), round directory path, discovered modules
Output: creates round directory with snapshot files, returns file list
```

1. Create `board-reviews/round-{N}/` directory
2. Copy canonical `REVIEW_BOARD.md` → round directory
3. Copy all `BOARD-REVISION-PLAN-*.md` files → round directory
4. **For each module with panel_status == "completed"**:
   a. Create `round-{N}/{module}/` subdirectory
   b. Copy `{module}/REVIEW_PANEL.md` → `round-{N}/{module}/`
   c. Copy `{module}/RESEARCH.md` → `round-{N}/{module}/`
5. Write `round-{N}/MANIFEST.md` listing all archived files, modules, date, program score
6. Return list of files archived

**Why archive module state**: REVIEW_PANEL.md and RESEARCH.md evolve between board rounds as papers complete revisions, new reviews come in, and scores change. Without per-round snapshots of module state, the board cannot compare what changed between rounds. The MANIFEST.md provides a quick index.

### get_board_round(repo_path)

```
Input:  repo root path
Output: { current_round: number, rounds: [{ num, date, file_count }] }
```

Determines current round by scanning `board-reviews/round-*/` directories.

## Board Document Structure

### REVIEW_BOARD.md Structure

```markdown
# Research Program Board Review — Round {N}

## Board Review — {Date}

## Board Composition
| # | Member | Affiliation | Expertise | Modules Covered |
|---|--------|-------------|-----------|-----------------|

## Module Registry
| # | Module | Papers | Panel Status | Score | Tier |
|---|--------|--------|--------------|-------|------|

## Program Overview
- Modules reviewed: N
- Total papers: N
- Program score: X.X/10
- Program tier: [tier]
- Board consensus: [Strong/Moderate/Weak] (avg ρ = X.XX)

## Module Rankings
| Rank | Module | Score | Tier | Trajectory | Key Strength | Key Concern |
|------|--------|-------|------|------------|-------------|-------------|

## Cross-Module Themes

### Theme 1: [Title]
- Severity: B1/B2/B3
- Modules affected: [list]
- Description: ...
- Recommended action: ...

## Program Strengths
[What the research program does well across modules]

## Program Weaknesses
[Systemic issues across the program]

## Per-Module Assessments

### [Module Name]
- Papers: N
- Panel score: X.X/10
- Panel tier: [tier]
- Key findings: ...
- Board concerns: ...
- B items: B1.1, B2.3

## Agreement Matrix
| | Member A | Member B | ... |
|---|----------|----------|-----|
| Member A | — | 0.85 | ... |

## Board Verdict
[Overall program readiness and strategic direction]
```

### BOARD-REVISION-PLAN-{module}.md Structure

```markdown
# Board Revision Plan — [Module Name] — Round {N}

## B1: Blocking (must address)
- [ ] B1.1: [Title] — [description]
- [ ] B1.2: ...

## B2: Important (should address)
- [ ] B2.1: [Title] — [description]

## B3: Nice-to-have
- [ ] B3.1: [Title] — [description]

## Action Items
- [ ] [Specific action with responsible party and deadline]
```

## Dependencies

- shared/state-loader.md — discover_papers()
- shared/panel-utils.md — assess_paper_readiness(), parse panel data
- shared/reviewer-selector.md — filter_reviewers()
- shared/score-utils.md — score aggregation, tier mapping
- shared/display-utils.md — terminal formatting
- config/scoring.yaml — 10-point scale tier definitions
