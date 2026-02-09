---
name: panel:setup
description: Initialize panel in a project — create directory structure, copy reviewer database
user-invocable: true
---

# panel:setup — Initialize Panel (Project or Paper)

Two-level setup: project-level scaffolding or per-paper initialization.

## Variable Conventions

**CRITICAL — Path Variables:**

```bash
targetDir = project root directory (e.g., "C:\src\panel")
           All research files go in ${targetDir}/research/

           WRONG: targetDir = "C:\src\panel\research"
           RIGHT: targetDir = "C:\src\panel"
                  Then use: ${targetDir}/research/RESEARCH.md
```

## Plugin Path Resolution

All template files are bundled in the plugin's `templates/` directory. Resolve via:

```
${CLAUDE_PLUGIN_ROOT}/templates/
├── REVIEWER-DATABASE.md         # Expert reviewer database (45+ reviewers)
├── RESEARCH.md                  # Paper inventory template
├── REVIEWERS.md                 # Module reviewer subset template
├── REVIEW_PANEL.md              # Cross-portfolio panel placeholder
├── references.bib               # Global bibliography catalog (1200+ entries)
├── review-template.md           # Individual review structure
├── synthesis-template.md        # Synthesis document structure
└── revision-plan-template.md    # Revision plan structure
```

**Use `CLAUDE_PLUGIN_ROOT` environment variable to locate plugin files.** Never hardcode paths or search for the plugin directory.

## Target Directory Resolution

**CRITICAL**: `targetDir` = project root directory (e.g., `C:\src\panel`). All research files go in `${targetDir}/research/`, NOT `${targetDir}` directly.

Resolution order:
1. `--project <path>` if specified → `targetDir = <path>`
2. Default → `targetDir = {cwd}`

All infrastructure files are placed in `${targetDir}/research/`, which is created if missing.

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

### Research Monorepo Connection

```
panel:setup --connect
panel:setup --connect <path>
```

## Arguments

### Project-level
- `--project <path>` — Target project directory (default: cwd; research/ is auto-appended)
- `--check` — Validate existing setup without creating anything
- `--scan` — Auto-discover papers with plan.md and setup (batch mode)
- `--discover` — Alias for --scan

### Research monorepo
- `--connect` — Connect research directory to a research monorepo (skips full setup)
- `--connect <path>` — Explicit monorepo path (default: ../research)

### Per-paper
- `<paper-name>` — Paper directory name (auto-prefixed with `panel-` if missing)
- `[venue]` — Target venue (e.g., "CHI 2026", "NeurIPS D&B"); prompts via AskUserQuestion if omitted
- `--mode <abstract|draft|full>` — Content mode (default: auto-detect during first review)

---

## Execution Flow

1. **Determine setup level**:
   - If `--scan` or `--discover` flag → Run batch discovery and setup
   - If `--connect` flag → Run research monorepo connection (Level 3)
   - If `--check` flag → Run validation only
   - If `<paper-name>` positional argument → Per-paper setup (Level 2)
   - If no positional arguments → Project-level setup or upgrade (Level 1)

2. **For Level 1 (project setup)**:
   - Check if `${targetDir}/research/` exists
   - If yes: **Auto-upgrade flow**
     - Detect current version via `shared/version-detector.md`
     - If v2.0: Already latest, show status
     - If < v2.0: Offer upgrade via AskUserQuestion
     - Execute migration via `shared/migrator.md`
   - If no: **Fresh setup flow**
     - Initialize with v2.0 (latest model)

3. **Execute the appropriate flow**

---

## Batch Scan Mode (--scan / --discover)

Runs when `--scan` or `--discover` flag is provided. Auto-discovers papers with plan.md and sets them up.

### Step 1: Discover Papers

```javascript
// @import ../shared/batch-utils.md

const researchDir = `${targetDir}/research`;
const needSetup = discoverPapersNeedingSetup(researchDir);
```

### Step 2: Show Discovery

```javascript
msg('Paper Discovery', 'header');
msg(`Found ${needSetup.length} paper${needSetup.length === 1 ? '' : 's'} with plan.md (not yet setup):`, 'info');

for (const paper of needSetup) {
    msg(`• ${paper.directory}`, 'item');
}
```

### Step 3: Ask User

