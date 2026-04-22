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
// @import ../shared/project-config.md

// Load project configuration
const projectConfig = loadProjectConfig();
const researchPath = projectConfig.researchPath;

targetDir = project root directory (e.g., "C:\src\panel" or "C:\src\craftworks")
           All research files go in ${targetDir}/${researchPath}/

           Examples:
           - Standalone: targetDir = "C:\src\panel"
                        researchPath = "research"
                        Full path: "C:\src\panel/research/RESEARCH.md"

           - Monorepo:   targetDir = "C:\src\craftworks"
                        researchPath = "research/craft"
                        Full path: "C:\src\craftworks/research/craft/RESEARCH.md"
```

**Multi-Project Support**: The `researchPath` is loaded from `.claude/panel.json` based on the active project. Use `panel:project` to switch between projects in a monorepo.

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

```javascript
// @import ../shared/project-config.md

// Load project configuration to get researchPath
const projectConfig = loadProjectConfig();
const researchPath = projectConfig.researchPath;

// Resolve target directory
const targetDir = args['--project'] || process.cwd();
const researchDir = path.join(targetDir, researchPath);
```

**Resolution order**:
1. `--project <path>` if specified → `targetDir = <path>`
2. Default → `targetDir = {cwd}`
3. Research path → `researchDir = ${targetDir}/${projectConfig.researchPath}`

All infrastructure files are placed in `researchDir`, which is created if missing.

**Multi-Project Examples**:
- Standalone mode: `researchPath = "research"` → `C:\src\panel/research/`
- Monorepo mode: `researchPath = "research/craft"` → `C:\src\craftworks/research/craft/`

## Invocation Modes

| Mode | Trigger | File |
|------|---------|------|
| Batch Scan | `--scan` or `--discover` flag | See [scan.md](scan.md) |
| Auto-Upgrade | No args, `researchDir` exists | See [upgrade.md](upgrade.md) |
| Project Setup | No args, `researchDir` does not exist | See [project.md](project.md) |
| Per-Paper Setup | `<paper-name>` positional argument | See [paper.md](paper.md) |
| Check | `--check` flag | See [check.md](check.md) |
| Connect | `--connect` flag | See [connect.md](connect.md) |

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
- `--project <path>` — Target project directory (default: cwd; researchPath from config is auto-appended)
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
   - If `--scan` or `--discover` flag → Run batch discovery and setup (See [scan.md](scan.md))
   - If `--connect` flag → Run research monorepo connection (See [connect.md](connect.md))
   - If `--check` flag → Run validation only (See [check.md](check.md))
   - If `<paper-name>` positional argument → Per-paper setup (See [paper.md](paper.md))
   - If no positional arguments → Project-level setup or upgrade:
     - Load project config and determine researchDir
     - Check if `researchDir` exists
     - If yes: **Auto-upgrade flow** (See [upgrade.md](upgrade.md))
     - If no: **Fresh setup flow** (See [project.md](project.md))

2. **Execute the appropriate flow** by following the referenced file.

---

## Auto-Commit

After project-level or per-paper setup completes, auto-commit:

1. Call `auto_commit()` from shared/git-helper.md
2. Scope: the research directory
3. Message (project): `[panel] Setup: initialize {module} research infrastructure`
4. Message (paper): `[panel] Setup: add paper {paper-name} ({venue})`
5. Skipped for `--check` (read-only) and `--dry-run`

## Dependencies

- shared/git-helper.md — Auto-commit after setup
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
