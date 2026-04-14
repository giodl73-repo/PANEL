---
name: panel:upgrade
description: Smart migration from v1.x to v2.0. Detects current layout, renames panel- prefixed directories, restructures into papers/publications, installs Makefiles, migrates reviewer profiles to .craft/roles, updates panel.json. Safe — shows plan before touching anything.
user-invocable: true
allowed-tools:
  - Read
  - Write
  - Edit
  - Glob
  - Bash
  - AskUserQuestion
---

# panel:upgrade — Smart Migration v1.x → v2.0

Detects your current panel installation and migrates to v2.0 conventions:
- No `panel-` prefix on directories
- `publications/` and `papers/` subdirectories per module
- Three-level dynamic Makefiles (`dist` → `docs/`)
- Reviewer profiles in `.craft/roles/panel-reviewer/` (not `context/`)
- `panel.json` updated with `papersPath` + `publicationsPath`
- `MODULE.md` scaffolded from existing paper inventory

**Safe by default** — shows a plan and asks confirmation before touching anything.

## Plugin Root + Config

```javascript
// @import ../shared/project-config.md
// @import ../shared/module-utils.md

const projectConfig = loadProjectConfig();
const pluginRoot = projectConfig.pluginRoot;
```

## Arguments

```
panel:upgrade              # Full migration with plan preview + confirmation
panel:upgrade --dry-run    # Show plan only — touch nothing
panel:upgrade --yes        # Skip confirmation (for scripted use)
panel:upgrade --step <n>   # Run only step N (for partial/resume)
panel:upgrade --check      # Report what needs migration, no plan output
```

---

## Step 0 — Detect Current State

```javascript
async function detectVersion(projectConfig) {
    const researchPath = projectConfig.researchPath;

    return {
        // v1.x signals
        hasPanelPrefixDirs: glob(`${researchPath}/panel-*/`).length > 0,
        hasContextReviewers: exists(`context/panel/reviewers/profiles/`),
        missingPapersPublicationsSplit: !exists(`${researchPath}/publications/`),
        panelJsonMissingPaths: !projectConfig.papersPath || projectConfig.papersPath === projectConfig.researchPath,
        hasOldMakefile: exists(`${researchPath}/Makefile`) && isHardcodedMakefile(`${researchPath}/Makefile`),
        missingModuleMd: !exists(`${researchPath}/MODULE.md`),

        // Counts
        prefixedDirs: glob(`${researchPath}/panel-*/`),
        latexDirs: glob(`${researchPath}/panel-*/main.tex`).map(p => dirname(p)),
        markdownFiles: glob(`${researchPath}/panel-*.md`),
        customReviewerProfiles: detectCustomReviewerProfiles(),
    };
}
```

**Version detection:**
- No `panel-` dirs AND `publications/` exists AND `papersPath` in config → **v2.0, nothing to do**
- `panel-` dirs OR no `publications/` split OR no `papersPath` → **v1.x, migration needed**

---

## Step 1 — Build Migration Plan

Construct a complete plan before touching anything:

```javascript
const plan = {
    steps: [],
    renames: [],       // panel-foo → foo
    moves: [],         // research/panel-foo → research/publications/foo
    configUpdates: [],
    makefileUpdates: [],
    profileMoves: [],  // context/panel/reviewers/profiles/custom → .craft/roles/panel-reviewer/
    newFiles: [],      // MODULE.md, Makefiles
};
```

### Plan: Directory restructure

For each `panel-*/` directory:
1. Strip `panel-` prefix: `panel-token-efficiency` → `token-efficiency`
2. Detect content type:
   - Has `main.tex` → LaTeX publication → move to `publications/token-efficiency/`
   - Has only `.md` files → markdown paper → move to `papers/token-efficiency.md`
   - Has both → publication (LaTeX wins), markdown files moved to `papers/`
3. Add to rename+move plan

### Plan: Makefile upgrades

- Per-publication: replace hardcoded `DIST_DIR = ../docs` with `../../docs` + dynamic `SLUG`
- Publications-level: create `publications/Makefile` from `templates/makefile-publications.mk`
- Module-level: replace hardcoded paper list with `wildcard` discovery

### Plan: Reviewer profile migration

Scan `context/panel/reviewers/profiles/`:
```javascript
function detectCustomReviewerProfiles() {
    const existing = glob('context/panel/reviewers/profiles/*.md');
    const standard = new Set(
        glob(`${pluginRoot}/.craft/roles/panel-reviewer/R-*.md`)
            .map(f => basename(f))
    );
    // Custom = profiles not in the standard R-N set
    return existing.filter(f => !standard.has(basename(f)));
}
```

