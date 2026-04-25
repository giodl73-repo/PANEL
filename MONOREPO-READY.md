# Panel Monorepo Support - Implementation Summary

Panel is now prepared for multi-project monorepo usage, following the probe `testsPath` pattern.

## ✅ Completed

### 1. Configuration Updates

**File**: `.claude/panel.json`
- ✅ Added `projects` object for multi-project support
- ✅ Each project has `researchPath`, `panelPath`, `clientSlug`, `projectName`, `description`
- ✅ Backward compatible with standalone mode
- ✅ Updated to v1.2.0

### 2. Project Config Loader

**File**: `shared/project-config.md`
- ✅ `loadProjectConfig()` - Load active project configuration
- ✅ `getAllProjects()` - List all configured projects
- ✅ `switchProject(name)` - Switch default project
- ✅ Backward compatible with legacy config format

### 3. Project Switcher Command

**File**: `commands/project.md`
- ✅ `panel:project` - List all projects
- ✅ `panel:project <name>` - Switch to project
- ✅ Shows current project, research paths, descriptions
- ✅ Error handling for missing projects

### 4. Plugin Manifest

**File**: `.claude-plugin/plugin.json`
- ✅ Added `project.md` command
- ✅ Bumped version to 1.2.0

### 5. Documentation

**File**: `MULTI-PROJECT-SETUP.md`
- ✅ Complete guide for multi-project configuration
- ✅ Examples for standalone and monorepo modes
- ✅ Directory structure diagrams
- ✅ Command update checklist
- ✅ Migration path for existing installations

## ⬜ Remaining Work

To complete monorepo support, update these commands to use `researchPath` from project config:

### Commands to Update

1. **setup.md** - Use `projectConfig.researchPath` instead of hardcoded `research/`
2. **review.md** - Load project config, use `researchPath` for paper lookup
3. **status.md** - Load project config, use `researchPath` for RESEARCH.md
4. **show.md** - Load project config, use `researchPath` for paper lookup
5. **convene.md** - Load project config, use `researchPath` for module papers
6. **board.md** - May need to aggregate across multiple projects
7. **author.md** - Load project config, use `researchPath` for paper creation
8. **import.md** - Load project config, use `researchPath` for imports

### Update Pattern

For each command, add at the beginning:

```javascript
// @import ../shared/project-config.md

// Load project configuration
const projectConfig = loadProjectConfig();
const researchDir = path.join(process.cwd(), projectConfig.researchPath);

// Use researchDir instead of hardcoded research/
```

## Configuration Examples

### Standalone Mode (Current - panel)

```json
{
  "default": "panel",
  "projects": {
    "panel": {
      "panelPath": "context/panel/panel-dev",
      "researchPath": "research",
      "clientSlug": "panel-dev",
      "projectName": "panel"
    }
  }
}
```

### Monorepo Mode (Future - workspace)

Create `.claude/panel.json` in workspace:

```json
{
  "default": "craft-research",
  "gitStrategy": "auto-commit",
  "projects": {
    "craft-research": {
      "panelPath": "context/panel/craft-research",
      "researchPath": "research/craft",
      "clientSlug": "craft-research",
      "projectName": "craft",
      "targetPlugin": "plugins/craft",
      "description": "Craft plugin research papers"
    },
    "waves-research": {
      "panelPath": "context/panel/waves-research",
      "researchPath": "research/waves",
      "clientSlug": "waves-research",
      "projectName": "waves",
      "targetPlugin": "plugins/waves",
      "description": "Waves plugin research papers"
    },
    "probe-research": {
      "panelPath": "context/panel/probe-research",
      "researchPath": "research/probe",
      "clientSlug": "probe-research",
      "projectName": "probe",
      "targetPlugin": "plugins/probe",
      "description": "Probe plugin research papers"
    },
    "boost-research": {
      "panelPath": "context/panel/boost-research",
      "researchPath": "research/boost",
      "clientSlug": "boost-research",
      "projectName": "boost",
      "targetPlugin": "plugins/boost",
      "description": "Boost plugin research papers"
    },
    "panel-research": {
      "panelPath": "context/panel/panel-research",
      "researchPath": "research/panel",
      "clientSlug": "panel-research",
      "projectName": "panel",
      "targetPlugin": "plugins/panel",
      "description": "Panel plugin research papers (meta)"
    }
  },
  "hubs": {
    "panel": {
      "local": "./.panel-hub",
      "remotes": ["hubs/panel"]
    }
  }
}
```