```javascript
AskUserQuestion({
    question: `Setup all ${needSetup.length} paper${needSetup.length === 1 ? '' : 's'}?`,
    header: 'Batch Setup',
    options: [
        {
            label: 'Yes, setup all (Recommended)',
            description: 'Initialize all discovered papers with UUIDs'
        },
        {
            label: 'Select specific papers',
            description: 'Choose which papers to setup'
        },
        {
            label: 'Skip',
            description: "Don't setup any papers"
        }
    ]
});
```

### Step 4: Execute Setup

For each selected paper:

1. **Extract venue from plan.md** (if specified):
   ```javascript
   const planContent = await Read(paper.planPath);
   const venueMatch = planContent.match(/Venue:\s*([^\n]+)/i);
   const venue = venueMatch ? venueMatch[1].trim() : 'TBD';
   ```

2. **Generate UUID**:
   ```javascript
   const existingPapers = await loadPaperIndex(researchDir);
   const uuid = generateUniqueUUID(existingPapers.papers || []);
   ```

3. **Create _panel.yaml**:
   ```javascript
   const slug = paper.directory.replace(/^panel-/, '');

   const panelYaml = {
       uuid,
       slug,
       title: 'Untitled', // User can update later
       venue,
       stage: 'draft',
       content_mode: 'full', // Default, will be detected on first review
       created: new Date().toISOString().split('T')[0]
   };

   writeYAML(`${paper.fullPath}/_panel.yaml`, panelYaml);
   ```

4. **Create directory structure** (if missing):
   ```bash
   mkdir -p ${paper.fullPath}/sections
   mkdir -p ${paper.fullPath}/figures
   mkdir -p ${paper.fullPath}/reviews
   ```

### Step 5: Update RESEARCH.md

Add all new papers to RESEARCH.md in batch.

### Step 6: Report

```javascript
msg('Batch Setup Complete', 'success');
msg(`Initialized ${needSetup.length} papers with UUIDs`, 'info');

msgSep();
msg('Next steps:', 'info');
msg('1. Update titles in each _panel.yaml', 'item');
msg('2. Run: panel:author --all', 'item');
```

### Step 7: Auto-Commit

```javascript
await gitCommitIfEnabled(
    `[panel] Batch setup: ${needSetup.length} papers\n\nDiscovered and initialized from plan.md files.`,
    [researchDir]
);
```

---

## Level 0 — Auto-Upgrade Flow (Existing Installation)

Runs when `${targetDir}/research/` exists. Uses **auto-awesome** detection and upgrade.

### Step 1: Detect Version

```javascript
// @import ../shared/version-detector.md
// @import ../shared/migrator.md

const researchDir = `${targetDir}/research`;
const currentVersion = detectPanelVersion(researchDir);
```

### Step 2: Handle Based on Version

**If v2.0** (already latest):
```
✓ Panel is already at v2.0 (latest)

Run panel:setup <paper-name> to add a new paper.
```

**If < v2.0** (upgrade available):

Show current version and offer upgrade via AskUserQuestion:

```javascript
question: "Panel setup detected: upgrade to latest version (v2.0)?"
header: "Auto-Upgrade"
options: [
  {
    label: "Yes, upgrade to v2.0 (Recommended)",
    description: "Full upgrade: UUIDs + paper-index + numbered directories"
  },
  {
    label: "Partial upgrade to v1.3",
    description: "Add UUIDs and paper-index, keep directory names"
  },
  {
    label: "Minimal upgrade to v1.2",
    description: "Only add UUIDs and slugs to _panel.yaml"
  },
  {
    label: "Skip upgrade",
    description: "Continue with current version"
  }
]
```

### Step 3: Execute Migration

Based on user choice:

**Full upgrade (v2.0)**:
```javascript
const result = await migrateToLatest(researchDir, currentVersion);

// Show progress for each phase
for (const phase of result.phases) {
    msg(`Phase: ${phase.version}`, 'header');
    for (const change of phase.changes) {
        msg(change, 'item');
    }
}

msg(`✓ Upgraded from ${currentVersion} to v2.0`, 'success');
```

