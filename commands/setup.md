---
name: panel:setup
description: Initialize panel in a project — create directory structure, copy reviewer database
user-invocable: true
---

# panel:setup — Initialize Panel (Project or Paper)

Two-level setup: project-level scaffolding or per-paper initialization.

## Plugin Path Resolution

All template files are bundled in the plugin's `templates/` directory. Resolve via:

```
${CLAUDE_PLUGIN_ROOT}/templates/
├── REVIEWER-DATABASE.md         # Expert reviewer database (45+ reviewers)
├── RESEARCH.md                  # Paper inventory template
├── REVIEWERS.md                 # Module reviewer subset template
├── REVIEW_PANEL.md              # Cross-portfolio panel placeholder
├── review-template.md           # Individual review structure
├── synthesis-template.md        # Synthesis document structure
└── revision-plan-template.md    # Revision plan structure
```

**CRITICAL**: Use `CLAUDE_PLUGIN_ROOT` environment variable to locate plugin files. Never hardcode paths or search for the plugin directory.

```javascript
const pluginDir = process.env.CLAUDE_PLUGIN_ROOT;
const templatesDir = `${pluginDir}/templates`;
```

## Target Directory Resolution

Setup targets `{cwd}/research/` by default — NOT cwd itself. Every module keeps papers in a `research/` subdirectory.

Resolution order:
1. `--project <path>/research/` if `--project` specified
2. `{cwd}/research/` (default)
3. If `research/` doesn't exist: create it, plus `research/docs/` for PDFs

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
- `--project <path>` — Target project directory (default: cwd; research/ is auto-appended)
- `--check` — Validate existing setup without creating anything

### Per-paper
- `<paper-name>` — Paper directory name (auto-prefixed with `panel-` if missing)
- `[venue]` — Target venue (e.g., "CHI 2026", "NeurIPS D&B"); prompts via AskUserQuestion if omitted

---

## Level 1 — Project Setup Behavior

Runs when invoked with no positional arguments.

### Step 1: Interactive Topic Discovery

Before creating anything, understand the research context. Use AskUserQuestion:

**Question 1: Research area**
```
What is the research topic or area for this module?
Options:
  - AI Systems & Infrastructure
  - Human-AI Interaction
  - NLP & Language Models
  - ML Methods & Theory
  (Other — free text)
```

**Question 2: Discovery source** (if waves exist in cwd)
```
Should I scan existing waves to suggest paper topics and reviewers?
Options:
  - Yes, scan waves for topics (Recommended)
  - No, I'll specify papers manually
```

If waves scanning is selected:
- Read `{cwd}/.waves/wave-index.yaml` or `{cwd}/context/waves/` to find completed waves
- Extract themes and domains from wave titles and pulse descriptions
- Use themes to pre-select reviewer categories from REVIEWER-DATABASE.md
- Report discovered themes as suggested starting points

If no waves exist, skip scanning and proceed with manual setup.

### Step 2: Create research directory

```bash
mkdir -p "${targetDir}"
mkdir -p "${targetDir}/docs"
```

### Step 3: Copy infrastructure files from plugin

```bash
# Copy from plugin templates to research directory
cp "${CLAUDE_PLUGIN_ROOT}/templates/REVIEWER-DATABASE.md" "${targetDir}/REVIEWER-DATABASE.md"
cp "${CLAUDE_PLUGIN_ROOT}/templates/RESEARCH.md" "${targetDir}/RESEARCH.md"
cp "${CLAUDE_PLUGIN_ROOT}/templates/REVIEWERS.md" "${targetDir}/REVIEWERS.md"
cp "${CLAUDE_PLUGIN_ROOT}/templates/REVIEW_PANEL.md" "${targetDir}/REVIEW_PANEL.md"
```

After copying, fill in template placeholders:
- `{MODULE}` → module name (directory name, e.g., "boost", "panel")
- `{MODULE_DESCRIPTION}` → from topic discovery or project CLAUDE.md
- `{AUTHOR}` → from git config or default "Author"
- `{DATE}` → current month/year