- Standard R-N.md profiles → delete (plugin provides via pluginRoot, no local copy needed)
- Custom profiles (non-R-N) → move to `.craft/roles/panel-reviewer/`
- If `context/panel/reviewers/` becomes empty → remove directory

### Plan: panel.json update

Add `papersPath` and `publicationsPath` to each project:
```json
{
  "papersPath": "{researchPath}/papers",
  "publicationsPath": "{researchPath}/publications"
}
```

### Plan: MODULE.md scaffolding

If no `MODULE.md` exists but publications do: scaffold a minimal MODULE.md
from the existing paper inventory (`RESEARCH.md` if present, otherwise
from `_panel.yaml` files).

---

## Step 2 — Show Plan

```
panel:upgrade — Migration Plan
═══════════════════════════════════════════════════════════════════════

Detected: v1.x installation (5 panel-* directories)

Directories (5 renames + restructure):
  research/panel-token-efficiency/    →  research/publications/token-efficiency/
  research/panel-profile-caching/     →  research/publications/profile-caching/
  research/panel-ole-injection/       →  research/publications/ole-injection/
  research/panel-quick-notes.md       →  research/papers/quick-notes.md
  research/panel-position-paper.md    →  research/papers/position-paper.md

Makefiles (3 updates):
  research/Makefile                   →  dynamic wildcard discovery
  research/publications/Makefile      →  new (from template)
  research/publications/*/Makefile    →  dist → ../../docs/ (5 files)

Reviewer profiles:
  context/panel/reviewers/profiles/R-1.md ... R-51.md  →  delete (plugin provides via pluginRoot)
  context/panel/reviewers/profiles/my-custom.md        →  .craft/roles/panel-reviewer/my-custom.md

panel.json (2 project updates):
  panel.papersPath        =  "research/papers"
  panel.publicationsPath  =  "research/publications"

MODULE.md:
  research/MODULE.md  →  scaffold from 5 existing _panel.yaml files

Git:
  All changes committed as: [panel] upgrade v1.x → v2.0

═══════════════════════════════════════════════════════════════════════
Proceed? (--dry-run to skip, --yes to skip this prompt)
```

Present via AskUserQuestion:
```javascript
AskUserQuestion({
    question: "Proceed with migration?",
    header: "panel:upgrade",
    options: [
        { label: "Yes, migrate now", description: "Applies all changes above" },
        { label: "Dry run only", description: "Show plan, touch nothing" },
        { label: "Cancel", description: "Exit without changes" }
    ]
});
```

---

## Step 3 — Execute Migration

Execute in safe order (parents before children, reads before writes):

### 3a — Create new directory structure
```bash
mkdir -p ${researchPath}/publications
mkdir -p ${researchPath}/papers
mkdir -p ${researchPath}/docs
```

### 3b — Move publication directories (LaTeX)
```bash
# For each LaTeX panel-* directory
git mv ${researchPath}/panel-token-efficiency ${researchPath}/publications/token-efficiency
```
Use `git mv` to preserve history.

### 3c — Move markdown papers
```bash
# For each markdown panel-*.md file
git mv ${researchPath}/panel-quick-notes.md ${researchPath}/papers/quick-notes.md
```

### 3d — Update _panel.yaml for each publication
Add `type: publication` field:
```javascript
for (const pub of publications) {
    const yamlPath = `${pub.newPath}/_panel.yaml`;
    const state = parseYAML(Read(yamlPath));
    state.type = 'publication';
    writeYAML(yamlPath, state);
}
```

### 3e — Install Makefiles
```bash
# Module-level (replace hardcoded)
cp ${pluginRoot}/templates/makefile-module.mk ${researchPath}/Makefile

# Publications-level (new)
cp ${pluginRoot}/templates/makefile-publications.mk ${researchPath}/publications/Makefile

# Per-publication (replace hardcoded DIST_DIR)
for each publication:
    cp ${pluginRoot}/templates/makefile-publication.mk ${pub.path}/Makefile
    # SLUG is derived dynamically from directory name — no substitution needed
```