**Partial upgrade (v1.3)**:
```javascript
// Migrate v1.0 → v1.2 → v1.3
if (currentVersion === 'v1.0') {
    await migrateV10ToV12(researchDir);
}
if (currentVersion === 'v1.0' || currentVersion === 'v1.2') {
    await migrateV12ToV13(researchDir);
}
```

**Minimal upgrade (v1.2)**:
```javascript
// Only v1.0 → v1.2
if (currentVersion === 'v1.0') {
    await migrateV10ToV12(researchDir);
}
```

### Step 4: Auto-Commit

If migration completed:
```javascript
await gitCommitIfEnabled(
    `[panel] Upgrade to ${targetVersion}\n\n${result.summary}`,
    [researchDir]
);
```

### Step 5: Show Summary

```
═══════════════════════════════════════
✓ Panel Upgrade Complete
═══════════════════════════════════════

From: v1.0 (legacy format)
To:   v2.0 (numbered directories)

Changes:
  ✓ Added UUIDs to 5 papers
  ✓ Created paper-index.yaml
  ✓ Renamed 5 directories to numbered format

Next steps:
  • Test: panel:status
  • Add paper: panel:setup <name>
  • Ship: git push
```

---

## Level 1 — Project Setup Behavior (Fresh Installation)

Runs when invoked with no positional arguments and `${targetDir}/research/` does not exist.

**Variable convention**: `targetDir` = project root (e.g., `C:\src\panel`). Research files go in `${targetDir}/research/`.

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
mkdir -p "${targetDir}/research"
mkdir -p "${targetDir}/research/docs"
```

### Step 3: Copy infrastructure files from plugin

**CRITICAL**: All infrastructure files go inside `${targetDir}/research/`, NOT `${targetDir}` directly. Explicitly append `/research/` to every path.

```bash
# Copy from plugin templates INTO research/ subdirectory
cp "${CLAUDE_PLUGIN_ROOT}/templates/REVIEWER-DATABASE.md" "${targetDir}/research/REVIEWER-DATABASE.md"
cp "${CLAUDE_PLUGIN_ROOT}/templates/RESEARCH.md" "${targetDir}/research/RESEARCH.md"
cp "${CLAUDE_PLUGIN_ROOT}/templates/REVIEWERS.md" "${targetDir}/research/REVIEWERS.md"
cp "${CLAUDE_PLUGIN_ROOT}/templates/REVIEW_PANEL.md" "${targetDir}/research/REVIEW_PANEL.md"
cp "${CLAUDE_PLUGIN_ROOT}/templates/references.bib" "${targetDir}/research/references.bib"
```

Resulting layout (showing `${targetDir}/research/`):
```
${targetDir}/
└── research/
    ├── REVIEWER-DATABASE.md
    ├── RESEARCH.md
    ├── REVIEWERS.md
    ├── REVIEW_PANEL.md
    ├── references.bib        ← global bibliography for papers to draw from
    ├── docs/
    └── panel-*/              ← paper directories go here too
```

After copying, fill in template placeholders:
- `{MODULE}` → module name (directory name, e.g., "boost", "panel")
- `{MODULE_DESCRIPTION}` → from topic discovery or project CLAUDE.md
- `{AUTHOR}` → from git config or default "Author"
- `{DATE}` → current month/year

Skip files that already exist (don't overwrite).

### Step 4: Create Makefile

If `${targetDir}/research/Makefile` doesn't exist, create it at `${targetDir}/research/Makefile`:

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

### Step 6: Initial Paper Import from Waves

After initializing existing papers, offer to discover and create papers from completed waves. Uses the same pipeline as `panel:import --from waves`: `discover_from_waves()` from shared/topic-discovery.md and `generate_paper()` from shared/paper-generator.md.

**Detection**: Check if `.waves/` exists in cwd or if `C:\src\waves` is available.

**If waves detected**, use AskUserQuestion:

```
question: "Would you like to import paper topics from completed waves?
           This discovers research themes from your wave history and generates starter papers."
header: "Waves import"
options:
  - label: "Yes, discover papers from waves (Recommended)"
    description: "Scans completed waves for research themes, proposes papers with venues"
  - label: "No, I'll add papers manually"
    description: "Skip wave import — you can always run panel:import --from waves later"
