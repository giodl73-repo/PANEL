# Level 2 — Per-Paper Setup

Runs when a `<paper-name>` positional argument is provided.

```javascript
// @import ../shared/project-config.md

const projectConfig = loadProjectConfig();
const researchDir = path.join(process.cwd(), projectConfig.researchPath);
const moduleName = projectConfig.projectName;  // e.g. "panel"
```

## Step 1: Normalize name

Directory slugs are **bare** — never prefix with the module name. If the user
supplies a name starting with the module prefix, strip it.
- `cross-venue-analysis` → unchanged
- `panel-cross-venue-analysis` → `cross-venue-analysis` (strip `${moduleName}-`)

The module name lives in the parent directory (`research/publications/…`), and
is prepended to the *generated PDF* filename (`docs/${moduleName}-<slug>.pdf`),
not to the directory name.

## Step 2: Check for duplicates

Publications live at `${researchDir}/publications/<slug>/`; quick markdown papers
at `${researchDir}/papers/<slug>/`. If the target path already exists, warn and
abort (use `panel:review` to advance existing papers).

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

For LaTeX publications (default):

```
${researchDir}/publications/<slug>/
├── main.tex              # Starter template (title, author, venue header)
├── sections/
│   ├── 01-introduction.tex
│   ├── 02-related-work.tex
│   ├── 03-methodology.tex
│   ├── 04-evaluation.tex
│   ├── 05-discussion.tex
│   └── 06-conclusion.tex
├── reviews/              # Empty, ready for panel:review
├── Makefile              # Paper-level build (substitutes {{MODULE}} in template)
├── REVISION-PLAN.md      # Empty revision plan (from template)
└── _panel.yaml           # Initialized state
```

Makefile substitution: read `templates/makefile-publication.mk`, replace
`{{MODULE}}` with `${moduleName}`, write to `<slug>/Makefile`. The resulting
`dist` target emits `${researchDir}/docs/${moduleName}-<slug>.pdf`.

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
- Mode affects review expectations and maximum stage advancement (see shared/review-standards.md)

## Step 6: Update RESEARCH.md

Append the new paper to the Paper Inventory table with next sequential number, directory link, empty title, PDF link, and venue target.

## Step 7: Report

```
Panel Setup — cross-venue-analysis
═══════════════════════════════════════════════════════════════════════

Created publication #6:
  Directory:  research/publications/cross-venue-analysis/
  PDF target: research/docs/panel-cross-venue-analysis.pdf
  Venue:      ACL 2026
  Stage:      draft

  ✓ main.tex (starter template)
  ✓ sections/ (6 section files)
  ✓ reviews/ (empty)
  ✓ Makefile (MODULE := panel)
  ✓ REVISION-PLAN.md (template — populated during revision stage)
  ✓ _panel.yaml (stage: draft, venue: ACL 2026)
  ✓ RESEARCH.md updated (paper #6 added)

Next steps:
  1. Create plan.md:      Add plan.md to paper directory with research plan
  2. Write your paper:    panel:author --paper cross-venue-analysis
     OR manually edit:    main.tex and sections/*.tex
  3. Set the title:       Edit _panel.yaml → title field
  4. Start reviews:       panel:review --paper cross-venue-analysis
```