Skip files that already exist (don't overwrite).

### Step 4: Create Makefile

If `research/Makefile` doesn't exist, create a master Makefile:

```makefile
PAPERS = $(wildcard panel-*/)
DIST_DIR = docs

.PHONY: all clean dist

all:
	@for dir in $(PAPERS); do \
		$(MAKE) -C $$dir pdf; \
	done

dist: all
	@mkdir -p $(DIST_DIR)
	@for dir in $(PAPERS); do \
		name=$$(basename $$dir); \
		cp $$dir/main.pdf $(DIST_DIR)/$$name.pdf 2>/dev/null || true; \
	done
	@echo "PDFs copied to $(DIST_DIR)/"

clean:
	@for dir in $(PAPERS); do \
		$(MAKE) -C $$dir clean; \
	done
```

### Step 5: Initialize existing papers

For each detected paper directory (containing `main.tex`) without `_panel.yaml`:
- Create `_panel.yaml` with stage: draft
- Create `reviews/` directory
- Create empty `REVISION-PLAN.md` from template

### Step 6: Report

```
Panel Setup — boost
═══════════════════════════════════════════════════════════════════════

Research area: AI Systems & Infrastructure
Target directory: C:\src\boost\research\

Discovered from waves:
  - Static analysis for command files (3 waves)
  - Command DSL compilation (2 waves)
  → Suggested reviewer categories: Compilers & PL Theory, Software Engineering

Infrastructure:
  ✓ REVIEWER-DATABASE.md  (copied from plugin — 45+ reviewers, 10 categories)
  ✓ RESEARCH.md           (paper inventory template)
  ✓ REVIEWERS.md          (module reviewer subset)
  ✓ REVIEW_PANEL.md       (placeholder)
  ✓ Makefile              (master build)

Papers: 0 detected

Next steps:
  1. Add a paper:    panel:setup <paper-name> [venue]
  2. Or import:      panel:import --from waves
  3. Check status:   panel:status
```

---

## Level 2 — Per-Paper Setup Behavior

Runs when a `<paper-name>` positional argument is provided.

### Step 1: Normalize name

If name doesn't start with `panel-`, prepend it.
- `cross-venue-analysis` → `panel-cross-venue-analysis`
- `panel-cross-venue-analysis` → unchanged

### Step 2: Check for duplicates

If `research/<paper-name>/` already exists, warn and abort (use `panel:paper` to advance existing papers).

### Step 3: Prompt for venue

If venue not provided, use AskUserQuestion with common venue options:
- CHI / CSCW (HCI)
- NeurIPS / ICML (ML)
- EMNLP / ACL (NLP)
- AAAI / IJCAI (AI)
- ICSE / FSE (Software Engineering)
- PLDI / OOPSLA (PL)
- Other (free text)

### Step 4: Create paper directory structure

```
research/<paper-name>/
├── main.tex              # Starter template (title, author, venue header)
├── sections/
│   ├── 01-introduction.tex
│   ├── 02-related-work.tex
│   ├── 03-methodology.tex
│   ├── 04-evaluation.tex
│   ├── 05-discussion.tex
│   └── 06-conclusion.tex
├── reviews/              # Empty, ready for panel:paper
├── Makefile              # Paper-level build (pdf target)
├── REVISION-PLAN.md      # Empty revision plan (from template)
└── _panel.yaml           # Initialized state
```

**IMPORTANT**: Always create `REVISION-PLAN.md` from `${CLAUDE_PLUGIN_ROOT}/templates/revision-plan-template.md`. This ensures every paper has a revision plan file from the start, which gets populated during the revision stage.

### Step 5: Initialize `_panel.yaml`

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

### Step 6: Update RESEARCH.md

Append the new paper to the Paper Inventory table with next sequential number, directory link, empty title, PDF link, and venue target.

### Step 7: Report

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
  1. Write your paper:    Edit main.tex and sections/*.tex
  2. Set the title:       Edit _panel.yaml → title field
  3. Start reviews:       panel:paper --paper panel-cross-venue-analysis
```

---

## Check Mode

```
panel:setup --check
```

Validates existing setup without creating anything:
- Plugin accessible via `CLAUDE_PLUGIN_ROOT`
- `research/` directory exists
- REVIEWER-DATABASE.md present
- All papers have `_panel.yaml`
- All papers have `REVISION-PLAN.md`
- Lists all papers with stage, venue, and readiness status

### Check Output

```
Panel Setup Check — C:\src\boost\research
═══════════════════════════════════════════════════════════════════════

Plugin: ${CLAUDE_PLUGIN_ROOT} ✓

Infrastructure:
  ✓ REVIEWER-DATABASE.md        (45 reviewers, 10 categories)
  ✓ RESEARCH.md                 (2 papers listed)
  ✓ REVIEWERS.md                present
  ✓ REVIEW_PANEL.md             present
  ✓ Makefile                    present

Papers:
  ✓ panel-static-analysis       _panel.yaml ✓  venue: PLDI 2026     stage: draft
  ✓ panel-command-dsl            _panel.yaml ✓  venue: OOPSLA 2026   stage: draft

All 2 papers ready. Run panel:paper --paper <name> to begin reviews.
```

## Dependencies

- shared/state-loader.md — Create/validate _panel.yaml files
- shared/display-utils.md — Terminal formatting
- shared/topic-discovery.md — Waves scanning for topic discovery
- templates/REVIEWER-DATABASE.md — Bundled reviewer database
- templates/RESEARCH.md — Paper inventory template
- templates/REVIEWERS.md — Module reviewer subset template
- templates/REVIEW_PANEL.md — Cross-portfolio panel placeholder
- templates/revision-plan-template.md — Revision plan structure