```

**If user selects yes:**

1. Call `discover_from_waves(waves_dir, project)` from shared/topic-discovery.md
   - `waves_dir`: `.waves/` in cwd if present, else `C:\src\waves`
   - `project`: inferred from cwd basename
2. Display proposals table:

   ```
    #  Title                                              Venue              Evidence      Score
    ── ──────────────────────────────────────────────────  ──────────────── ────────────  ───────
    1  Wave-Driven Architecture Evolution Patterns         ICSE / FSE       12 pulses     0.82
    2  Discipline-Guided Code Generation at Scale          MLSys 2026       8 pulses      0.71
   ```

3. Use AskUserQuestion with `multiSelect: true` to let user pick which papers to create:
   - Present each paper as a selectable option with title and venue
   - Include "None — skip import" as an option

4. For each selected paper: call `generate_paper(proposal, options)` from shared/paper-generator.md
   - `options.project_dir`: the research target directory
   - `options.existing_papers`: papers already in research/

5. Update RESEARCH.md with new papers (append to Paper Inventory table)

**If no waves detected or user declines**: skip silently. Note in report.

### Step 7: Assemble Module Reviewer Subset

Uses all available context to populate REVIEWERS.md with the best reviewer subset for this module. Three input tiers — the strongest available signal wins:

| Input tier | Source | Signal quality |
|------------|--------|---------------|
| **Papers** (from Steps 5+6) | Venues, titles, abstracts from `_panel.yaml` | Strongest — venue-specific matching |
| **Waves themes** (from Step 1/6) | Disciplines, themes from completed waves | Good — category-based matching |
| **Research area** (from Step 1) | User-selected area (e.g., "Human-AI Interaction") | Baseline — broad category matching |

At least one of these is always available (Step 1 always asks for research area), so this step always runs.

**Skip condition**: If REVIEWERS.md already has per-paper tables (not just the template header), skip and note "already populated" in report.

#### If papers exist (most common path):

1. Collect all papers: read `_panel.yaml` from each `research/panel-*/` to get title, venue, keywords
2. For each paper, call `select_panel(paper_info, count=5)` from shared/reviewer-selector.md
3. Select 7 cross-portfolio panel members using overlap logic:
   - Reviewers appearing on 2+ paper panels get priority
   - Diversity: different categories, academic + practitioner mix
   - At least 1 reviewer from each paper's individual panel
4. Write REVIEWERS.md with per-paper tables + cross-portfolio panel

   Format matches `C:\src\panel\research\REVIEWERS.md`:
   - Header with module name, paper count, database link
   - One `### Paper N: {title} ({venue})` section per paper with 5-reviewer table
   - `## Cross-Portfolio Panel` section with 7-member table and selection rationale

#### If no papers but waves themes available:

1. Use discovered themes/disciplines from waves to identify relevant reviewer categories
2. Call `filter_reviewers({ category, venue })` for each relevant category
3. Select 10-15 recommended reviewers across matching categories
4. Write REVIEWERS.md with category-based recommendations (no per-paper tables yet)
5. Note: "Per-paper assignments will be added when papers are created"

#### If only research area available (brand new project, no waves):

1. Map research area to reviewer categories (e.g., "Human-AI Interaction" → HCI, AI Agents categories)
2. Call `filter_reviewers({ category })` for matched categories
3. Select 10-15 recommended reviewers
4. Write REVIEWERS.md with category-based recommendations
5. Note: "Broad selection based on research area — will refine when papers are added"

### Step 8: Research Monorepo Connection

**Detection**: Check if `../research/.git` exists. Infer module name from `basename(cwd)`.

**AskUserQuestion** (only if monorepo detected):

- **Already connected** (sync script + module dir exist in monorepo):
  ```
  question: "Research monorepo detected at ../research with existing module. Sync now?"
  header: "Monorepo sync"
  options:
    - label: "Yes, sync now (Recommended)"
      description: "Runs sync-to-research.sh to push latest papers to monorepo"
    - label: "No, skip"
      description: "You can sync later with ./scripts/sync-to-research.sh"
  ```

- **Not yet connected** (monorepo exists but no module dir):
  ```
  question: "Research monorepo detected at ../research. Connect this module?"
  header: "Monorepo"
  options:
    - label: "Yes, connect (Recommended)"
      description: "Creates sync script, runs initial sync, registers module in monorepo"
    - label: "No, skip"
      description: "You can connect later with panel:setup --connect"
  ```

