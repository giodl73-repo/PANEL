# Display Utils — Terminal Formatting

Shared utility for consistent terminal output formatting across all panel commands.

## Conventions

- Header lines use `═` (double-line box drawing)
- Column separators use `──` (single-line box drawing)
- Scores use `█` (filled) and `░` (empty) for bar charts
- Status indicators: `✓` (complete), `→` (in progress), `○` (pending), `✗` (failed)

## Components

### header(title)
```
Panel Status — [Project Name]
═══════════════════════════════════════════════════════════════════════
```

### table(columns, rows)
```
 #  Paper                        Stage      Round  Score
 ── ──────────────────────────── ────────── ───── ───────
 1  panel-review-methodology     synthesis  1     2.2/4
 2  panel-reviewer-calibration   draft      0     —
```

Auto-sizes columns to content width. Right-aligns numeric columns.

### score_bar(score, max_score)
```
2.6/4  ████████████░░░░
3.2/4  ████████████████
1.8/4  ███████░░░░░░░░░
```

### stage_badge(stage)
```
draft       → [DRAFT]
panel       → [PANEL]
synthesis   → [SYNTH]
revision    → [REVISE]
recheck     → [CHECK]
ready       → [READY]
submit      → [SUBMIT]
accepted    → [DONE]
```

### progress(current, total, label)
```
Reviews: ███████████░░░░░ 3/5
P1 Items: ████████████████ 4/4 ✓
```

### summary(stats)
```
Summary: 5 papers | 1 ready | 2 in review | 1 revising | 1 drafting
```

## Color Scheme

When terminal supports color:
- Stage badges: blue
- Scores ≥ 2.5: green
- Scores < 2.5: yellow
- Scores < 2.0: red
- Headers: bold
- Secondary text: dim/gray