### 3f — Migrate reviewer profiles
```bash
# Delete standard R-N profiles (plugin provides them via pluginRoot)
for profile in context/panel/reviewers/profiles/R-*.md:
    git rm ${profile}

# Move custom profiles to .craft/roles
for profile in customProfiles:
    mkdir -p .craft/roles/panel-reviewer
    git mv ${profile} .craft/roles/panel-reviewer/${basename(profile)}

# Remove empty directory
if empty context/panel/reviewers/:
    git rm -r context/panel/reviewers/
```

### 3g — Update panel.json
```javascript
const config = JSON.parse(Read('.claude/panel.json'));
for (const [name, project] of Object.entries(config.projects)) {
    const rp = project.researchPath || 'research';
    project.papersPath = project.papersPath || `${rp}/papers`;
    project.publicationsPath = project.publicationsPath || `${rp}/publications`;
}
Write('.claude/panel.json', JSON.stringify(config, null, 2));
```

### 3h — Scaffold MODULE.md
If no `MODULE.md` exists:
```javascript
// Read all _panel.yaml files to get paper inventory
const publications = glob(`${researchPath}/publications/*/_panel.yaml`)
    .map(p => parseYAML(Read(p)));

// Generate minimal MODULE.md — tracks TBD, user fills in
const moduleContent = scaffoldModuleMd(projectConfig.projectName, publications);
Write(`${researchPath}/MODULE.md`, moduleContent);
```

Minimal scaffold — tracks are marked `TBD` with a prompt to run `panel:module design`:
```markdown
# Module: [projectName]

**Theme**: [TODO — run panel:module design to define]
**Migrated from**: v1.x on [date]

## Tracks

> TODO: Run `panel:module design` to define tracks and causal chains.
> Each publication below needs to be assigned to ≥1 track.

## Publications

| Publication | Tracks | Primary Number | Stage | Venue |
|-------------|--------|----------------|-------|-------|
[generated from _panel.yaml inventory]

---
*Scaffolded by panel:upgrade. Run panel:module design to complete.*
```

---

## Step 4 — Commit

```javascript
const changedPaths = [
    researchPath,
    '.claude/panel.json',
    '.craft/roles/panel-reviewer/',
];
if (customProfilesMoved) changedPaths.push('context/panel/');

await gitCommitIfEnabled(
    `[panel] upgrade v1.x → v2.0\n\n` +
    `${publications.length} publications restructured\n` +
    `${papers.length} papers moved to papers/\n` +
    `Makefiles: dynamic discovery + dist → docs/\n` +
    `Reviewer profiles: ${customCount} custom → .craft/roles, standard removed\n` +
    `panel.json: papersPath + publicationsPath added`,
    changedPaths
);
```

---

## Step 5 — Report

```
panel:upgrade — Complete
═══════════════════════════════════════════════════════════════════════

✓ 3 publications moved to research/publications/
    token-efficiency/   (was panel-token-efficiency)
    profile-caching/    (was panel-profile-caching)
    ole-injection/      (was panel-ole-injection)

✓ 2 papers moved to research/papers/
    quick-notes.md      (was panel-quick-notes.md)
    position-paper.md   (was panel-position-paper.md)

✓ Makefiles updated (dynamic, dist → docs/)
    research/Makefile
    research/publications/Makefile (new)
    research/publications/*/Makefile (3 files)

✓ Reviewer profiles migrated
    51 standard R-N profiles deleted (plugin provides via pluginRoot)
    1 custom profile → .craft/roles/panel-reviewer/my-custom.md
    context/panel/reviewers/ removed

✓ panel.json updated
    papersPath: research/papers
    publicationsPath: research/publications

✓ MODULE.md scaffolded at research/MODULE.md
    3 publications listed, tracks TBD

✓ Committed: [panel] upgrade v1.x → v2.0

═══════════════════════════════════════════════════════════════════════

Next steps:
  panel:module design   — define tracks and causal chains for your module
  panel:publication build — verify all PDFs still compile (make dist)
  panel:paper status    — verify all papers visible
```

---

## Auto-Commit

After migration completes (skipped for `--dry-run`):
```javascript
await gitCommitIfEnabled(migrationCommitMessage, changedPaths);
```

## Dependencies

- shared/project-config.md — researchPath, papersPath, publicationsPath, pluginRoot
- shared/module-utils.md — scaffoldModuleMd()
- shared/state-loader.md — _panel.yaml read/write
- shared/git-helper.md — auto-commit
- templates/makefile-publication.mk — per-publication Makefile
- templates/makefile-publications.mk — publications-level Makefile
- templates/makefile-module.mk — module-level Makefile
