# board scaffold — Discover and Scaffold Modules

Discover and scaffold modules that exist on disk but lack panel infrastructure.
The board is the right place for this — it has the monorepo view and can see
all research paths at once.

```
panel:board scaffold               # discover and scaffold all
panel:board scaffold module-alpha  # scaffold one module by name
panel:board scaffold --check       # show what needs scaffolding, no changes
```

**Discovery**: finds three types of unscaffolded modules:

| Type | Signal | Action |
|------|--------|--------|
| **Configured, empty** | In `panel.json` but no `papers/` or `publications/` | Create directories + Makefiles + MODULE.md stub |
| **Configured, unarchitected** | Has publications but no `MODULE.md` | Scaffold MODULE.md from existing `_panel.yaml` inventory |
| **Unconfigured, exists** | Research path exists on disk but not in `panel.json` | Offer to register in `panel.json` + scaffold |

## Flow

### Step 1 — Discovery

```javascript
const allProjects = getAllProjects();
const gaps = [];

for (const project of allProjects) {
    const researchDir = path.join(cwd, project.researchPath);
    const moduleFile = resolveModuleFile(researchDir);
    const hasPublications = exists(path.join(researchDir, 'publications'));
    const hasPapers = exists(path.join(researchDir, 'papers'));

    if (!exists(researchDir)) {
        gaps.push({ project, type: 'empty', action: 'create-structure' });
    } else if (!moduleFile) {
        gaps.push({ project, type: 'unarchitected', action: 'scaffold-module-md' });
    } else if (!hasPublications && !hasPapers) {
        gaps.push({ project, type: 'no-content-dirs', action: 'create-dirs' });
    }
}

// Also scan for unconfigured research directories
const discoveredPaths = await discoverResearchPaths(cwd);
for (const path of discoveredPaths) {
    if (!allProjects.find(p => p.researchPath === path)) {
        gaps.push({ path, type: 'unconfigured', action: 'register-and-scaffold' });
    }
}
```

### Step 2 — Show discovery report

```
panel:board scaffold --check
═══════════════════════════════════════════════════════════════════════

Board sees 4 modules. Scaffold status:

  module-alpha   ✓ Fully scaffolded (MODULE.md, publications/, papers/)
  module-beta    ⚠ No MODULE.md — has 3 publications, needs architecture
  module-gamma   ✗ Empty — research path exists but no content directories
  module-delta   ✗ Not configured — research/delta/ exists but not in panel.json

Actions needed:
  module-beta    scaffold MODULE.md from 3 existing _panel.yaml files
  module-gamma   create publications/, papers/, docs/, Makefiles
  module-delta   register in panel.json + full scaffold
```

### Step 3 — Scaffold per module

For `type: empty` — create full structure:
```bash
mkdir -p ${researchDir}/publications
mkdir -p ${researchDir}/papers
mkdir -p ${researchDir}/docs
cp ${pluginRoot}/templates/makefile-module.mk ${researchDir}/Makefile
cp ${pluginRoot}/templates/makefile-publications.mk ${researchDir}/publications/Makefile
```
Then scaffold MODULE.md stub and run `panel:module design` interactively
(or generate a full stub with `--auto`).

For `type: unarchitected` — MODULE.md only:
```javascript
const publications = glob(`${researchDir}/publications/*/_panel.yaml`)
    .map(p => parseYAML(Read(p)));
const papers = glob(`${researchDir}/papers/*.md`);
const moduleContent = scaffoldModuleMd(project.projectName, publications, papers);
Write(`${researchDir}/MODULE.md`, moduleContent);
```

For `type: unconfigured` — register + full scaffold:
```javascript
// 1. Add to panel.json
const config = JSON.parse(Read('.claude/panel.json'));
config.projects[inferModuleName(discoveredPath)] = {
    projectName: inferModuleName(discoveredPath),
    researchPath: discoveredPath,
    papersPath: `${discoveredPath}/papers`,
    publicationsPath: `${discoveredPath}/publications`,
    panelPath: `context/panel/${inferModuleName(discoveredPath)}`,
    clientSlug: inferModuleName(discoveredPath)
};
Write('.claude/panel.json', JSON.stringify(config, null, 2));
// 2. Then scaffold as 'empty' above
```

### Step 4 — Offer to design MODULE.md

After scaffolding, for each module with a stub MODULE.md:
```javascript
AskUserQuestion({
    question: `${module.name} scaffolded. Define module architecture now?`,
    options: [
        { label: 'Yes — run panel:module design', description: 'Interactive track design' },
        { label: 'Later', description: 'MODULE.md has a stub — fill in tracks manually' }
    ]
});
```
If yes: relay to `panel:module design <module-name>`.

### Step 5 — Report + commit

```
panel:board scaffold — Complete
═══════════════════════════════════════════════════════════════════════

✓ module-beta    MODULE.md scaffolded (3 publications, tracks TBD)
✓ module-gamma   Full structure created (publications/, papers/, docs/, Makefiles)
✓ module-delta   Registered in panel.json + full structure created

All 3 modules ready for panel:module design.

Next: panel:module design <module-name> to define tracks and causal chains.
```
