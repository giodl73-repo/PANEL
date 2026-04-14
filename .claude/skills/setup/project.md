# Level 1 — Project Setup (Fresh Installation)

Runs when invoked with no positional arguments and `researchDir` does not exist.

**Variable convention**:
```javascript
// @import ../shared/project-config.md

const projectConfig = loadProjectConfig();
const targetDir = process.cwd();
const researchDir = path.join(targetDir, projectConfig.researchPath);
```

Research files go in `researchDir` (e.g., `C:\src\panel/research/` or `C:\src\craftworks/research/craft/`).

## Step 1: Interactive Topic Discovery

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

## Step 2: Create research directory

```bash
mkdir -p "${researchDir}"
mkdir -p "${researchDir}/docs"
```

## Step 2b: Cache plugin root

Read `CLAUDE_PLUGIN_ROOT` from the environment and persist it into `.claude/panel.json` so all commands can resolve plugin files after installation without relying on the env var being set.

```javascript
const pluginRoot = process.env.CLAUDE_PLUGIN_ROOT;
if (!pluginRoot) {
  throw new Error('CLAUDE_PLUGIN_ROOT is not set. Is the panel plugin installed correctly?');
}

// Load existing config (created by panel:setup or user)
const configPath = path.join(targetDir, '.claude', 'panel.json');
const config = JSON.parse(fs.readFileSync(configPath, 'utf8') || '{}');

// Cache pluginRoot — persists across sessions
config.pluginRoot = pluginRoot;
fs.writeFileSync(configPath, JSON.stringify(config, null, 2), 'utf8');
```

## Step 3: Copy infrastructure files from plugin

**CRITICAL**: All infrastructure files go inside `researchDir`, NOT `targetDir` directly. Use the `researchDir` variable throughout.

```bash
# Copy from plugin templates INTO researchDir
cp "${CLAUDE_PLUGIN_ROOT}/templates/REVIEWER-DATABASE.md" "${researchDir}/REVIEWER-DATABASE.md"
cp "${CLAUDE_PLUGIN_ROOT}/templates/RESEARCH.md" "${researchDir}/RESEARCH.md"
cp "${CLAUDE_PLUGIN_ROOT}/templates/REVIEWERS.md" "${researchDir}/REVIEWERS.md"
cp "${CLAUDE_PLUGIN_ROOT}/templates/REVIEW_PANEL.md" "${researchDir}/REVIEW_PANEL.md"
cp "${CLAUDE_PLUGIN_ROOT}/templates/references.bib" "${researchDir}/references.bib"
```

Resulting layout (showing `researchDir`):
```
${researchDir}/
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

## Step 4: Create Makefile

If `${researchDir}/Makefile` doesn't exist, create it at `${researchDir}/Makefile`:

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

## Step 5: Initialize existing papers

For each detected paper directory (containing `main.tex`) without `_panel.yaml`:
- Create `_panel.yaml` with stage: draft
- Create `reviews/` directory
- Create empty `REVISION-PLAN.md` from template

## Step 6: Initial Paper Import from Waves

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

## Step 6b: Verify reviewer profiles accessible

The profile loader reads directly from `${pluginRoot}/.craft/roles/panel-reviewer/` — no file copying needed. Users who want to add custom reviewer profiles create them in their project's `.craft/roles/panel-reviewer/` directory.

```javascript
// Verify plugin reviewer profiles are accessible via pluginRoot
const pluginRolesPath = `${pluginRoot}/.craft/roles/panel-reviewer`;
const indexExists = await exists(`${pluginRolesPath}/_index.yaml`);
if (!indexExists) {
    msg(`⚠ Reviewer profiles not found at ${pluginRolesPath}`, 'warning');
    msg(`  Check CLAUDE_PLUGIN_ROOT is set correctly`, 'item');
} else {
    const profileCount = glob(`${pluginRolesPath}/R-*.md`).length;
    msg(`Reviewer profiles: ${profileCount} profiles at ${pluginRolesPath}`, 'item');
    msg(`Extensions: add custom profiles to .craft/roles/panel-reviewer/`, 'item');
}
```

## Step 7: Assemble Module Reviewer Subset

Uses all available context to populate REVIEWERS.md with the best reviewer subset for this module. Three input tiers — the strongest available signal wins:

| Input tier | Source | Signal quality |
|------------|--------|---------------|
| **Papers** (from Steps 5+6) | Venues, titles, abstracts from `_panel.yaml` | Strongest — venue-specific matching |
| **Waves themes** (from Step 1/6) | Disciplines, themes from completed waves | Good — category-based matching |
| **Research area** (from Step 1) | User-selected area (e.g., "Human-AI Interaction") | Baseline — broad category matching |

At least one of these is always available (Step 1 always asks for research area), so this step always runs.

**Skip condition**: If REVIEWERS.md already has per-paper tables (not just the template header), skip and note "already populated" in report.

### If papers exist (most common path):

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

### If no papers but waves themes available:

1. Use discovered themes/disciplines from waves to identify relevant reviewer categories
2. Call `filter_reviewers({ category, venue })` for each relevant category
3. Select 10-15 recommended reviewers across matching categories
4. Write REVIEWERS.md with category-based recommendations (no per-paper tables yet)
5. Note: "Per-paper assignments will be added when papers are created"

### If only research area available (brand new project, no waves):

1. Map research area to reviewer categories (e.g., "Human-AI Interaction" → HCI, AI Agents categories)
2. Call `filter_reviewers({ category })` for matched categories
3. Select 10-15 recommended reviewers
4. Write REVIEWERS.md with category-based recommendations
5. Note: "Broad selection based on research area — will refine when papers are added"

## Step 8: Research Monorepo Connection

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

## Step 9: Report

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

**Reviewer Profiles** (from Step 6b):
```
Reviewer Profiles:
  ✓ ${pluginRoot}/.craft/roles/panel-reviewer/_index.yaml accessible
  ✓ 51 R-N.md profiles accessible (OLE format, Spec 93)
  — Extensions: .craft/roles/panel-reviewer/ (local, optional)
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