## Directory Structure

### Workspace Monorepo with Panel

```
workspace/
├── .claude/
│   ├── waves.json              # Wave tracking (10 projects)
│   ├── probe.json              # Testing (10 projects)
│   └── panel.json              # Research papers (5 projects) ← NEW
│
├── plugins/
│   ├── craft/
│   ├── waves/
│   ├── probe/
│   ├── boost/
│   └── panel/                  # Panel plugin (when added)
│
├── research/                   # Research papers by plugin
│   ├── craft/                  # Craft research
│   │   ├── panel-paper-1/
│   │   ├── panel-paper-2/
│   │   └── RESEARCH.md
│   ├── waves/                  # Waves research
│   │   └── RESEARCH.md
│   ├── probe/                  # Probe research
│   │   └── RESEARCH.md
│   ├── boost/                  # Boost research
│   │   └── RESEARCH.md
│   └── panel/                  # Panel research (meta)
│       └── RESEARCH.md
│
├── context/
│   ├── waves/{project-dev}/
│   ├── probe/{project-dev}/
│   └── panel/                  # Panel context ← NEW
│       ├── craft-research/
│       ├── waves-research/
│       ├── probe-research/
│       ├── boost-research/
│       └── panel-research/
│
└── hubs/
    ├── waves/
    ├── probe/
    └── panel/                  # Panel hub ← NEW
```

## Usage Examples

### In Workspace Monorepo

```bash
cd workspace

# List panel projects
panel:project

# Switch to craft research
panel:project craft-research

# Setup panel for craft
panel:setup

# Add a paper
panel:setup panel-craft-paper "CHI 2026"

# Review the paper
panel:review panel-craft-paper

# Switch to waves research
panel:project waves-research
panel:setup
panel:setup panel-waves-paper "CSCW 2026"
```

### In Standalone Mode

```bash
cd panel

# Still works as before
panel:setup
panel:setup panel-new-paper "CHI 2026"
panel:review panel-new-paper
```

## Alignment with Workspace

Panel now follows the same multi-project pattern as:

| Plugin | Config Field | Path Pattern | Example |
|--------|--------------|--------------|---------|
| **waves** | `wavesPath` | `context/waves/{project-dev}` | `context/waves/craft-dev` |
| **probe** | `testsPath` | `tests/{plugin}` | `tests/craft` |
| **panel** | `researchPath` | `research/{plugin}` | `research/craft` |

All three plugins use:
- Multi-project config in `.claude/{plugin}.json`
- Project-specific context paths
- Project switcher commands (`waves:project`, `probe:project`, `panel:project`)
- `clientSlug` alignment for hub integration

## Next Steps

### For Panel Standalone (panel)

1. ✅ Config updated - no action needed
2. ⬜ Update commands to use project-config loader
3. ⬜ Test backward compatibility
4. ⬜ Update CLAUDE.md with multi-project info

### For Workspace Monorepo (workspace)

1. ⬜ Move panel plugin to `workspace/plugins/panel/`
2. ⬜ Create `.claude/panel.json` with 5 projects (craft, waves, probe, boost, panel)
3. ⬜ Setup each project: `panel:project <name> && panel:setup`
4. ⬜ Migrate existing research papers if any
5. ⬜ Test multi-project switching

## Benefits

✅ **Unified Research Management** - All plugin research in one monorepo
✅ **Clear Organization** - Each plugin's research in `research/{plugin}/`
✅ **Consistent Pattern** - Matches probe/waves multi-project model
✅ **Backward Compatible** - Standalone installations work unchanged
✅ **Hub Integration** - Per-project clientSlug for event bus
✅ **Flexible Workflow** - Easy switching between plugin research contexts

## Status

**Version**: 1.2.0
**Phase**: Configuration Complete
**Next**: Command Updates
**Target**: Full monorepo support in workspace
