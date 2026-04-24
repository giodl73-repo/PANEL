# Panel Multi-Project Setup Guide

Guide for configuring panel to work in both standalone and monorepo modes, following the probe `testsPath` pattern.

## Overview

Panel now supports multi-project configuration similar to probe's `testsPath` model:
- **Standalone mode**: Research papers in `research/` (current behavior)
- **Monorepo mode**: Research papers in `research/{plugin}/` (new capability)

## Configuration Files

### 1. Updated Panel Config Structure

**File**: `.claude/panel.json`

#### Standalone Mode (C:\src\panel)

```json
{
  "default": "panel",
  "gitStrategy": "auto-commit",
  "suppressMessages": [],
  "projects": {
    "panel": {
      "panelPath": "context/panel/panel-dev",
      "researchPath": "research",
      "clientSlug": "panel-dev",
      "projectName": "panel",
      "description": "Panel standalone research paper management"
    }
  },
  "hubs": {
    "panel": {
      "local": "./.panel-hub",
      "remotes": ["C:/src/panel-hub"],
      "syncMode": "auto"
    }
  }
}
```

#### Monorepo Mode (C:\src\workspace)

```json
{
  "default": "craft-research",
  "gitStrategy": "auto-commit",
  "suppressMessages": [],
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

## Project Config Fields

| Field | Required | Description | Example |
|-------|----------|-------------|---------|
| `panelPath` | Yes | Context data storage path | `"context/panel/craft-research"` |
| `researchPath` | Yes | Research papers directory | `"research/craft"` |
| `clientSlug` | Yes | Hub client identifier | `"craft-research"` |
| `projectName` | Yes | Human-readable name | `"craft"` |
| `targetPlugin` | No | Plugin directory reference | `"plugins/craft"` |
| `description` | No | Project description | `"Craft plugin research papers"` |

## Directory Structure

### Standalone Mode

```
panel/
├── .claude/
│   └── panel.json              # Config with "researchPath": "research"
├── .panel-hub/                 # Local hub
├── research/                   # Research papers
│   ├── panel-paper-1/
│   ├── panel-paper-2/
│   └── RESEARCH.md
└── context/panel/panel-dev/    # Panel context data
```

### Monorepo Mode (Workspace)

```
workspace/
├── .claude/
│   └── panel.json              # Multi-project config
├── .panel-hub/                 # Monorepo-level hub
├── plugins/
│   ├── craft/                  # Plugin implementation
│   ├── waves/
│   └── probe/
├── research/                   # Research organized by plugin
│   ├── craft/                  # Craft research papers
│   │   ├── panel-paper-1/
│   │   ├── panel-paper-2/
│   │   └── RESEARCH.md
│   ├── waves/                  # Waves research papers
│   │   └── RESEARCH.md
│   └── probe/                  # Probe research papers
│       └── RESEARCH.md
├── context/
│   └── panel/
│       ├── craft-research/     # Craft panel context
│       ├── waves-research/     # Waves panel context
│       └── probe-research/     # Probe panel context
└── hubs/
    └── panel/                  # Aggregation hub
```

## Usage

### Setup in Monorepo

```bash
cd C:\src\workspace

# Setup panel for craft research
panel:project craft-research
panel:setup

# Setup panel for waves research
panel:project waves-research
panel:setup

# Add a paper to craft research
panel:project craft-research
panel:setup panel-new-craft-paper "CHI 2026"
```

### Switching Projects

```bash
# List all projects
panel:project

# Switch to craft research
panel:project craft-research

# Switch to waves research
panel:project waves-research

# Check current project
panel:status
```

### Working with Papers

All commands respect the active project's `researchPath`:

```bash
# Review a paper (uses current project's researchPath)
panel:review panel-paper-name

# Show status (shows papers from current project)
panel:status

# Module-level panel review (for current project/module)
panel:module review
```

## Command Updates Required

### 1. Update setup.md

Add project config loading at the beginning:

```javascript
// @import ../shared/project-config.md

// Load project configuration
const projectConfig = loadProjectConfig();
const researchDir = path.join(process.cwd(), projectConfig.researchPath);

// Continue with existing setup logic using researchDir...
```

### 2. Update review.md

```javascript
// @import ../shared/project-config.md

const projectConfig = loadProjectConfig();
const researchDir = path.join(process.cwd(), projectConfig.researchPath);
const paperPath = path.join(researchDir, paperName);
```

### 3. Update status.md

```javascript
// @import ../shared/project-config.md