- **Monorepo not detected**: silently skip. Note in report.

**If connecting (new connection):**

1. Verify/update monorepo:
   - `cd ../research && git fetch origin && git pull`

2. Generate `scripts/sync-to-research.sh` if missing — follow the exact pattern from `C:\src\panel\scripts\sync-to-research.sh` with substitutions:
   - `RESEARCH_REPO` → read from `../research/.git/config` remote origin URL
   - `PANEL_DIR` → `${RESEARCH_DIR}/{module}` where module = `basename(cwd)`
   - Paper glob → `panel-*/`
   - Commit prefix → `[{module}]`
   - Same files synced: paper dirs, docs/, Makefile, RESEARCH.md, REVIEW_PANEL.md, REVIEWERS.md

3. Run initial sync: `./scripts/sync-to-research.sh`

4. Register module in monorepo (if not already present):

   **README.md** — add:
   - Paper table section (matching format of existing Merit/Waves/Panel sections)
   - Sources table row: `| {Module} | {module}/ | {N} | [{source}](url) |`
   - Structure tree entry under `research/`

   **CLAUDE.md** — add:
   - Repository Layout tree entry (matching existing module entries)
   - Commit prefix in Conventions: `[{module}]`

5. Commit in monorepo: `[{module}] Register module: initial sync`

**If already connected (sync only):**

1. Run `./scripts/sync-to-research.sh`
2. Report sync result

### Step 9: Report

```
Panel Setup — boost
═══════════════════════════════════════════════════════════════════════

Research area: AI Systems & Infrastructure
Project root: C:\src\boost\
Research directory: C:\src\boost\research\

Discovered from waves:
  - Static analysis for command files (3 waves)
  - Command DSL compilation (2 waves)
  → Suggested reviewer categories: Compilers & PL Theory, Software Engineering

Infrastructure (${targetDir}/research/):
  ✓ REVIEWER-DATABASE.md  (copied from plugin — 45+ reviewers, 10 categories)
  ✓ RESEARCH.md           (paper inventory template)
  ✓ REVIEWERS.md          (module reviewer subset)
  ✓ REVIEW_PANEL.md       (placeholder)
  ✓ references.bib        (global bibliography — 1200+ entries)
  ✓ Makefile              (master build)

Papers: 3 detected (1 existing + 2 imported from waves)
```

**Papers imported** (if any from Step 6):
```
Papers Imported from Waves:
  ✓ panel-wave-architecture-evolution    ICSE / FSE     (12 pulses)
  ✓ panel-discipline-code-generation     MLSys 2026     (8 pulses)
```

**Reviewer panel** (if assembled in Step 7):
```
Reviewer Panel:
  ✓ REVIEWERS.md populated (12 unique reviewers across 3 papers)
  ✓ Cross-portfolio panel: 7 members selected
```

**Research monorepo** (from Step 8, one of three variants):

Connected:
```
Research Monorepo:
  ✓ Connected to ../research/{module}/
  ✓ scripts/sync-to-research.sh present
  ✓ {N} papers synced
  ✓ Module registered in monorepo README.md + CLAUDE.md
```

Already connected:
```
Research Monorepo:
  ✓ Already connected to ../research/{module}/
  ✓ Synced ({N} papers)
```

Not connected:
```
Research Monorepo:
  — Not connected (run panel:setup --connect to link to ../research)
```

**Next steps** (updated):
```
Next steps:
  1. Create plan.md:    Add plan.md to your paper directory (see panel:author --help)
  2. Write paper:       panel:author --paper <name> (orchestrate writing from plan)
  3. Start reviews:     panel:review --paper <name> (after writing complete)
  4. Check status:      panel:status
  5. Ship it:           commit + push + sync to plugin and research repos
```

---

## Level 2 — Per-Paper Setup Behavior

Runs when a `<paper-name>` positional argument is provided.

### Step 1: Normalize name

If name doesn't start with `panel-`, prepend it.
- `cross-venue-analysis` → `panel-cross-venue-analysis`
- `panel-cross-venue-analysis` → unchanged

### Step 2: Check for duplicates

