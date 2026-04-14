# Level 2 — Per-Paper Setup

Runs when a `<paper-name>` positional argument is provided.

```javascript
// @import ../shared/project-config.md

const projectConfig = loadProjectConfig();
const researchDir = path.join(process.cwd(), projectConfig.researchPath);
```

## Step 1: Normalize name

If name doesn't start with `panel-`, prepend it.
- `cross-venue-analysis` → `panel-cross-venue-analysis`
- `panel-cross-venue-analysis` → unchanged

## Step 2: Check for duplicates

If `${researchDir}/<paper-name>/` already exists, warn and abort (use `panel:review` to advance existing papers).

## Step 3: Prompt for venue

If venue not provided, use AskUserQuestion with common venue options:
- CHI / CSCW (HCI)
- NeurIPS / ICML (ML)
- EMNLP / ACL (NLP)
- AAAI / IJCAI (AI)
- ICSE / FSE (Software Engineering)
- PLDI / OOPSLA (PL)
- Other (free text)

## Step 4: Create paper directory structure

```
${researchDir}/<paper-name>/
├── main.tex              # Starter template (title, author, venue header)
├── sections/
│   ├── 01-introduction.tex
│   ├── 02-related-work.tex
│   ├── 03-methodology.tex
│   ├── 04-evaluation.tex
│   ├── 05-discussion.tex
│   └── 06-conclusion.tex
├── reviews/              # Empty, ready for panel:review
├── Makefile              # Paper-level build (pdf target)
├── REVISION-PLAN.md      # Empty revision plan (from template)
└── _panel.yaml           # Initialized state
```

**IMPORTANT**: Always create `REVISION-PLAN.md` from `${CLAUDE_PLUGIN_ROOT}/templates/revision-plan-template.md`. This ensures every paper has a revision plan file from the start, which gets populated during the revision stage.

## Step 5: Initialize `_panel.yaml`

```yaml
paper: <paper-name>
title: ""                  # Author fills in
venue: "<venue>"
stage: draft
round: 0
content_mode: <mode>       # If --mode specified; omit otherwise (auto-detected on first review)
content_mode_confirmed: true  # If --mode explicitly provided
reviewers: []
reviews: {}
p1_items: []
history:
  - stage: draft
    date: <today>
    note: "Paper initialized via panel:setup"
```

**Content mode handling**:
- If `--mode abstract|draft|full` provided, set `content_mode` and `content_mode_confirmed: true`
- If `--mode` omitted, skip `content_mode` field entirely — will be auto-detected during first `panel:review`
- Mode affects review expectations and maximum stage advancement (see commands/review.md)

## Step 6: Update RESEARCH.md

Append the new paper to the Paper Inventory table with next sequential number, directory link, empty title, PDF link, and venue target.

## Step 7: Report

```
Panel Setup — panel-cross-venue-analysis
═══════════════════════════════════════════════════════════════════════

Created paper #6:
  Directory:  research/panel-cross-venue-analysis/
  Venue:      ACL 2026
  Stage:      draft

  ✓ main.tex (starter template)
  ✓ sections/ (6 section files)
  ✓ reviews/ (empty)
  ✓ Makefile
  ✓ REVISION-PLAN.md (template — populated during revision stage)
  ✓ _panel.yaml (stage: draft, venue: ACL 2026)
  ✓ RESEARCH.md updated (paper #6 added)

Next steps:
  1. Create plan.md:      Add plan.md to paper directory with research plan
  2. Write your paper:    panel:author --paper panel-cross-venue-analysis
     OR manually edit:    main.tex and sections/*.tex
  3. Set the title:       Edit _panel.yaml → title field
  4. Start reviews:       panel:review --paper panel-cross-venue-analysis
```
