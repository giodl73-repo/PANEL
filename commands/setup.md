---
name: panel:setup
description: Initialize panel in a project — create directory structure, copy reviewer database
user-invocable: true
---

# panel:setup — Initialize Panel (Project or Paper)

Two-level setup: project-level scaffolding or per-paper initialization.

## Invocation Modes

### Level 1 — Project Setup (no arguments)

```
panel:setup
panel:setup --project <path>
```

### Level 2 — Per-Paper Setup

```
panel:setup <paper-name> [venue]
panel:setup panel-cross-venue-analysis "ACL 2026"
panel:setup panel-new-paper                          # prompts for venue
```

## Arguments

### Project-level
- `--project <path>` — Target project directory (default: cwd)
- `--papers <dir>` — Paper directories location (default: auto-detect)
- `--reviewer-db <path>` — Custom reviewer database path
- `--check` — Validate existing setup without creating anything

### Per-paper
- `<paper-name>` — Paper directory name (auto-prefixed with `panel-` if missing)
- `[venue]` — Target venue (e.g., "CHI 2026", "NeurIPS D&B"); prompts via AskUserQuestion if omitted

---

## Level 1 — Project Setup Behavior

Runs when invoked with no positional arguments.

1. **Detect project structure**: Look for existing paper directories (containing `main.tex`).
2. **Create panel infrastructure**:
   - Copy REVIEWER-DATABASE.md to project root (if not present)
   - Create `RESEARCH_GUIDE.md` reference (if not present)
   - Create `REVISION-PROMPT-TEMPLATE.md` reference (if not present)
3. **Initialize per-paper state**: For each detected paper directory without `_panel.yaml`:
   - Create `_panel.yaml` with stage: draft
   - Create `reviews/` directory
4. **Create module files** (if not present):
   - `RESEARCH.md` — Paper inventory template
   - `REVIEWERS.md` — Module reviewer subset template
   - `REVIEW_PANEL.md` — Placeholder for cross-portfolio panel
5. **Report**: Show what was created and next steps.

### Project Setup Output

```
Panel Setup — C:\src\panel\research
═══════════════════════════════════════════════════════════════════════

Detected 5 paper directories:
  ✓ panel-review-methodology/     → _panel.yaml created (stage: draft)
  ✓ panel-reviewer-calibration/   → _panel.yaml created (stage: draft)
  ✓ panel-revision-dynamics/      → _panel.yaml created (stage: draft)
  ✓ panel-portfolio-assessment/   → _panel.yaml created (stage: draft)
  ✓ panel-synthesis-methods/      → _panel.yaml created (stage: draft)

Created:
  ✓ REVIEWER-DATABASE.md (copied from plugin)
  ✓ RESEARCH.md (paper inventory template)
  ✓ REVIEWERS.md (module reviewer subset)
  ✓ REVIEW_PANEL.md (placeholder)

Next steps:
  1. Set venue for each paper:  Edit _panel.yaml in each paper directory
  2. Run reviews:               panel:go --paper <name>
  3. Check status:              panel:status
```

---

## Level 2 — Per-Paper Setup Behavior

Runs when a `<paper-name>` positional argument is provided.

1. **Normalize name**: If name doesn't start with `panel-`, prepend it.
   - `cross-venue-analysis` → `panel-cross-venue-analysis`
   - `panel-cross-venue-analysis` → unchanged
2. **Check for duplicates**: If `research/<paper-name>/` already exists, warn and abort (use `panel:go` to advance existing papers).
3. **Prompt for venue** (if not provided): Use AskUserQuestion with common venue options:
   - CHI / CSCW (HCI)
   - NeurIPS / ICML (ML)
   - EMNLP / ACL (NLP)
   - AAAI / IJCAI (AI)
   - Other (free text)
4. **Create paper directory structure**:
   ```
   research/<paper-name>/
   ├── main.tex              # Starter template (title, author, venue header)
   ├── sections/
   │   ├── introduction.tex
   │   ├── related-work.tex
   │   ├── methodology.tex
   │   ├── results.tex
   │   └── discussion.tex
   ├── reviews/              # Empty, ready for panel:go
   ├── Makefile              # Paper-level build (pdf target)
   └── _panel.yaml           # Initialized state
   ```
5. **Initialize `_panel.yaml`**:
   ```yaml
   paper: <paper-name>
   title: ""                  # Author fills in
   venue: "<venue>"
   stage: draft
   round: 0
   reviewers: []
   reviews: {}
   p1_items: []
   history:
     - stage: draft
       date: <today>
       note: "Paper initialized via panel:setup"
   ```
6. **Update RESEARCH.md**: Append the new paper to the Paper Inventory table with next sequential number, directory link, empty title, PDF link, and venue target.
7. **Report**: Show what was created and immediate next steps.

### Per-Paper Setup Output

```
Panel Setup — panel-cross-venue-analysis
═══════════════════════════════════════════════════════════════════════

Created paper #6:
  Directory:  research/panel-cross-venue-analysis/
  Venue:      ACL 2026
  Stage:      draft

  ✓ main.tex (starter template)
  ✓ sections/ (5 section files)
  ✓ reviews/ (empty)
  ✓ Makefile
  ✓ _panel.yaml (stage: draft, venue: ACL 2026)
  ✓ RESEARCH.md updated (paper #6 added)

Next steps:
  1. Write your paper:    Edit main.tex and sections/*.tex
  2. Set the title:       Edit _panel.yaml → title field
  3. Start reviews:       panel:go --paper panel-cross-venue-analysis
```

---

## Check Mode

```
panel:setup --check
```

Validates existing setup without creating anything:
- Directories exist (research papers, reviews/)
- REVIEWER-DATABASE.md present
- All papers have `_panel.yaml`
- Lists all papers with stage, venue, and readiness status

### Check Output

```
Panel Setup Check — C:\src\panel\research
═══════════════════════════════════════════════════════════════════════

Infrastructure:
  ✓ REVIEWER-DATABASE.md        (45 reviewers, 10 categories)
  ✓ RESEARCH.md                 (5 papers listed)
  ✓ REVIEWERS.md                present
  ✓ REVIEW_PANEL.md             present

Papers:
  ✓ panel-review-methodology     _panel.yaml ✓  venue: CHI 2026      stage: draft
  ✓ panel-reviewer-calibration   _panel.yaml ✓  venue: EMNLP 2026    stage: draft
  ✓ panel-revision-dynamics      _panel.yaml ✓  venue: NeurIPS D&B   stage: draft
  ✓ panel-portfolio-assessment   _panel.yaml ✓  venue: JCDL 2026     stage: draft
  ✓ panel-synthesis-methods      _panel.yaml ✓  venue: AAAI 2026     stage: draft

All 5 papers ready. Run panel:go --paper <name> to begin reviews.
```

## Dependencies

- shared/state-loader.md — Create/validate _panel.yaml files
- shared/display-utils.md — Terminal formatting