If `research/<paper-name>/` already exists, warn and abort (use `panel:review` to advance existing papers).

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
├── reviews/              # Empty, ready for panel:review
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
  1. Create plan.md:      Add plan.md to paper directory with research plan
  2. Write your paper:    panel:author --paper panel-cross-venue-analysis
     OR manually edit:    main.tex and sections/*.tex
  3. Set the title:       Edit _panel.yaml → title field
  4. Start reviews:       panel:review --paper panel-cross-venue-analysis
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
Panel Setup Check — C:\src\boost
═══════════════════════════════════════════════════════════════════════

Plugin: ${CLAUDE_PLUGIN_ROOT} ✓

Infrastructure (${targetDir}/research/):
  ✓ REVIEWER-DATABASE.md  (45 reviewers, 10 categories)
  ✓ RESEARCH.md           (2 papers listed)
  ✓ REVIEWERS.md          present
  ✓ REVIEW_PANEL.md       present
  ✓ references.bib        present (1200+ entries)
  ✓ Makefile              present

Reviewer Panel:
  ✓ REVIEWERS.md          populated (12 reviewers, 7 panel members)
  — or —
  ⚠ REVIEWERS.md          template only (run panel:setup to populate)

Research Monorepo:
  ✓ scripts/sync-to-research.sh  present
  ✓ ../research/{module}/        exists ({N} papers)
  — or —
  — Not connected                (run panel:setup --connect)

Papers:
  ✓ panel-static-analysis       _panel.yaml ✓  venue: PLDI 2026     stage: draft
  ✓ panel-command-dsl            _panel.yaml ✓  venue: OOPSLA 2026   stage: draft

All 2 papers ready. Next: Create plan.md in each paper, then panel:author to write, or panel:review to start reviews.
```

## Connect Mode

```
panel:setup --connect
panel:setup --connect C:\src\research
```

Standalone mode — connects an existing research directory to a research monorepo without running full setup.

### Behavior

1. **Verify prerequisites**: Check `research/` exists in cwd. If not, abort with:
   ```
   Error: research/ directory not found. Run panel:setup first to create it.
   ```

2. **Resolve monorepo path**:
   - If `--connect <path>` provided: use that path
   - Default: `../research`

3. **Run Step 8 only**: Execute the Research Monorepo Connection logic (detection, connection, registration) from the project setup flow above.

4. **Report**: Show just the connection outcome:
   ```
   Panel Setup — Connect to Research Monorepo
   ═══════════════════════════════════════════════════════════════════════

   Module: boost
   Monorepo: ../research/

   ✓ scripts/sync-to-research.sh generated
   ✓ Initial sync complete ({N} papers)
   ✓ Module registered in monorepo README.md + CLAUDE.md
   ✓ Committed: [{module}] Register module: initial sync
   ```

   If already connected:
   ```
   ✓ Already connected — synced ({N} papers)
   ```

   If monorepo not found:
   ```
   Error: No git repository found at ../research
   Hint: Clone it first, or specify the path: panel:setup --connect <path>
   ```

5. **Auto-commit**: Commit sync script and any local changes.

---

## Auto-Commit

After project-level or per-paper setup completes, auto-commit:

1. Call `auto_commit()` from shared/git-utils.md
2. Scope: the research directory
3. Message (project): `[panel] Setup: initialize {module} research infrastructure`
4. Message (paper): `[panel] Setup: add paper {paper-name} ({venue})`
5. Skipped for `--check` (read-only) and `--dry-run`

## Dependencies

- shared/git-utils.md — Auto-commit after setup
- shared/state-loader.md — Create/validate _panel.yaml files
- shared/display-utils.md — Terminal formatting
- shared/topic-discovery.md — Waves scanning for topic discovery, `discover_from_waves()` for paper import
- shared/paper-generator.md — `generate_paper()` for creating papers from wave proposals
- shared/reviewer-selector.md — `select_panel()` for per-paper reviewers, `filter_reviewers()` for category-based selection
- templates/references.bib — Global bibliography catalog for papers
- templates/REVIEWER-DATABASE.md — Bundled reviewer database
- templates/RESEARCH.md — Paper inventory template
- templates/REVIEWERS.md — Module reviewer subset template
- templates/REVIEW_PANEL.md — Cross-portfolio panel placeholder
- templates/revision-plan-template.md — Revision plan structure
