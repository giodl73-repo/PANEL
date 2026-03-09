# Project Config Loader

Multi-project configuration loader for panel. Supports both standalone mode and monorepo mode.

## Purpose

Load the active project configuration from `.claude/panel.json` to determine:
- `researchPath` - Where research papers are stored
- `panelPath` - Where panel context data is stored
- `clientSlug` - Client identifier for hub integration
- `projectName` - Human-readable project name

## Configuration Structure

### Single-Project Mode (Legacy/Standalone)

```json
{
  "default": "panel",
  "projects": {
    "panel": {
      "researchPath": "research",
      "panelPath": "context/panel/panel-dev",
      "clientSlug": "panel-dev",
      "projectName": "panel"
    }
  }
}
```

### Multi-Project Mode (Monorepo)

```json
{
  "default": "craft-research",
  "projects": {
    "craft-research": {
      "researchPath": "research/craft",
      "panelPath": "context/panel/craft-research",
      "clientSlug": "craft-research",
      "projectName": "craft",
      "description": "Craft plugin research papers"
    },
    "waves-research": {
      "researchPath": "research/waves",
      "panelPath": "context/panel/waves-research",
      "clientSlug": "waves-research",
      "projectName": "waves",
      "description": "Waves plugin research papers"
    }
  }
}
```

## Functions

### loadProjectConfig()

Load the active project configuration.

**Returns:**
```javascript
{
  projectName: string,
  researchPath: string,
  panelPath: string,
  reviewersPath: string, // Always context/panel/reviewers (shared across projects)
  clientSlug: string,
  description: string,
  configPath: string,    // Path to .claude/panel.json
  pluginRoot: string     // Plugin installation path (CLAUDE_PLUGIN_ROOT)
}
```

**Implementation:**

```javascript
function loadProjectConfig() {
  const configPath = path.join(process.cwd(), '.claude', 'panel.json');

  // Check if config exists
  if (!fs.existsSync(configPath)) {
    throw new Error('Panel not configured. Run panel:setup first.');
  }

  const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));

  // Get default project name
  const defaultProject = config.default || 'panel';

  // Check if projects object exists (multi-project mode)
  // Resolve pluginRoot: cached value in config takes priority, then env var
  const pluginRoot = config.pluginRoot || process.env.CLAUDE_PLUGIN_ROOT || null;

  // reviewersPath is always the shared reviewers directory, not per-project
  // panelPath might be context/panel/panel-dev but reviewers live at context/panel/reviewers
  const reviewersPath = config.reviewersPath || 'context/panel/reviewers';

  if (config.projects && config.projects[defaultProject]) {
    const project = config.projects[defaultProject];

    return {
      projectName: project.projectName || defaultProject,
      researchPath: project.researchPath || 'research',
      panelPath: project.panelPath || `context/panel/${defaultProject}`,
      reviewersPath,
      clientSlug: project.clientSlug || defaultProject,
      description: project.description || '',
      configPath,
      pluginRoot
    };
  }

  // Legacy mode (no projects object) - use defaults
  return {
    projectName: config.projectName || 'panel',
    researchPath: 'research',
    panelPath: `context/panel/${defaultProject}`,
    reviewersPath,
    clientSlug: config.clientSlug || 'panel-dev',
    description: '',
    configPath,
    pluginRoot
  };
}
```

### getAllProjects()

Get all configured projects.

**Returns:**
```javascript
[
  {
    name: string,
    projectName: string,
    researchPath: string,
    panelPath: string,
    clientSlug: string,
    description: string
  },
  ...
]
```

**Implementation:**

```javascript
function getAllProjects() {
  const configPath = path.join(process.cwd(), '.claude', 'panel.json');

  if (!fs.existsSync(configPath)) {
    return [];
  }

  const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));

  if (!config.projects) {
    // Legacy mode - return single project
    return [{
      name: config.default || 'panel',
      projectName: config.projectName || 'panel',
      researchPath: 'research',
      panelPath: `context/panel/${config.default || 'panel'}`,
      clientSlug: config.clientSlug || 'panel-dev',
      description: ''
    }];
  }

  // Multi-project mode
  return Object.entries(config.projects).map(([name, project]) => ({
    name,
    projectName: project.projectName || name,
    researchPath: project.researchPath || 'research',
    panelPath: project.panelPath || `context/panel/${name}`,
    clientSlug: project.clientSlug || name,
    description: project.description || ''
  }));
}
```

### switchProject(projectName)

Switch the default project.

**Parameters:**
- `projectName` - Name of the project to switch to

**Implementation:**

```javascript
function switchProject(projectName) {
  const configPath = path.join(process.cwd(), '.claude', 'panel.json');

  if (!fs.existsSync(configPath)) {
    throw new Error('Panel not configured. Run panel:setup first.');
  }

  const config = JSON.parse(fs.readFileSync(configPath, 'utf8'));

  // Validate project exists
  if (!config.projects || !config.projects[projectName]) {
    throw new Error(`Project "${projectName}" not found in configuration.`);
  }

  // Update default
  config.default = projectName;

  // Write back
  fs.writeFileSync(configPath, JSON.stringify(config, null, 2), 'utf8');

  return config.projects[projectName];
}
```

## Usage in Commands

### In setup.md

```javascript
// @import ../shared/project-config.md

// Load config to get researchPath
const projectConfig = loadProjectConfig();
const researchDir = path.join(process.cwd(), projectConfig.researchPath);

// Setup research directory
if (!fs.existsSync(researchDir)) {
  fs.mkdirSync(researchDir, { recursive: true });
}
```

### In review.md

```javascript
// @import ../shared/project-config.md

// Load config to get researchPath
const projectConfig = loadProjectConfig();
const researchDir = path.join(process.cwd(), projectConfig.researchPath);

// Find paper
const paperPath = path.join(researchDir, paperName);
```

## Backward Compatibility

The loader supports both legacy (single-project) and new (multi-project) modes:

1. **Legacy mode**: No `projects` object - uses defaults from top-level config
2. **Multi-project mode**: Has `projects` object - uses active project from `default` field

This ensures existing standalone panel installations continue to work without changes.

## Error Handling

- **Missing config**: Throws error with message to run `panel:setup`
- **Invalid project**: Throws error listing available projects
- **Missing researchPath**: Falls back to `"research"` default