const projectConfig = loadProjectConfig();
const researchDir = path.join(process.cwd(), projectConfig.researchPath);
const researchMd = path.join(researchDir, 'RESEARCH.md');
```

### 4. Update convene.md

```javascript
// @import ../shared/project-config.md

const projectConfig = loadProjectConfig();
const researchDir = path.join(process.cwd(), projectConfig.researchPath);
```

### 5. Create panel:project command

Create `commands/project.md` for project switching (similar to probe:project and waves:project):

```markdown
---
name: panel:project
description: Switch between panel projects or list all projects
user-invocable: true
---

# panel:project — Project Switcher

Switch between configured panel projects or list all available projects.

## Usage

```bash
# List all projects
panel:project

# Switch to a project
panel:project craft-research
panel:project waves-research
```

## Implementation

```javascript
// @import ../shared/project-config.md
// @import ../shared/message-utils.md

const projectName = args[0];

if (!projectName) {
  // List all projects
  const projects = getAllProjects();
  const config = loadProjectConfig();

  msg('Panel Projects', 'header');

  for (const project of projects) {
    const active = project.name === config.projectName ? ' (active)' : '';
    msg(`• ${project.name}${active}`, 'item');
    msg(`  Research: ${project.researchPath}`, 'subitem');
    msg(`  ${project.description}`, 'subitem');
  }

  return;
}

// Switch project
try {
  switchProject(projectName);
  msg(`Switched to project: ${projectName}`, 'success');
} catch (error) {
  msg(`Error: ${error.message}`, 'error');
}
```
```

## Migration Path

### Existing Standalone Installations

No changes required! The new config format is backward compatible:

1. Old config without `projects` object → Uses legacy defaults
2. New config with `projects` object → Uses multi-project mode

### New Monorepo Setup

1. Create `.claude/panel.json` with multi-project structure
2. Run `panel:setup` for each project
3. Use `panel:project <name>` to switch between projects

## Comparison with Probe Pattern

| Feature | Probe | Panel |
|---------|-------|-------|
| Config file | `.claude/probe.json` | `.claude/panel.json` |
| Multi-project field | `testsPath` | `researchPath` |
| Context field | `probePath` | `panelPath` |
| Project switcher | `probe:project` | `panel:project` |
| Setup command | `probe:setup` | `panel:setup` |
| Default structure | `tests/{plugin}/` | `research/{plugin}/` |

## Benefits

1. **Unified Research Management**: Manage all plugin research papers from one monorepo
2. **Clear Organization**: Each plugin's research in its own directory
3. **Consistent Pattern**: Follows established probe/waves multi-project model
4. **Backward Compatible**: Existing standalone setups continue to work
5. **Hub Integration**: Works with panel's event-driven hub architecture

## Next Steps

1. ✅ Update `.claude/panel.json` with multi-project structure
2. ✅ Create `shared/project-config.md` loader
3. ⬜ Update `commands/setup.md` to use `researchPath`
4. ⬜ Update `commands/review.md` to use `researchPath`
5. ⬜ Update `commands/status.md` to use `researchPath`
6. ⬜ Update `commands/convene.md` to use `researchPath`
7. ⬜ Update `commands/board.md` to use `researchPath`
8. ⬜ Create `commands/project.md` for project switching
9. ⬜ Test in standalone mode (C:\src\panel)
10. ⬜ Test in monorepo mode (C:\src\workspace)

## Example: Adding Panel to Workspace

### Step 1: Create Config

Add to `C:\src\workspace\.claude\panel.json`:

```json
{
  "default": "craft-research",
  "projects": {
    "craft-research": {
      "panelPath": "context/panel/craft-research",
      "researchPath": "research/craft",
      "clientSlug": "craft-research",
      "projectName": "craft",
      "targetPlugin": "plugins/craft",
      "description": "Craft plugin research papers"
    }
  }
}
```

### Step 2: Initialize

```bash
cd C:\src\workspace
panel:setup
```

This will create `research/craft/` with the panel infrastructure.

### Step 3: Add Papers

```bash
panel:setup panel-craft-paper-1 "CHI 2026"
panel:setup panel-craft-paper-2 "NeurIPS 2026"
```

Papers will be created in `research/craft/`.

### Step 4: Review

```bash
panel:review panel-craft-paper-1
panel:status
```

All operations work within `research/craft/` automatically.
